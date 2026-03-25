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
// --- Home Imports ---
import 'package:taskflow/Features/Home/Data/Data_sources/home_local_data_source.dart';
import 'package:taskflow/Features/Home/Data/Data_sources/home_remote_data_source.dart';
import 'package:taskflow/Features/Home/Data/Repos/home_repo_imp.dart';
import 'package:taskflow/Features/Home/Domain/Repos/home_repo.dart';
import 'package:taskflow/Features/Home/Domain/Use_Cases/get_all_tasks_use_case.dart';
import 'package:taskflow/Features/Home/Presentation/Manager/Task_cubit/task_cubit.dart';
import 'package:taskflow/Features/Task/Data/Data_sources/task_loacal_data_source.dart';
// --- Task (Create) Imports ---
import 'package:taskflow/Features/Task/Data/Data_sources/task_remote_data_source.dart';
import 'package:taskflow/Features/Task/Data/Repo/task_repo_imp.dart';
import 'package:taskflow/Features/Task/Domain/Repos/task_repo.dart';
import 'package:taskflow/Features/Task/Domain/Use_Cases/create_tesk_use_case.dart';
import 'package:taskflow/Features/Task/Presentation/Manager/cubit/create_task_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ==========================================
  // 1. Core & External
  // ==========================================
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.interceptors.add(ApiLoggerInterceptor());
    return dio;
  });

  getIt.registerLazySingleton<ApiService>(() => ApiService(dio: getIt<Dio>()));

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ==========================================
  // 2. Auth Feature
  // ==========================================
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sharedPreferences: getIt()));

  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImp(remoteDataSource: getIt(), localDataSource: getIt()));

  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(authRepo: getIt()));
  getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(authRepo: getIt()));
  getIt.registerLazySingleton<CreateTeskUseCase>(() => CreateTeskUseCase(taskRepo: getIt()));

  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerFactory<RegisterCubit>(() => RegisterCubit(getIt()));

  // ==========================================
  // 3. Home Feature (Fetch Tasks)
  // ==========================================
  getIt.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImp(apiService: getIt()));
  getIt.registerLazySingleton<HomeLocalDataSource>(() => HomeLocalDataSourceImpl(sharedPreferences: getIt()));

  getIt.registerLazySingleton<HomeRepo>(() => HomeRepoImp(remoteDataSource: getIt(), localDataSource: getIt()));

  getIt.registerLazySingleton<GetAllTasksUseCase>(() => GetAllTasksUseCase(homeRepo: getIt()));

  getIt.registerFactory<TaskCubit>(() => TaskCubit(getIt()));

  // ==========================================
  // 4. Task Feature (Create Task) 👈 الإضافة الجديدة هنا
  // ==========================================
  getIt.registerLazySingleton<TaskRemoteDataSource>(() => TaskRemoteDataSourceImpl(apiService: getIt()));
  getIt.registerLazySingleton<TaskLocalDataSource>(() => TaskLocalDataSourceImpl(sharedPreferences: getIt()));

  getIt.registerLazySingleton<TaskRepo>(() => TaskRepoImp(remoteDataSource: getIt(), localDataSource: getIt()));


  getIt.registerFactory<CreateTaskCubit>(() => CreateTaskCubit(getIt()));
}