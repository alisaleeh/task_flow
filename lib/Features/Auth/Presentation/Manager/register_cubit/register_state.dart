part of 'register_cubit.dart';

@immutable
//the sealed class 
/*
استخدمناه ليجبرنا على تغطية كل الحالات عند التطبيق بالواجهة 
{loading,failure,success}
*/
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterFailure extends RegisterState {
  final String errorMessage;
  RegisterFailure(this.errorMessage);
}

final class RegisterSuccess extends RegisterState {
final UserEntity userEntity;
  RegisterSuccess(this.userEntity);
}
