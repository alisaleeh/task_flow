import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/Features/Auth/Domain/Entities/user_entity.dart';
import 'package:taskflow/Features/Auth/Domain/Use_Cases/register_use_case.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.registerUseCase) : super(RegisterInitial());
  final RegisterUseCase registerUseCase;

  Future<void> register(String fullName, String email, String password) async {
    emit(RegisterLoading());
    final result = await registerUseCase.register(fullName, email, password);
    result.fold(
      (failure) => emit(RegisterFailure(failure.errorMessage)),
      (userEntity) => emit(RegisterSuccess(userEntity)),
    );
  }
}
