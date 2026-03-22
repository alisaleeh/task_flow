import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Calendar/Domain/Repos/calendar_repo.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';

class GetTasksForDateUseCase {
  final CalendarRepo calendarRepo;

  GetTasksForDateUseCase({required this.calendarRepo});
  Future<Either<Failure, List<TaskEntity>>> getTasksForDate(DateTime date) {
    return calendarRepo.getTasksForDate(date);
  }
}
