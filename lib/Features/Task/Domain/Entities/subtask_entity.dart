class SubtaskEntity {
  final String id;
  final String title;
  final bool isDone;

  const SubtaskEntity({
    required this.id,
    required this.title,
    this.isDone = false,
  });
}