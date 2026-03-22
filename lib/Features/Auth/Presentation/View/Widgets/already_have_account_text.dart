import 'package:flutter/material.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

class AlreadyHaveAccountText extends StatelessWidget {
  const AlreadyHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: AppTextStyles.font14RegularLight,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            'Log In',
            style: AppTextStyles.font14BoldOrange,
          ),
        ),
      ],
    );
  }
}