import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  // 1. قيم المسافات الأساسية
  static double get s4 => 4;
  static double get s8 => 8;
  static double get s12 => 12;
  static double get s16 => 16;
  static double get s20 => 20;
  static double get s24 => 24;
  static double get s32 => 32;
  static double get s40 => 40;
  static double get s48 => 48;
  static double get s64 => 64;

  // 2. مسافات عمودية جاهزة (Vertical Gaps)
  static SizedBox get gapV4 => SizedBox(height: 4.h);
  static SizedBox get gapV8 => SizedBox(height: 8.h);
  static SizedBox get gapV12 => SizedBox(height: 12.h);
  static SizedBox get gapV16 => SizedBox(height: 16.h);
  static SizedBox get gapV20 => SizedBox(height: 20.h);
  static SizedBox get gapV24 => SizedBox(height: 24.h);
  static SizedBox get gapV32 => SizedBox(height: 32.h);
  static SizedBox get gapV40 => SizedBox(height: 40.h);
  static SizedBox get gapV48 => SizedBox(height: 48.h);
  static SizedBox get gapV64 => SizedBox(height: 64.h);

  // 3. مسافات أفقية جاهزة (Horizontal Gaps)
  static SizedBox get gapH4 => SizedBox(width: 4.w);
  static SizedBox get gapH8 => SizedBox(width: 8.w);
  static SizedBox get gapH12 => SizedBox(width: 12.w);
  static SizedBox get gapH16 => SizedBox(width: 16.w);
  static SizedBox get gapH20 => SizedBox(width: 20.w);
  static SizedBox get gapH24 => SizedBox(width: 24.w);
  static SizedBox get gapH32 => SizedBox(width: 32.w);

  // 4. هوامش شائعة الاستخدام (Common Edge Insets)
  static EdgeInsets get screenPadding =>
      EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h);
  static EdgeInsets get paddingAll16 => EdgeInsets.all(16.r);
  static EdgeInsets get paddingAll8 => EdgeInsets.all(8.r);
}
