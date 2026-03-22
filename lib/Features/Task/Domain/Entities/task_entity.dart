import 'subtask_entity.dart';

enum TaskStatus { todo, inProgress, done }
enum TaskPriority { low, medium, high }

class TaskEntity {
  final String id;
  final String title;
  final String? subtitle;
  final TaskStatus status;
  final DateTime dueDate;
  final List<SubtaskEntity> subtasks; // 👈 المهام الفرعية تعيش داخل المهمة الرئيسية
  final TaskPriority priority; // 👈 أضفنا أولوية للمهمة 
  const TaskEntity({
    required this.id,
    required this.title,
    this.subtitle,
    required this.status,
    required this.dueDate,
    this.subtasks = const [], required bool isCompleted,
    this.priority = TaskPriority.medium, 
  });

  bool get isCompleted => status == TaskStatus.done;

  double get subtasksProgress {
    if (subtasks.isEmpty) return 0.0;
    final completedCount = subtasks.where((sub) => sub.isDone).length;
    return completedCount / subtasks.length;
  }
}