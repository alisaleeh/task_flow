import 'package:flutter/material.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

class RememberedPasswordText extends StatelessWidget {
  const RememberedPasswordText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Remembered your password? ",
          style: AppTextStyles.font14RegularLight(context),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text('Log in', style: AppTextStyles.font14BoldOrange(context)),
        ),
      ],
    );
  }
}
