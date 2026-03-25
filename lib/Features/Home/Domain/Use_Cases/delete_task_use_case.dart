import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Home/Domain/Repos/home_repo.dart';

class DeleteTaskUseCase {
  final HomeRepo homeRepo;

  DeleteTaskUseCase({ required this.homeRepo});

  Future<Either<Failure, void>> call(String taskId) {
    return homeRepo.deleteTask(taskId);
  }
}
