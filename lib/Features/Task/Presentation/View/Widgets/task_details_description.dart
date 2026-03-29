import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';
import 'package:taskflow/Features/Task/Presentation/View/Widgets/section_title.dart';

class TaskDetailsDescription extends StatelessWidget {
  const TaskDetailsDescription({super.key, required this.description});
final String? description ;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'DESCRIPTION'),
        AppSpacing.gapV12,
        Text(
          description ?? 'No description available.',
          style: AppTextStyles.font14RegularLight.copyWith(
            height: 1.6,
            fontSize: 15.sp,
            color: AppColors.textDark.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}