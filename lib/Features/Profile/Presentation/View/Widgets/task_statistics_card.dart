import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';

class TaskStatisticsCard extends StatelessWidget {
  const TaskStatisticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.borderColor.withOpacity(0.4), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TASK STATISTICS',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColors.textLight, letterSpacing: 1.2),
            ),
            AppSpacing.gapV16,
            Row(
              children: [
                Expanded(child: _buildStatItem('24', 'Tasks Completed')),
                AppSpacing.gapH16,
                Expanded(child: _buildStatItem('12', 'Pending Tasks')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
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
            style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: AppColors.primaryOrange),
          ),
          AppSpacing.gapV8,
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}