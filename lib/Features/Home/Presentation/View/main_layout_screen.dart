import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_routes.dart';
import 'package:taskflow/Core/Utils/context_extensions.dart';
import 'package:taskflow/Features/Calendar/Presentation/View/calendar_screen.dart';
import 'package:taskflow/Features/Home/Presentation/Manager/Task_cubit/task_cubit.dart';

// استيراد شاشاتك الثلاث
import 'package:taskflow/Features/Home/Presentation/View/home_screen.dart';
import 'package:taskflow/Features/Profile/Presentation/View/profile_screen.dart';

// استيراد الـ NavBar
import 'package:taskflow/Features/Home/Presentation/View/Widgets/glass_bottom_nav_bar.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  // 👈 الحالة المؤقتة التي تحتفظ برقم التاب الحالي
  int _currentIndex = 0;

  // 👈 قائمة الشاشات المرتبطة بالتابات
  final List<Widget> _screens = [
    const HomeScreen(),
    const CalendarScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // ضروري جداً لكي يعمل تأثير الزجاج
      // 👈 السحر الهندسي هنا: IndexedStack تحتفظ بحالة الشاشات (State Preservation)
      // يعني لو عملت Scroll في الـ Home ورحلت للـ Profile ورجعت، ستجد الـ Scroll مكانه!
      body: IndexedStack(index: _currentIndex, children: _screens),

      // 👈 الزر العائم (FAB) تم نقله هنا ليكون ثابتاً فوق كل الشاشات
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:
          _currentIndex !=
              2 // يمكنك إخفاء الزر في شاشة البروفايل إذا أردت
          ? FloatingActionButton(
              onPressed: () async {
                // 1. نفتح الشاشة وننتظر النتيجة
                final result = await Navigator.pushNamed(
                  context,
                  AppRoutes.createTask,
                );
                // 2. إذا عادت الشاشة بـ true (يعني تم إنشاء مهمة بنجاح)
                if (result == true) {
                  // 3. نطلب من الـ Cubit تحديث القائمة!
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
    );
  }
}
