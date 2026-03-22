import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';

class TaskDetailsHeader extends StatelessWidget {
  const TaskDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Design Homepage Hero Section',
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
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.coffee_outlined, color: AppColors.primaryOrange, size: 16.sp),
          AppSpacing.gapH8,
          Text(
            'In Progress',
            style: TextStyle(
              fontSize: 12.sp, 
              fontWeight: FontWeight.bold, 
              color: AppColors.primaryOrange,
            ),
          ),
        ],
      ),
    );
  }
}