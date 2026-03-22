class TaskSummaryEntity {
  final int totalTasksToday;
  final int completedTasks;
  final double completionPercentage; // e.g., 0.5 (50%)

  const TaskSummaryEntity({required this.totalTasksToday, required this.completedTasks, required this.completionPercentage});
}