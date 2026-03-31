import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? bgColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? valueColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.bgColor,
    this.borderColor,
    this.iconColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bgColor ?? context.appThemeColors.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: borderColor ?? context.appThemeColors.borderColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? context.appThemeColors.textLight,
                size: 20.sp,
              ),
              AppSpacing.gapH8,
              Text(
                title,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: context.appThemeColors.textLight,
                ),
              ),
            ],
          ),
          AppSpacing.gapV8,
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: valueColor ?? context.appThemeColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}