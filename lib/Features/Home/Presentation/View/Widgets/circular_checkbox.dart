import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';

class CircularCheckbox extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onTap;

  const CircularCheckbox({super.key, required this.isChecked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isChecked ? AppColors.primaryOrange : Colors.transparent,
          border: Border.all(
            color: isChecked ? AppColors.primaryOrange : AppColors.primaryOrange,
            width: 2,
          ),
        ),
        child: isChecked ? Icon(Icons.check, color: Colors.white, size: 16.sp) : null,
      ),
    );
  }
}