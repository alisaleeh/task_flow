import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'package:taskflow/Features/Task/Domain/Repos/task_repo.dart';

class UpdateTaskUseCase {
  final TaskRepo taskRepo;

  UpdateTaskUseCase({required this.taskRepo});
  Future<Either<Failure, void>> updateTask(
    String taskId,
    TaskStatus status,
    TaskPriority priority,
  ) {
    return taskRepo.updateTask(taskId, status, priority);
  }
}
