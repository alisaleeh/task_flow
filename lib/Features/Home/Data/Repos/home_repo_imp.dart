import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Home/Data/Data_sources/home_local_data_source.dart';
import 'package:taskflow/Features/Home/Data/Data_sources/home_remote_data_source.dart';
import 'package:taskflow/Features/Home/Data/Models/task_model.dart';
import 'package:taskflow/Features/Home/Domain/Entities/task_summary_entity.dart';
import 'package:taskflow/Features/Home/Domain/Entities/tasks_response_entity.dart';
import 'package:taskflow/Features/Home/Domain/Repos/home_repo.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';

/*
 هذا الملف يمثل تطبيق الـ Repository لواجهة HomeRepo
  يقوم بتنفيذ المنطق الهندسي التالي:
  1. يحاول جلب البيانات من الإنترنت (السيرفر) أولاً
  2. إذا نجح، يخزن نسخة في الذاكرة المحلية (الكاش) للرجوع إليها لاحقاً
  3. إذا فشل (مثلاً لا يوجد إنترنت)، يحاول جلب البيانات من الذاكرة المحلية
  4. إذا لم يكن هناك بيانات في الذاكرة المحلية أيضاً، يرجع خط
  5. في كل خطوة، يتم التعامل مع الأخطاء بشكل مناسب وإرجاعها في الجانب الأيسر (Left) من الـ Either
  6. في حالة نجاح أي خطوة، يتم إرجاع البيانات في الجانب الأيمن (Right) من الـ Either
*/
class HomeRepoImp extends HomeRepo {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;

  HomeRepoImp({required this.remoteDataSource, required this.localDataSource});

  @override
  @override
  Future<Either<Failure, TasksResponseEntity>> getAllTasks() async {
    try {
      // 1. جلب البيانات من السيرفر (ترجع TasksResponseModel الذي يحتوي مهام + ملخص)
      final remoteResponse = await remoteDataSource.fetchAllTasks();
      // 2. تخزين البيانات في الذاكرة المحلية (الكاش) للرجوع إليها لاحقاً
      final models = remoteResponse.tasks.map((e) => e as TaskModel).toList();
      //هون خزنا المهام و الملخص بالكاش 
      await localDataSource.cacheTasks(models);
      await localDataSource.cacheTaskSummary(remoteResponse.summary);
      
      // 3. إرجاع الكيان الجامع بنجاح
      return Right(remoteResponse);
      
    } catch (e) {
      try {
        // 4. انقطع الإنترنت! جلب المهام من الذاكرة المحلية
        final localTasks = await localDataSource.getCachedTasks();
        //اذا كان في مهام بالكاش 
        if (localTasks.isNotEmpty) {
          // جلب الملخص من الكاش 
          final cachedSummary = await localDataSource.getCachedTaskSummary();
          final TaskSummaryEntity localSummary;
           // منفحص الملخص اللي اجا من الكاش 
          if (cachedSummary != null) {
             // اذا كان موجود في الكاش نستخدمه
            localSummary = cachedSummary;
          } else {
            // اذا ما كان موجود في الكاش نحسبه من المهام اللي عندنا في الكاش
            final completed =
                localTasks.where((t) => t.status == TaskStatus.done).length;
            final total = localTasks.length;
            final percentage =
                total == 0 ? 0.0 : (completed / total) * 100;
            localSummary = TaskSummaryEntity(
              totalTasksToday: total,
              completedTasks: completed,
              completionPercentage: percentage,
            );
          }

          // تغليف المهام المحلية والملخص المحلي في كيان واحد
          final localResponse = TasksResponseEntity(
            tasks: localTasks, 
            summary: localSummary,
          );

          return Right(localResponse);
        } else {
          return Left(
            ServerFailure('there is no internet connection and no cached data available.', 503),
          );
        }
      } catch (cacheError) {
        return Left(
          ServerFailure('there is an error while fetching cached data.', 500),
        );
      }
    }
  }

  @override
  Future<Either<Failure, TaskSummaryEntity>> getTaskSummary() async {
    try {
      // 1. جلب ملخص المهام من السيرفر
      final summary = await remoteDataSource.fetchTasksSummary();
      // 2. تخزين الملخص في الذاكرة المحلية (الكاش) للرجوع إليه لاحقاً
      await localDataSource.cacheTaskSummary(summary);
      return Right(summary);
    } catch (e) {
      return Left(
        ServerFailure('Failed to fetch task summary. Please try again.', 500),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
      await remoteDataSource.deleteTask(taskId);
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure('Failed to delete task. Please try again.', 500),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(
    String taskId,
    String? status,
    String? priority,
  ) async {
    try {
      await remoteDataSource.updateTask(taskId, status, priority);
      return const Right(null);
    } catch (e) {
      return Future.value(
        Left(ServerFailure('Failed to update task. Please try again.', 500)),
      );
    }
  }
}
