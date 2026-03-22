class TaskEntity {
  final String id;
  final String title;
  final String? subtitle;
  final String status; 
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