import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Utils/app_page_transitions.dart';
import 'package:taskflow/Core/Utils/context_extensions.dart';
import 'package:taskflow/Core/Utils/service_locator.dart';
import 'package:taskflow/Core/Widgets/custom_snack_bar.dart';
import 'package:taskflow/Features/Calendar/Presentation/View/calendar_screen.dart';

// استيراد شاشاتك الثلاث
import 'package:taskflow/Features/Home/Presentation/View/home_screen.dart';
import 'package:taskflow/Features/Profile/Presentation/View/profile_screen.dart';

// استيراد الـ NavBar
import 'package:taskflow/Features/Home/Presentation/View/Widgets/glass_bottom_nav_bar.dart';
import 'package:taskflow/Features/Task/Presentation/Manager/cubit/create_task_cubit.dart';
import 'package:taskflow/Features/Task/Presentation/View/create_task_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  // 👈 الحالة المؤقتة التي تحتفظ برقم التاب الحالي
  int _currentIndex = 0;
  DateTime? _lastBackPressAt;

  // 👈 قائمة الشاشات المرتبطة بالتابات
  final List<Widget> _screens = [
    const HomeScreen(),
    const CalendarScreen(),
    const ProfileScreen(),
  ];

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    }

    final now = DateTime.now();
    final canExit = _lastBackPressAt != null &&
        now.difference(_lastBackPressAt!) <= const Duration(seconds: 2);

    if (canExit) {
      return true;
    }

    _lastBackPressAt = now;
    CustomSnackBar.showError(context, 'اضغط مرتين للخروج من التطبيق');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(index: _currentIndex, children: _screens),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton:
            _currentIndex !=
                2 // يمكنك إخفاء الزر في شاشة البروفايل إذا أردت
            ? FloatingActionButton(
                onPressed: () async {
                  // 1. نفتح الشاشة وننتظر النتيجة
                  final result = await context.pushRoute(
                    AppTransitions.scale(
                      BlocProvider(
                        create: (context) => getIt<CreateTaskCubit>(),
                        child: const CreateTaskScreen(),
                      ),
                    ),
                  );

                  // 2. فحص النتيجة بعد إغلاق شاشة الإضافة (لعمل Refresh للمهام)
                  if (result == true) {
                    // نفترض أنك تمرر true عند نجاح الإضافة
                    // 💡 سحر! الهاتف يهتز بنعومة تحديثاً للبيانات
                    context.taskCubit.fetchalltasks();
                  }
                },
                backgroundColor: AppColors.primaryOrange,
                shape: const CircleBorder(),
                elevation: 4,
                child: Icon(Icons.add, color: Colors.white, size: 32.sp),
              )
            : null,

        // 👈 استدعاء شريط التنقل الزجاجي الخاص بك
        bottomNavigationBar: GlassBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
