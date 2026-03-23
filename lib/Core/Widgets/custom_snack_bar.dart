import 'package:flutter/material.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';

class CustomSnackBar {
  // 🔴 دالة لإظهار رسائل الخطأ
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar() // 👈 إخفاء أي رسالة سابقة فوراً قبل عرض الجديدة
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating, // يجعلها تطفو فوق الشاشة
          backgroundColor: Colors.transparent, // جعلنا الخلفية شفافة لنبني تصميمنا الخاص
          content: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error, // لون الخطأ الخاص بتطبيقك
              borderRadius: BorderRadius.circular(12), // حواف دائرية أنيقة
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white), // أيقونة معبرة
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  // 🟢 دالة لإظهار رسائل النجاح
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success, // أو أي لون أخضر مخصص للنجاح في AppColors
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: AppColors.success.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white), // أيقونة نجاح
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}