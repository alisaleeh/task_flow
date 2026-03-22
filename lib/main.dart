import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// تأكد من صحة هذه المسارات لديك
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_routes.dart';
import 'package:taskflow/Features/Auth/Presentation/View/forgot_password_screen.dart';
import 'package:taskflow/Features/Auth/Presentation/View/login_screen.dart';
import 'package:taskflow/Features/Auth/Presentation/View/sign_up_screen.dart';
import 'package:taskflow/Features/Auth/Presentation/View/verification_screen.dart';
import 'package:taskflow/Features/Home/Presentation/View/calendar_screen.dart';
import 'package:taskflow/Features/Home/Presentation/View/create_task_screen.dart';
import 'package:taskflow/Features/Home/Presentation/View/home_screen.dart';
import 'package:taskflow/Features/Home/Presentation/View/main_layout_screen.dart';
import 'package:taskflow/Features/Home/Presentation/View/task_details_screen.dart';

void main() {
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TaskFlow',

          // --- بناء الثيم العام للتطبيق (Global Theme) ---
          theme: ThemeData(
            scaffoldBackgroundColor:
                AppColors.backgroundColor, // استخدام لونك المخصص
            primaryColor: AppColors.primaryOrange,

            // تهيئة نظام الألوان ليتبع هويتك البرتقالية
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryOrange,
              primary: AppColors.primaryOrange,
            ),

            // السحر هنا: التحكم الكامل بألوان حقول الإدخال (TextFields)
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.primaryOrange, // 1. لون المؤشر النابض
              selectionColor: AppColors.primaryOrange.withValues(
                alpha: 0.3,
              ), // 2. لون الخلفية عند تظليل/تحديد النص
              selectionHandleColor: AppColors
                  .primaryOrange, // 3. لون "القطرة" التي تسحب منها النص
            ),
          ),

          home: child,
          initialRoute: AppRoutes.login,

          // 2. تحديث خريطة المسارات لتستخدم الثوابت
          routes: {
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.signUp: (context) => const SignUpScreen(),
            AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
            AppRoutes.verification: (context) => const VerificationScreen(),
            AppRoutes.home: (context) => const HomeScreen(),
            AppRoutes.createTask: (context) => const CreateTaskScreen(),
            AppRoutes.taskDetails: (context) => const TaskDetailsScreen(),
            AppRoutes.calendar: (context) => const CalendarScreen(),
            AppRoutes.mainLayout: (context) => const MainLayoutScreen(),
          },
        );
      },
      child: const LoginScreen(),
    );
  }
}
