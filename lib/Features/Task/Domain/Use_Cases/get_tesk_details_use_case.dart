import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'package:taskflow/Features/Task/Domain/Repos/task_repo.dart';

class GetTeskDetailsUseCase {
  final TaskRepo taskRepo;

  GetTeskDetailsUseCase({required this.taskRepo});

    Future<Either<Failure, TaskEntity>> getTaskDetails(String taskId){
    return taskRepo.getTaskDetails(taskId);
    }

}