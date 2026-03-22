import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Tasks', style: AppTextStyles.font28ExtraBoldDark),
            AppSpacing.gapV4,
            Text('You have 5 tasks today', style: AppTextStyles.font15RegularLight),
          ],
        ),
        SizedBox(
          width: 56.w,
          height: 56.w,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 0.45,
                strokeWidth: 5.w,
                backgroundColor: AppColors.borderColor,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '45%',
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColors.primaryOrange),
                    ),
                    Text(
                      'Done',
                      style: TextStyle(fontSize: 10.sp, color: AppColors.textLight),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}