import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Auth/Domain/Entities/user_entity.dart';
import 'package:taskflow/Features/Auth/Domain/Repo/auth_repo.dart';

class LoginUseCase {
  final AuthRepo authRepo;

  LoginUseCase({required this.authRepo});

  Future<Either<Failure, UserEntity>> login(String email, String password) {
    return authRepo.login(email, password);
  }
}