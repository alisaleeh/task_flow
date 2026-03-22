enum TaskStatus { todo, inProgress, done }
class TaskEntity {
  final String id;
  final String title;
  final String? subtitle;
  final TaskStatus status; 
  final String time;
  final bool isCompleted;

  const TaskEntity({
    required this.id,
    required this.title,
    this.subtitle,
    required this.status,
    required this.time,
    required this.isCompleted,
  });
}