import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';

class TasksTodayHeader extends StatelessWidget {
  const TasksTodayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tasks for today',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add_circle_outline, color: AppColors.primaryOrange, size: 16.sp),
            label: Text(
              'New Task',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.primaryOrange),
            ),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
          ),
        ],
      ),
    );
  }
}