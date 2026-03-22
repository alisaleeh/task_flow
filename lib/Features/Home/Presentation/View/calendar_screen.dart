import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/calendar_header.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/calendar_tasks_list.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/custom_calendar_card.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/tasks_today_header.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // لون خلفية التصميم أبيض صلب
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: AppSpacing.gapV24),

            // 1. هيدر الشاشة (كلمة Calendar مع زر البحث)
            const SliverToBoxAdapter(child: CalendarHeader()),
            SliverToBoxAdapter(child: AppSpacing.gapV24),

            // 2. بطاقة التقويم
            const SliverToBoxAdapter(child: CustomCalendarCard()),
            SliverToBoxAdapter(child: AppSpacing.gapV32),

            // 3. هيدر قسم المهام
            const SliverToBoxAdapter(child: TasksTodayHeader()),
            SliverToBoxAdapter(child: AppSpacing.gapV16),

            // 4. قائمة المهام المخصصة لهذه الشاشة (SliverList)
            const CalendarTasksList(),

            // مسافة سفلية لحماية المهام من الاختفاء خلف الـ BottomNavBar
            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        ),
      ),
      // إعداد الـ FAB بالمنتصف
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: AppColors.primaryOrange,
      //   elevation: 4,
      //   shape: const CircleBorder(),
      //   child: Icon(Icons.add, color: Colors.white, size: 32.sp),
      // ),
      // TODO: استخدام BottomAppBar مع shape: CircularNotchedRectangle() لاحقاً
    );
  }
}
