import 'package:flutter/material.dart';

/// كلاس يضيف انتقالات سينمائية وحركات إبداعية عند الانتقال بين الشاشات
class AppTransitions {
  // 👈 1. انتقال التلاشي (Fade In) - راقي وهادئ
  static Route fadeIn(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  // 👈 2. انتقال التكبير (Scale) - ممتاز عند فتح تفاصيل مهمة
  static Route scale(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOutBack));
        return ScaleTransition(
          scale: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}