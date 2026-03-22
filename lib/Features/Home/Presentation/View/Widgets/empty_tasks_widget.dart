import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

class EmptyTasksWidget extends StatelessWidget {
  const EmptyTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_outlined, size: 80.sp, color: AppColors.borderColor),
          AppSpacing.gapV16,
          Text('No Tasks Yet!', style: AppTextStyles.font18SemiBoldDark),
          AppSpacing.gapV8,
          Text(
            'Tap the + button to add your first task\nand start achieving your goals.',
            textAlign: TextAlign.center,
            style: AppTextStyles.font14RegularLight.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}