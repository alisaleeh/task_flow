import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Auth/Domain/Entities/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> login(String email, String password);

  Future<Either<Failure, UserEntity>> register(
    String firstName,
    String lastName,
    String email,
    String password,
  );
}
