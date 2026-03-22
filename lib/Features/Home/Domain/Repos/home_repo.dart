import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'package:taskflow/Features/Home/Domain/Entities/task_summary_entity.dart';

abstract class HomeRepo{
Future<Either<Failure,List<TaskEntity>>> getAllTasks();
Future<Either<Failure,TaskSummaryEntity>> getTaskSummary();
}