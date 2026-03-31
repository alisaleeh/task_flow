import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

class ScheduleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const ScheduleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: context.appThemeColors.surfaceColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: context.appThemeColors.borderColor.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryOrange, size: 24.sp),
            AppSpacing.gapH12,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color:
                        context.appThemeColors.textLight.withValues(alpha: 0.8),
                  ),
                ),
                AppSpacing.gapV4,
                Text(
                  value,
                  style: AppTextStyles.font14RegularLight(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: value.contains('Select')
                        ? context.appThemeColors.textDark
                        : AppColors.primaryOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}