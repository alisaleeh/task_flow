import 'package:flutter/material.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

class BottomActionText extends StatelessWidget {
  const BottomActionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTextStyles.font14RegularLight(context),
        ),
        GestureDetector(
          onTap: () {
           Navigator.pushNamed(context, '/signup');
          },
          child: Text(
            'Sign Up',
            style: AppTextStyles.font14BoldOrange(context),
          ),
        ),
      ],
    );
  }
}