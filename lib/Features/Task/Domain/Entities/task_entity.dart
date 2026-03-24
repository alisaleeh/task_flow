import 'package:equatable/equatable.dart';
import 'subtask_entity.dart';

enum TaskStatus { todo, inProgress, done }
enum TaskPriority { low, medium, high }

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final TaskStatus status;
  final DateTime dueDate;
  final List<SubtaskEntity> subtasks;
  final TaskPriority priority;

  const TaskEntity({
    required this.id,
    required this.title,
    this.subtitle,
    required this.status,
    required this.dueDate,
    this.subtasks = const [],
    this.priority = TaskPriority.medium,
  });

  // 👈 تُحسب تلقائياً ولا داعي لتمريرها في الـ Constructor
  bool get isCompleted => status == TaskStatus.done;

  double get subtasksProgress {
    if (subtasks.isEmpty) return 0.0;
    final completedCount = subtasks.where((sub) => sub.isDone).length;
    return completedCount / subtasks.length;
  }

  @override
  List<Object?> get props => [id, title, subtitle, status, dueDate, subtasks, priority];
}