import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';

class ForgotPasswordIcon extends StatelessWidget {
  const ForgotPasswordIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100.w, // حجم الدائرة
        height: 100.w,
        decoration: const BoxDecoration(
          color: AppColors.primaryOrangeLight, // البرتقالي الفاتح جداً من ملف الألوان
          shape: BoxShape.circle, // جعل الحاوية دائرية
        ),
        child: Center(
          child: Icon(
            Icons.lock_rounded, // أيقونة القفل
            color: AppColors.primaryOrange,
            size: 48.sp, // حجم الأيقونة
          ),
        ),
      ),
    );
  }
}