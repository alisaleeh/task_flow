import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  // منع أخذ نسخة من الكلاس
  AppTextStyles._();

  // 1. العناوين (Headings)
  static TextStyle get font28ExtraBoldDark => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
  );

  static TextStyle get font24BoldDark => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static TextStyle get font18SemiBoldDark => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  // 2. النصوص الأساسية (Body Texts)
  static TextStyle get font16RegularDark => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );

  static TextStyle get font15RegularLight => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  static TextStyle get font14SemiBoldDark => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static TextStyle get font14RegularLight => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  // 3. نصوص الأزرار والروابط (Buttons & Links)
  static TextStyle get font16BoldWhite => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle get font14SemiBoldOrange => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryOrange,
  );

  static TextStyle get font14BoldOrange => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryOrange,
  );
  static TextStyle font16BoldDark = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold, // خط عريض
    color: AppColors.textDark, // لون داكن للنصوص الرئيسية
  );

  static TextStyle font12RegularLight = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal, // خط عادي (Regular)
    color: AppColors.textLight, // لون فاتح للنصوص الثانوية (مثل الوقت)
  );

  static TextStyle? get font14BoldWhite => null;
}
