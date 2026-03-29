import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Home/Domain/Entities/tasks_response_entity.dart';
import 'package:taskflow/Features/Home/Domain/Repos/home_repo.dart';

class GetAllTasksUseCase {
  final HomeRepo homeRepo;
  GetAllTasksUseCase({required this.homeRepo});

  Future<Either<Failure, TasksResponseEntity>> call() {
    return homeRepo.getAllTasks();
  }
  
}