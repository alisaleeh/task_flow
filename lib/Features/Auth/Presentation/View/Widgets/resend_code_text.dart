import 'package:flutter/material.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

class ResendCodeText extends StatelessWidget {
  const ResendCodeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code? ",
          style: AppTextStyles.font14RegularLight(context),
        ),
        GestureDetector(
          onTap: () {
            // TODO: Implement Resend Code Logic
          },
          child: Text(
            'Resend',
            style: AppTextStyles.font14BoldOrange(context),
          ),
        ),
      ],
    );
  }
}