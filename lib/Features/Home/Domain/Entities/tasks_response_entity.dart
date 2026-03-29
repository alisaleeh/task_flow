import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'task_summary_entity.dart';

class TasksResponseEntity {
  final List<TaskEntity> tasks;
  final TaskSummaryEntity summary;

  TasksResponseEntity({
    required this.tasks,
    required this.summary,
  });
}