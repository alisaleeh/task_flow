import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'package:taskflow/Features/Task/Presentation/View/Widgets/section_title.dart';

/// يعرض أولوية المهمة فقط (بدون تاريخ / وقت / فئة).
class TaskDetailsInfoGrid extends StatelessWidget {
  const TaskDetailsInfoGrid({super.key, required this.priority});

  final TaskPriority priority;

  String _priorityLabel() {
    switch (priority) {
      case TaskPriority.high:
        return 'HIGH';
      case TaskPriority.medium:
        return 'MEDIUM';
      case TaskPriority.low:
        return 'LOW';
    }
  }

  Color _accent(BuildContext context) {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.primaryOrange;
      case TaskPriority.medium:
        return AppColors.primaryOrange;
      case TaskPriority.low:
        return context.appThemeColors.textLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accent(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'PRIORITY'),
        AppSpacing.gapV12,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: context.appThemeColors.surfaceColor,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: accent.withOpacity(0.22),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(11.w),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.flag_outlined,
                  color: accent,
                  size: 22.sp,
                ),
              ),
              AppSpacing.gapH16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Task priority level',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: context.appThemeColors.textLight,
                      ),
                    ),
                    AppSpacing.gapV4,
                    Text(
                      _priorityLabel(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: context.appThemeColors.textDark,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
