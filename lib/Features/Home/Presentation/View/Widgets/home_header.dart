import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';
import 'package:taskflow/Features/Home/Domain/Entities/task_summary_entity.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.summaryEntity});
  final TaskSummaryEntity summaryEntity;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Tasks', style: AppTextStyles.font28ExtraBoldDark(context)),
            AppSpacing.gapV4,
            Text(
              'You have ${summaryEntity.totalTasksToday} tasks today',
              style: AppTextStyles.font15RegularLight(context),
            ),
          ],
        ),
        SizedBox(
          width: 56.w,
          height: 56.w,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: summaryEntity.completionPercentage / 100,
                strokeWidth: 5.w,
                backgroundColor: context.appThemeColors.borderColor,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${summaryEntity.completionPercentage.round()}%',
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColors.primaryOrange),
                    ),
                    Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: context.appThemeColors.textLight,
                      ),
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