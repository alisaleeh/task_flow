import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textLight.withValues(alpha:0.8),
        letterSpacing: 1.2, // تباعد الأحرف لتعطي شكل التصميم
      ),
    );
  }
}