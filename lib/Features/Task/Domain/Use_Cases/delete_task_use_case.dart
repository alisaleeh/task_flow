import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Task/Domain/Repos/task_repo.dart';

class DeleteTaskUseCase {
  final TaskRepo taskRepo;

  DeleteTaskUseCase({required this.taskRepo});
  Future<Either<Failure, void>> deleteTask(String taskId) {
    return taskRepo.deleteTask(taskId);
  }
}
