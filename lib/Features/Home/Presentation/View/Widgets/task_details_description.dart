import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

// تأكد من مسار الـ SectionTitle لديك
import 'package:taskflow/Features/Home/Presentation/View/Widgets/section_title.dart';

class TaskDetailsDescription extends StatelessWidget {
  const TaskDetailsDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'DESCRIPTION'),
          AppSpacing.gapV12,
          Text(
            'Create a high-fidelity mockup for the hero section of the landing page. Focus on the main value proposition and a strong CTA to drive user engagement.',
            style: AppTextStyles.font14RegularLight.copyWith(
              height: 1.6, 
              fontSize: 15.sp, 
              color: AppColors.textDark.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}