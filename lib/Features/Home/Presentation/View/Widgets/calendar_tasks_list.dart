import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';

class CalendarTasksList extends StatelessWidget {
  const CalendarTasksList({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات وهمية مطابقة للتصميم
    final tasks = [
      {'title': 'Team Daily Standup', 'subtitle': 'Discuss project roadmap and blockers for the week.', 'time': '09:00 AM', 'category': 'WORK', 'isDone': false},
      {'title': 'Buy birthday gift for Sarah', 'subtitle': 'Completed early morning', 'time': '11:30 AM', 'category': 'PERSONAL', 'isDone': true},
      {'title': 'Review UI Design System', 'subtitle': 'Check the orange accents contrast on the calendar view.', 'time': '02:00 PM', 'category': 'WORK', 'isDone': false},
      {'title': 'Evening Yoga Session', 'subtitle': '', 'time': '06:00 PM', 'category': 'HEALTH', 'isDone': false},
    ];

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final task = tasks[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildCalendarTaskCard(task),
            );
          },
          childCount: tasks.length,
        ),
      ),
    );
  }

  // الويدجت الخاصة برسم الكارت مطابقة لتصميم التقويم
  Widget _buildCalendarTaskCard(Map<String, dynamic> task) {
    final isDone = task['isDone'] as bool;
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.5), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Checkbox
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: isDone ? AppColors.primaryOrange : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryOrange, width: 2),
            ),
            child: isDone ? Icon(Icons.check, color: Colors.white, size: 16.sp) : null,
          ),
          AppSpacing.gapH16,
          // Task Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Badge & Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        task['category'] as String,
                        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: AppColors.primaryOrange),
                      ),
                    ),
                    Text(
                      task['time'] as String,
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textLight),
                    ),
                  ],
                ),
                AppSpacing.gapV8,
                // Title
                Text(
                  task['title'] as String,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDone ? AppColors.textLight : AppColors.textDark,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                // Subtitle
                if ((task['subtitle'] as String).isNotEmpty) ...[
                  AppSpacing.gapV4,
                  Text(
                    task['subtitle'] as String,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textLight.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}