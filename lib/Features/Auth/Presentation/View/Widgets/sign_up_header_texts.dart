import 'package:flutter/material.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';


class SignUpHeaderTexts extends StatelessWidget {
  const SignUpHeaderTexts({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدمنا CrossAxisAlignment.start لجعل النص على اليسار
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Account',
          style: AppTextStyles.font28ExtraBoldDark,
        ),
        AppSpacing.gapV8,
        Text(
          'Join us to manage your tasks effectively.',
          style: AppTextStyles.font15RegularLight,
        ),
      ],
    );
  }
}