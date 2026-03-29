import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskflow/Features/Task/Domain/Entities/subtask_entity.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'package:taskflow/Features/Task/Domain/Use_Cases/create_sub_task_use_case.dart';
import 'package:taskflow/Features/Task/Domain/Use_Cases/create_tesk_use_case.dart';

part 'create_task_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  final CreateTeskUseCase createTeskUseCase;
  final CreateSubTaskUseCase createSubTaskUseCase;

  CreateTaskCubit(this.createTeskUseCase, this.createSubTaskUseCase)
    : super(CreateTaskInitial());

  Future<void> createTask(TaskEntity task) async {
    emit(CreateTaskLoading());

    final result = await createTeskUseCase.createTask(task);

    result.fold(
      (failure) {
        emit(CreateTaskError(failure.errorMessage));
      },
      (newTaskEntity) {
        emit(CreateTaskSuccess(newTaskEntity));
      },
    );
  }

  Future<void> createSubtask(SubtaskEntity subtask) async {
    emit(CreateSubTaskLoading());

    final result = await createSubTaskUseCase.createSubtask(subtask);

    result.fold(
      (failure) {
        emit(CreateSubTaskError(failure.errorMessage));
      },
      (newSubtaskEntity) {
        emit(CreateSubTaskSuccess(newSubtaskEntity));
      },
    );
  }
}
