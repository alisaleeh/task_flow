import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  // منع أخذ نسخة من الكلاس
  AppTextStyles._();

  // 1. العناوين (Headings)
  static TextStyle font28ExtraBoldDark(BuildContext context) => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w800,
        color: context.appThemeColors.textDark,
      );

  static TextStyle font24BoldDark(BuildContext context) => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: context.appThemeColors.textDark,
      );

  static TextStyle font18SemiBoldDark(BuildContext context) => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: context.appThemeColors.textDark,
      );

  // 2. النصوص الأساسية (Body Texts)
  static TextStyle font16RegularDark(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: context.appThemeColors.textDark,
      );

  static TextStyle font15RegularLight(BuildContext context) => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: context.appThemeColors.textLight,
      );

  static TextStyle font14SemiBoldDark(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: context.appThemeColors.textDark,
      );

  static TextStyle font14RegularLight(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: context.appThemeColors.textLight,
      );

  // 3. نصوص الأزرار والروابط (Buttons & Links)
  static TextStyle font16BoldWhite = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle font14SemiBoldOrange = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryOrange,
  );

  static TextStyle font14BoldOrange = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryOrange,
  );

  static TextStyle font16BoldDark(BuildContext context) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: context.appThemeColors.textDark,
      );

  static TextStyle font12RegularLight(BuildContext context) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        color: context.appThemeColors.textLight,
      );

  static TextStyle? get font14BoldWhite => null;
}
