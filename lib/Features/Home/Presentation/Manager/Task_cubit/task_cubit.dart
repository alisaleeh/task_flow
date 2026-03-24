import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/Features/Home/Domain/Use_Cases/get_all_tasks_use_case.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit(this.getAllTasksUseCase) : super(TaskInitial());
  final GetAllTasksUseCase getAllTasksUseCase;
  Future<void> fetchalltasks() async {
    try {
      emit(TaskLoading());
      var result = await getAllTasksUseCase.call();
      result.fold(
        (failure) => emit(TaskFailure(errorMessage: failure.errorMessage)),
        (tasks) => emit(TaskSuccess(task: tasks)),
      );
    } catch (e) {
      emit(
        TaskFailure(errorMessage: "An error occurred while fetching tasks."),
      );
    }
  }
}
