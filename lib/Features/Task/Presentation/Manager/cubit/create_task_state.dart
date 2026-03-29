part of 'create_task_cubit.dart';

sealed class CreateTaskState extends Equatable {
  const CreateTaskState();

  @override
  List<Object> get props => [];
}

final class CreateTaskInitial extends CreateTaskState {}
final class CreateTaskLoading extends CreateTaskState {}
final class CreateTaskSuccess extends CreateTaskState {
  final TaskEntity createdTask;

  const CreateTaskSuccess(this.createdTask);

  @override
  List<Object> get props => [createdTask];
}
final class CreateTaskError extends CreateTaskState {
  final String message;

  const CreateTaskError(this.message);

  @override
  List<Object> get props => [message];
}
final class CreateSubTaskSuccess extends CreateTaskState {
  final SubtaskEntity createdSubtask;

  const CreateSubTaskSuccess(this.createdSubtask);

  @override
  List<Object> get props => [createdSubtask];
}
final class CreateSubTaskError extends CreateTaskState {
  final String message;

  const CreateSubTaskError(this.message);

  @override
  List<Object> get props => [message];
}
final class CreateSubTaskLoading extends CreateTaskState {}

