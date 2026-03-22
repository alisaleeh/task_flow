import 'package:flutter/material.dart';

class AppColors {
  // نمنع إنشاء نسخة من هذا الكلاس لأنه يحتوي على ثوابت فقط
  AppColors._();

  // --- ألوان الهوية البصرية (Brand Colors) ---
  static const Color primaryOrange = Color(0xFFEA5B19);
  
  // لون برتقالي فاتح جداً (ممتاز لشارات الحالة "In Progress" أو خلفيات الأيقونات)
  static const Color primaryOrangeLight = Color(0xFFFCEEE6); 

  // --- ألوان الخلفيات (Background Colors) ---
  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Color(0xFFF8F9FA); // رمادي فاتح جداً للبطاقات (Cards)

  // --- ألوان النصوص (Text Colors) ---
  static const Color textDark = Color(0xFF1E2432);  // للعناوين والنصوص الأساسية
  static const Color textLight = Color(0xFF717D96); // للنصوص الفرعية (Subtitles) والـ Hints

  // --- ألوان الحدود والخطوط الفاصلة (Borders & Dividers) ---
  static const Color borderColor = Color(0xFFE2E8F0);

  // --- ألوان الحالة (Status Colors) - ستحتاجها لاحقاً ---
  static const Color error = Color(0xFFEF4444);   // لرسائل الخطأ في تسجيل الدخول أو حذف مهمة
  static const Color success = Color(0xFF10B981); // لحالة إنجاز المهمة (Done)
}