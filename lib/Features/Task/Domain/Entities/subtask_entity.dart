import 'package:equatable/equatable.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';

class SubtaskEntity extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final String taskId;
  final TaskPriority priority;
  final TaskStatus status;
  final bool isDone;

  const SubtaskEntity({
    required this.id,
    required this.title,
    required this.isDone,
    required this.taskId,
    required this.priority,
    required this.status,
    this.subtitle,
  });

  @override
  List<Object?> get props => [id, title, isDone];
}