import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Auth/Domain/Entities/user_entity.dart';
import 'package:taskflow/Features/Auth/Domain/Repo/auth_repo.dart';

class RegisterUseCase {
  final AuthRepo authRepo;

  RegisterUseCase({required this.authRepo});

  Future<Either<Failure, UserEntity>> register(
    String fullName,
    String email,
    String password,
  ) {
    return authRepo.register(fullName, email, password);
  }
}
