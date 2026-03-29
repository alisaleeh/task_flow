import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Home/Domain/Entities/tasks_response_entity.dart';
import 'package:taskflow/Features/Home/Domain/Entities/task_summary_entity.dart';

abstract class HomeRepo{
Future<Either<Failure,TasksResponseEntity>> getAllTasks();
Future<Either<Failure,TaskSummaryEntity>> getTaskSummary();
Future<Either<Failure,void>> deleteTask(String taskId);
Future<Either<Failure,void>> updateTask(String taskId,String? status,String? priority);
}