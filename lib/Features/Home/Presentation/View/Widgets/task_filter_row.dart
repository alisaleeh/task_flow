import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';

class TaskFilterRow extends StatelessWidget {
  const TaskFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'To Do', 'In Progress', 'Done'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter == 'All';
          return Container(
            margin: EdgeInsets.only(right: 12.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryOrange : AppColors.borderColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              filter,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}