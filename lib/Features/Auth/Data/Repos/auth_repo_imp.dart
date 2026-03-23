// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Auth/Data/Data_sources/local_data_source.dart';
import 'package:taskflow/Features/Auth/Data/Data_sources/remote_data_source.dart';
import 'package:taskflow/Features/Auth/Domain/Entities/user_entity.dart';
import 'package:taskflow/Features/Auth/Domain/Repo/auth_repo.dart';

class AuthRepoImp extends AuthRepo {
  RemoteDataSource remoteDataSource;
  AuthLocalDataSource localDataSource;
  AuthRepoImp({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final result = await remoteDataSource.login(email, password);
      final UserEntity userEntity = result.$1; // استخراج UserModel من الـ Tuple
      final String token = result.$2; // استخراج التوكن من الـ Tuple
      await localDataSource.cacheUser(result.$1, token);
      return Right(userEntity);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: ${e.toString()}", 500));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      final result = await remoteDataSource.register(fullName, email, password);
      final UserEntity userEntity = result.$1; // استخراج UserModel من الـ Tuple
      final String token = result.$2; // استخراج التوكن من الـ Tuple
      await localDataSource.cacheUser(result.$1, token);
      return Right(userEntity);
    } catch (e) {
      return Left(ServerFailure(e.toString(), 500));
    }
  }
}
