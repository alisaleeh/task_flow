import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';

class GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // قوة التغبيش
        child: Container(
          color: context.appThemeColors.backgroundColor.withValues(alpha: 0.7),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent, // شفاف لتمرير تأثير الزجاج
            elevation: 0,
            selectedItemColor: AppColors.primaryOrange,
            unselectedItemColor: context.appThemeColors.textLight,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex, // 👈 1. ربط التاب النشط
            onTap: onTap, // 👈 2. إرسال أمر النقر للشاشة الأم
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}