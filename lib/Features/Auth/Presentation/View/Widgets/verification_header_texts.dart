import 'package:flutter/material.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

class VerificationHeaderTexts extends StatelessWidget {
  const VerificationHeaderTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verify Your Email',
          style: AppTextStyles.font28ExtraBoldDark,
        ),
        AppSpacing.gapV12,
        Text(
          'Please enter the 4-digit code sent to\nyour email.',
          style: AppTextStyles.font15RegularLight.copyWith(
            height: 1.5,
          ),
        ),
      ],
    );
  }
}