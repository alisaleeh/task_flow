import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskflow/Core/Utils/api_service.dart';
import 'package:taskflow/Features/Auth/Data/Data_sources/local_data_source.dart';
import 'package:taskflow/Features/Auth/Data/Data_sources/remote_data_source.dart';
import 'package:taskflow/Features/Auth/Data/Repos/auth_repo_imp.dart';
import 'package:taskflow/Features/Auth/Domain/Repo/auth_repo.dart';
import 'package:taskflow/Features/Auth/Domain/Use_Cases/login_use_case.dart';
import 'package:taskflow/Features/Auth/Domain/Use_Cases/register_use_case.dart';
import 'package:taskflow/Features/Auth/Presentation/Manager/login_cubit/login_cubit.dart';
import 'package:taskflow/Features/Auth/Presentation/Manager/register_cubit/register_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1. Core & External (الأساسيات)
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio: getIt<Dio>()));

  // تهيئة SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // 2. Data Sources (مصادر البيانات)
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()), 
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: getIt()), 
  );

  // 3. Repositories (المستودعات)
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImp(remoteDataSource: getIt(), localDataSource: getIt()),
  );

  // 4. Use Cases (حالات الاستخدام)
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(authRepo: getIt()),
  );
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(authRepo: getIt()),
  );

  // 5. Blocs & Cubits (مدراء الحالة)
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt()),
  );
  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(getIt()),
  );
}