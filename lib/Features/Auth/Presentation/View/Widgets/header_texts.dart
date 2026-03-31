import 'package:flutter/material.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

class HeaderTexts extends StatelessWidget {
  const HeaderTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'TaskFlow',
          style: AppTextStyles.font28ExtraBoldDark(context),
        ),
        AppSpacing.gapV8,
        Text(
          'Manage your daily tasks efficiently',
          style: AppTextStyles.font15RegularLight(context),
        ),
      ],
    );
  }
}
