import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart'; // 👈 تأكد من استيراد Dio
import 'package:taskflow/Core/Utils/failure.dart'; // 👈 مسار ملف الأخطاء الخاص بك
import 'package:taskflow/Features/Auth/Data/Data_sources/local_data_source.dart';
import 'package:taskflow/Features/Auth/Data/Data_sources/remote_data_source.dart';
import 'package:taskflow/Features/Auth/Domain/Entities/user_entity.dart';
import 'package:taskflow/Features/Auth/Domain/Repo/auth_repo.dart';

class AuthRepoImp extends AuthRepo {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  
  AuthRepoImp({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final result = await remoteDataSource.login(email, password);
      final UserEntity userEntity = result.$1;
      final String token = result.$2;
      await localDataSource.cacheUser(result.$1, token);
      return Right(userEntity);
      
    } on AppException catch (e) {
      // 👈 السر هنا! إذا كان الخطأ قادماً من dioRequest نعرض الرسالة العربية الأنيقة
      return Left(e.failure);
      
    } on DioException catch (e) {
      // 👈 احتياطاً: إذا لم تكن تستخدم dioRequest في الـ DataSource
      return Left(ServerFailure.fromDioError(e));
      
    } catch (e) {
      // 👈 أخطاء برمجية أخرى (مثل خطأ في تحويل البيانات)
      return Left(ServerFailure(e.toString(), 500));
    }
  }

  @override
Future<Either<Failure, UserEntity>> register(
  String firstName, String lastName, String email, String password,
) async {
  try {
    final userEntity = await remoteDataSource.register(firstName, lastName, email, password);
    
    // ❌ لا نقوم بحفظ التوكن هنا، لأن السيرفر لم يرجع توكن. 
    // المستخدم سيسجل دخوله في الشاشة التالية لأخذ التوكن.
    
    return Right(userEntity);
    
  } on AppException catch (e) {
    return Left(e.failure);
  } on DioException catch (e) {
    return Left(ServerFailure.fromDioError(e));
  } catch (e) {
    return Left(ServerFailure("حدث خطأ غير متوقع في التطبيق.", 500));
  }
}
}