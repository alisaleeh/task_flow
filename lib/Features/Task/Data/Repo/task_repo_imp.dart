import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Task/Data/Data_sources/task_loacal_data_source.dart';
import 'package:taskflow/Features/Task/Data/Data_sources/task_remote_data_source.dart';
import 'package:taskflow/Features/Task/Domain/Entities/subtask_entity.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'package:taskflow/Features/Task/Domain/Repos/task_repo.dart';

class TaskRepoImp extends TaskRepo {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  TaskRepoImp({required this.remoteDataSource, required this.localDataSource});
  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    try {
      await remoteDataSource.createtask(
        title: task.title,
        description: task.subtitle ?? "",
        priority: _mapPriorityToString(task.priority),
        status: _mapStatusToString(task.status),
        dueDate: task.dueDate,
      );
      return Right(task);
    } catch (e) {
      return Left(
        ServerFailure('there is an error while fetching cached data.', 500),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TaskEntity>> getTaskDetails(String taskId) {
    // TODO: implement getTaskDetails
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateTask(
    String taskId,
    TaskStatus status,
    TaskPriority priority,
  ) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SubtaskEntity>> createSubtask(SubtaskEntity subtask) async {
    try {
      var result = await remoteDataSource.createSubtask(
        title: subtask.title,
        description: subtask.subtitle ?? "",
        priority: _mapPriorityToString(subtask.priority),
        status: _mapStatusToString(subtask.status),
        taskId: subtask.taskId,
      );
      return Right(result);
    } catch (e) {
      return Left(
        ServerFailure('there is an error while fetching cached data.', 500),
      );
    }
  }
}
// --- دوال مساعدة لترجمة الـ Enums للغة السيرفر (Documentation) ---

/// لماذا هنا؟ لكي تظل طبقة الـ Data هي المسؤولة عن شكل البيانات المرسلة للسيرفر.
String _mapPriorityToString(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.high:
      return 'HIGH';
    case TaskPriority.medium:
      return 'MEDIUM';
    case TaskPriority.low:
      return 'LOW';
  }
}

String _mapStatusToString(TaskStatus status) {
  switch (status) {
    case TaskStatus.done:
      return 'DONE';
    case TaskStatus.inProgress:
      return 'IN_PROGRESS';
    case TaskStatus.open:
      return 'OPEN';
  }
}
