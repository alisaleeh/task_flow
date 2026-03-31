import 'package:flutter/material.dart';

export 'package:taskflow/Core/Theme/app_theme_colors.dart';

class AppColors {
  // نمنع إنشاء نسخة من هذا الكلاس لأنه يحتوي على ثوابت فقط
  AppColors._();

  // --- ألوان الهوية البصرية (Brand Colors) ---
  static const Color primaryOrange = Color(0xFFEA5B19);
  
  // لون برتقالي فاتح جداً (ممتاز لشارات الحالة "In Progress" أو خلفيات الأيقونات)
  static const Color primaryOrangeLight = Color(0xFFFCEEE6); 

  // --- ألوان الحالة (Status Colors) - ستحتاجها لاحقاً ---
  static const Color error = Color(0xFFEF4444);   // لرسائل الخطأ في تسجيل الدخول أو حذف مهمة
  static const Color success = Color(0xFF10B981); // لحالة إنجاز المهمة (Done)
}