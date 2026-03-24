import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskflow/Core/Utils/api_logger.dart';
import 'package:taskflow/Core/Utils/api_service.dart';
// --- Auth Imports ---
import 'package:taskflow/Features/Auth/Data/Data_sources/local_data_source.dart';
import 'package:taskflow/Features/Auth/Data/Data_sources/remote_data_source.dart';
import 'package:taskflow/Features/Auth/Data/Repos/auth_repo_imp.dart';
import 'package:taskflow/Features/Auth/Domain/Repo/auth_repo.dart';
import 'package:taskflow/Features/Auth/Domain/Use_Cases/login_use_case.dart';
import 'package:taskflow/Features/Auth/Domain/Use_Cases/register_use_case.dart';
import 'package:taskflow/Features/Auth/Presentation/Manager/login_cubit/login_cubit.dart';
import 'package:taskflow/Features/Auth/Presentation/Manager/register_cubit/register_cubit.dart';
import 'package:taskflow/Features/Home/Data/Data_sources/home_remote_data_source.dart';
import 'package:taskflow/Features/Home/Data/Repos/home_repo_imp.dart';
import 'package:taskflow/Features/Home/Domain/Repos/home_repo.dart';
import 'package:taskflow/Features/Home/Domain/Use_Cases/get_all_tasks_use_case.dart';
import 'package:taskflow/Features/Home/Presentation/Manager/Task_cubit/task_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ==========================================
  // 1. Core & External (الأساسيات)
  // ==========================================
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    // تركيب كاميرا المراقبة لمعرفة ما يحدث في الـ API
    dio.interceptors.add(ApiLoggerInterceptor());
    return dio;
  });

  getIt.registerLazySingleton<ApiService>(() => ApiService(dio: getIt<Dio>()));

  // تهيئة SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ==========================================
  // 2. Auth Feature (قسم المصادقة)
  // ==========================================
  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImp(remoteDataSource: getIt(), localDataSource: getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(authRepo: getIt()),
  );
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(authRepo: getIt()),
  );

  // Cubits
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerFactory<RegisterCubit>(() => RegisterCubit(getIt()));

  // ==========================================
  // 3. Home / Tasks Feature (قسم المهام) 👈 التعديل الجديد هنا
  // ==========================================

  // Data Source (تأكد من اسم الكلاس الخاص بك)
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImp(
      apiService: getIt(),
    ), // أو حسب ما يتطلبه الـ Constructor عندك
  );

  // Repository
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImp(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ), // أضف الـ LocalDataSource لو كان موجوداً
  );

  // Use Case
  getIt.registerLazySingleton<GetAllTasksUseCase>(
    () => GetAllTasksUseCase(homeRepo: getIt()),
  );

  // Cubit
  getIt.registerFactory<TaskCubit>(() => TaskCubit(getIt()));
}
