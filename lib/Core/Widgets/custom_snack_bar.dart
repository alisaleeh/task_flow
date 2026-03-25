import 'package:flutter/material.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';

class CustomSnackBar {
  // متغير للاحتفاظ بالإشعار الحالي لكي نتمكن من إخفائه إذا ظهر واحد جديد بسرعة
  static OverlayEntry? _overlayEntry;

  // 🔴 دالة لإظهار رسائل الخطأ
  static void showError(BuildContext context, String message) {
    _showToast(
      context: context,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline,
    );
  }

  // 🟢 دالة لإظهار رسائل النجاح
  static void showSuccess(BuildContext context, String message) {
    _showToast(
      context: context,
      message: message,
      backgroundColor: AppColors.success, // تأكد من وجود هذا اللون
      icon: Icons.check_circle_rounded,
    );
  }

  // 🛠️ الدالة المركزية لبناء وعرض الإشعار باستخدام الـ Overlay
  static void _showToast({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    // 1. إذا كان هناك إشعار معروض حالياً، قم بإخفائه فوراً
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    // 2. إنشاء الإشعار الجديد
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          // 👈 سيظهر تحت شريط البطارية/الساعة (Status Bar) بمسافة 16 بيكسل
          top: MediaQuery.paddingOf(context).top + 16,
          left: 24,
          right: 24,
          child: Material(
            color: Colors.transparent, // ضروري لكي لا تظهر خلفية بيضاء
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: backgroundColor,
                // 👈 تصميم "الكبسولة" (Pill Shape) العصري
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: backgroundColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: 'Cairo', // أضف خطك المفضل هنا إن وجد
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // 3. إدراج الإشعار لكي يظهر على الشاشة
    Overlay.of(context).insert(_overlayEntry!);

    // 4. إغلاق تلقائي بعد 3 ثوانٍ
    Future.delayed(const Duration(seconds: 3), () {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      }
    });
  }
}