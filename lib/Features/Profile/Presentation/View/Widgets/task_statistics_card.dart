import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Features/Home/Domain/Entities/task_summary_entity.dart';

/// يعرض الملخص الممرَّر من [ProfileScreen] (من TaskCubit + كاش).
class TaskStatisticsCard extends StatelessWidget {
  const TaskStatisticsCard({super.key, required this.summary});

  final TaskSummaryEntity? summary;

  @override
  Widget build(BuildContext context) {
    final completed = summary?.completedTasks;
    final total = summary?.totalTasksToday;
    final completedStr = completed != null ? '$completed' : '—';
    final totalStr = total != null ? '$total' : '—';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: context.appThemeColors.surfaceColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: context.appThemeColors.borderColor.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TASK STATISTICS',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: context.appThemeColors.textLight,
                letterSpacing: 1.2,
              ),
            ),
            AppSpacing.gapV16,
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(context, completedStr, 'Tasks Completed'),
                ),
                AppSpacing.gapH16,
                Expanded(
                  child: _buildStatItem(context, totalStr, 'Total Tasks'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String number, String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryOrange,
            ),
          ),
          AppSpacing.gapV8,
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: context.appThemeColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
