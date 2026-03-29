part of 'task_cubit.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskSuccess extends TaskState {
  final List<TaskEntity> task;
  final TaskSummaryEntity? taskSummaryEntity;

  TaskSuccess({required this.task, this.taskSummaryEntity});
}

final class TaskFailure extends TaskState {
  final String errorMessage;

  TaskFailure({required this.errorMessage});
}

final class DeleteTaskLoading extends TaskState {}

final class DeleteTaskSuccess extends TaskState {}

final class DeleteTaskError extends TaskState {
  final String errormessage;

  DeleteTaskError({required this.errormessage});
}

final class UpdateTaskError extends TaskState {
  final String errormessage;
  UpdateTaskError(this.errormessage);
}

