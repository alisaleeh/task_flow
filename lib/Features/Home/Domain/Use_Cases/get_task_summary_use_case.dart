import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Home/Domain/Entities/task_summary_entity.dart';
import 'package:taskflow/Features/Home/Domain/Repos/home_repo.dart';

class GetTaskSummaryUseCase {
  final HomeRepo homeRepo;
  GetTaskSummaryUseCase({required this.homeRepo});

  Future<Either<Failure, TaskSummaryEntity>> call() {
    return homeRepo.getTaskSummary();
  }
}
