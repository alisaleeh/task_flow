import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Task/Domain/Entities/subtask_entity.dart';
import 'package:taskflow/Features/Task/Domain/Repos/task_repo.dart';

class CreateSubTaskUseCase {
  final TaskRepo taskRepo;

  CreateSubTaskUseCase({required this.taskRepo});
  Future<Either<Failure, SubtaskEntity>> createSubtask(SubtaskEntity subtask) {
    return taskRepo.createSubtask(subtask);
  }
}
