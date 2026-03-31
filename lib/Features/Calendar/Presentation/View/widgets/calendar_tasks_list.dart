import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_routes.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';

class CalendarTasksList extends StatelessWidget {
  final List<TaskEntity> tasks;

  const CalendarTasksList({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: context.appThemeColors.textLight,
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final task = tasks[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildCalendarTaskCard(context, task),
            );
          },
          childCount: tasks.length,
        ),
      ),
    );
  }

  // الويدجت الخاصة برسم الكارت مطابقة لتصميم التقويم
  String _formatTime(DateTime d) {
    final hour = d.hour;
    final minute = d.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:$minute $period';
  }

  Widget _buildCalendarTaskCard(BuildContext context, TaskEntity task) {
    final isDone = task.isCompleted;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.taskDetails,
            arguments: task,
          );
        },
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: context.appThemeColors.surfaceColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: context.appThemeColors.borderColor.withOpacity(0.5),
              width: 1,
            ),
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
                child: isDone
                    ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                    : null,
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
                            task.priority.name.toUpperCase(),
                            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: AppColors.primaryOrange),
                          ),
                        ),
                        Text(
                          _formatTime(task.dueDate),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: context.appThemeColors.textLight,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapV8,
                    // Title
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                            color: isDone
                                ? context.appThemeColors.textLight
                                : context.appThemeColors.textDark,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    // Subtitle
                    if (task.subtitle != null && task.subtitle!.isNotEmpty) ...[
                      AppSpacing.gapV4,
                      Text(
                        task.subtitle!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color:
                              context.appThemeColors.textLight.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}