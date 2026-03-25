import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';

abstract class TaskRepo {
  Future<Either<Failure, TaskEntity>> getTaskDetails(String taskId);
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task);
  Future<Either<Failure, void>> updateTask(
    String taskId,
    TaskStatus status,
    TaskPriority priority,
  );
  Future<Either<Failure, void>> deleteTask(String taskId);
}
