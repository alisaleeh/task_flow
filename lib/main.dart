import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_routes.dart';
import 'package:taskflow/Core/Utils/app_bloc_observer.dart';
import 'package:taskflow/Core/Utils/service_locator.dart';
import 'package:taskflow/Features/Auth/Presentation/Manager/login_cubit/login_cubit.dart';
import 'package:taskflow/Features/Auth/Presentation/Manager/register_cubit/register_cubit.dart';
import 'package:taskflow/Features/Home/Presentation/Manager/Task_cubit/task_cubit.dart';
import 'package:taskflow/Features/Task/Presentation/Manager/cubit/create_task_cubit.dart';
import 'package:taskflow/Features/Auth/Presentation/View/forgot_password_screen.dart';
import 'package:taskflow/Features/Auth/Presentation/View/login_screen.dart';
import 'package:taskflow/Features/Auth/Presentation/View/sign_up_screen.dart';
import 'package:taskflow/Features/Auth/Presentation/View/verification_screen.dart';
import 'package:taskflow/Features/Calendar/Presentation/View/calendar_screen.dart';
import 'package:taskflow/Features/Task/Presentation/View/create_task_screen.dart';
import 'package:taskflow/Features/Home/Presentation/View/home_screen.dart';
import 'package:taskflow/Features/Home/Presentation/View/main_layout_screen.dart';
import 'package:taskflow/Features/Task/Presentation/View/task_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // 🚀 السحر هنا: استخدام MultiBlocProvider لتوفير الكيوبتات الأساسية لكل التطبيق
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt<TaskCubit>()),
            BlocProvider(create: (context) => getIt<CreateTaskCubit>()), // 👈 أصبح متاحاً الآن في شاشة التفاصيل!
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'TaskFlow',
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.backgroundColor,
              primaryColor: AppColors.primaryOrange,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primaryOrange,
                primary: AppColors.primaryOrange,
              ),
            ),
            initialRoute: AppRoutes.login,
            routes: {
              AppRoutes.login: (context) => BlocProvider(
                    create: (context) => getIt<LoginCubit>(),
                    child: LoginScreen(),
                  ),
              AppRoutes.signUp: (context) => BlocProvider(
                    create: (context) => getIt<RegisterCubit>(),
                    child: SignUpScreen(),
                  ),
              AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
              AppRoutes.verification: (context) => const VerificationScreen(),
              AppRoutes.home: (context) => const HomeScreen(), // 👈 لم نعد بحاجة لـ Provider هنا لأنه صار Global
              AppRoutes.createTask: (context) => const CreateTaskScreen(), // 👈 نفس الشيء هنا
              AppRoutes.taskDetails: (context) => const TaskDetailsScreen(), // 👈 الآن ستعمل بدون خطأ!
              AppRoutes.calendar: (context) => const CalendarScreen(),
              AppRoutes.mainLayout: (context) => const MainLayoutScreen(),
            },
          ),
        );
      },
    );
  }
}