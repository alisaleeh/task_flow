import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Home/Domain/Repos/home_repo.dart';

class UpdateTaskUseCase {
  final HomeRepo homeRepo;
  UpdateTaskUseCase({required this.homeRepo});
  Future<Either<Failure, void>> call(
    String taskId,
    String? status,
    String? priority,
  ) {
    return homeRepo.updateTask(taskId, status, priority);
  }
}
