import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';

abstract class CalendarRepo {
  Future<Either<Failure, List<TaskEntity>>> getTasksForDate(DateTime date);
}
