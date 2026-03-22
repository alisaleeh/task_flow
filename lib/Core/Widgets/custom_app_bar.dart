import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const CustomAppBar({super.key, required this.title, this.onBackPressed, this.actions});

  @override
  Widget build(BuildContext context) {
    // 👈 نستخدم ClipRect لمنع الـ Blur من الانتشار خارج حدود الـ AppBar
    return ClipRect(
      child: BackdropFilter(
        // 👈 قوة التغبيش (كلما زاد الرقم زاد تأثير الزجاج)
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: AppBar(
          actions: actions,
          // 👈 جعل اللون أبيض بذكاء مع شفافية بسيطة (Opacity)
          backgroundColor: Colors.white.withValues(alpha: 0.7),
          elevation: 0,
          centerTitle: true,
          // 👈 إزالة الحدود الحادة واستبدالها بخط خفيف جداً
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: AppColors.borderColor.withValues(alpha: 0.2),
              height: 0.5, // خط أنحف لزيادة الأناقة
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.textDark,
              size: 24.sp,
            ),
            onPressed: onBackPressed ?? () => Navigator.pop(context),
          ),
          title: Text(
            title,
            style: AppTextStyles.font18SemiBoldDark.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
