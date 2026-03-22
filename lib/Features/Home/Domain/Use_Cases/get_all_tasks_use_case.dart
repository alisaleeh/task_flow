import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'package:taskflow/Features/Home/Domain/Repos/home_repo.dart';

class GetAllTasksUseCase {
  final HomeRepo homeRepo;
  GetAllTasksUseCase({required this.homeRepo});

  Future<Either<Failure, List<TaskEntity>>> call() {
    return homeRepo.getAllTasks();
  }
}