import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'package:taskflow/Features/Task/Domain/Repos/task_repo.dart';

class CreateTeskUseCase {
  final TaskRepo taskRepo;

  CreateTeskUseCase({required this.taskRepo});
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) {
    return taskRepo.createTask(task);
  }
}
