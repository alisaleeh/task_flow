import 'package:equatable/equatable.dart';

class SubtaskEntity extends Equatable {
  final String id;
  final String title;
  final bool isDone;

  const SubtaskEntity({
    required this.id,
    required this.title,
    required this.isDone,
  });

  @override
  List<Object?> get props => [id, title, isDone];
}