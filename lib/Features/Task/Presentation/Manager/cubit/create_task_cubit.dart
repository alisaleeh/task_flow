import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_task_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  CreateTaskCubit() : super(CreateTaskInitial());
}
