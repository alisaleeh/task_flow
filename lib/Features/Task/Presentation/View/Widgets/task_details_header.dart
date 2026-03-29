import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';

class TaskDetailsHeader extends StatelessWidget {
  const TaskDetailsHeader({super.key, required this.title, required this.status});
  final String title;
  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w900,
            height: 1.2,
            color: AppColors.textDark,
          ),
        ),
        AppSpacing.gapV16,
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final (String label, IconData icon, Color fg, Color bg) = switch (status) {
      TaskStatus.done => (
          'Completed',
          Icons.check_circle_outline_rounded,
          AppColors.success,
          AppColors.success.withOpacity(0.1),
        ),
      TaskStatus.inProgress => (
          'In progress',
          Icons.timelapse_rounded,
          AppColors.primaryOrange,
          AppColors.primaryOrange.withOpacity(0.1),
        ),
      TaskStatus.open => (
          'Open',
          Icons.radio_button_unchecked_rounded,
          AppColors.textLight,
          AppColors.borderColor.withOpacity(0.35),
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: fg.withOpacity(0.18), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: fg, size: 17.sp),
          AppSpacing.gapH8,
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}