import 'package:flutter/services.dart';

/// كلاس يضيف "إحساساً جسدياً" (Vibration) للتطبيق لجعله يبدو فخماً (Premium)
class AppHaptics {
  // 👈 1. هزة خفيفة جداً (لضغطات الأزرار العادية، الـ Checkbox، أو التنقل)
  static Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  // 👈 2. هزة متوسطة (عند فتح Dialog أو ظهور BottomSheet)
  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  // 👈 3. هزة قوية (عند حدوث خطأ، أو مسح عنصر مهم مثل حذف مهمة)
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
  }

  // 👈 4. الإحساس بالنجاح (هزتين متتاليتين بنغمة النصر) - اللمسة السحرية ✨
  static Future<void> success() async {
    await HapticFeedback.lightImpact();
    // تأخير بسيط جداً لصنع نغمة الاهتزاز (دقة قلب صغيرة ثم كبيرة)
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
  }
}