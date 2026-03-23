import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/Features/Auth/Domain/Entities/user_entity.dart';
import 'package:taskflow/Features/Auth/Domain/Use_Cases/login_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.loginUseCase) : super(LoginInitial());
  final LoginUseCase loginUseCase;
  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    final result = await loginUseCase.login(email, password);
    result.fold(
      (failure) => emit(LoginFailure(failure.errorMessage)),
      (userEntity) => emit(LoginSuccess(userEntity)),
    );
  }
}
