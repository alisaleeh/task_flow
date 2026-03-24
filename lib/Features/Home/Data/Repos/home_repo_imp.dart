import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Home/Data/Data_sources/home_local_data_source.dart';
import 'package:taskflow/Features/Home/Data/Data_sources/home_remote_data_source.dart';
import 'package:taskflow/Features/Home/Data/Models/task_model.dart';
import 'package:taskflow/Features/Home/Domain/Entities/task_summary_entity.dart';
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
  Future<Either<Failure, List<TaskEntity>>> getAllTasks() async {
    try {
      final remoteTasks = await remoteDataSource.fetchAllTasks();
      await localDataSource.cacheTasks(
        remoteTasks.map((e) => e as TaskModel).toList(),
      );
      return Right(remoteTasks);
    } catch (e) {
      try {
        final localTasks = await localDataSource.getCachedTasks();
        if (localTasks.isNotEmpty) {
          return Right(localTasks);
        } else {
          return Left(
            ServerFailure(
              'there is no internet connection and no cached data available.',
              503,
            ),
          );
        }
      } catch (cacheError) {
        return Left(ServerFailure('there is an error while fetching cached data.', 500));
      }
    }
  }

  @override
  Future<Either<Failure, TaskSummaryEntity>> getTaskSummary() async {
    // سيتم تطبيق نفس المنطق الهندسي (الذهاب للنت ثم الكاش) هنا لاحقاً
    throw UnimplementedError();
  }
}
