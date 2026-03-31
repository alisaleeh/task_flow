import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

class TasksErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry; // تمرير دالة إعادة المحاولة من الشاشة الرئيسية

  const TasksErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64.sp, color: Colors.redAccent),
            AppSpacing.gapV16,
            Text(
              'Oops! Something went wrong',
              style: AppTextStyles.font16BoldDark(context),
            ),
            AppSpacing.gapV8,
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14RegularLight(context),
            ),
            AppSpacing.gapV24,
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('Try Again', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}