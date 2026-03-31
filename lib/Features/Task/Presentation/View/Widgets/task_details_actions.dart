import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';

class TaskDetailsActions extends StatelessWidget {
  const TaskDetailsActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          _buildMarkAsDoneButton(context),
          AppSpacing.gapV16,
          _buildDeleteButton(context),
        ],
      ),
    );
  }

  Widget _buildMarkAsDoneButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Trigger Cubit to mark task as done
        },
        icon: Icon(Icons.check_circle_outline, color: Colors.white, size: 24.sp),
        label: Text(
          'Mark as Done',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          elevation: 4,
          shadowColor: AppColors.primaryOrange.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          // TODO: Trigger Cubit to delete task
        },
        icon: Icon(
          Icons.delete_outline,
          color: context.appThemeColors.textLight,
          size: 20.sp,
        ),
        label: Text(
          'Delete Task',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: context.appThemeColors.textLight,
          ),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
        ),
      ),
    );
  }
}