import 'package:flutter/material.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_routes.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/app_logo.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/bottom_action_text.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/custom_text_field.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/header_texts.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        top: false,
        bottom: true,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: AppSpacing.screenPadding,
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSpacing.gapV20,
                    const AppLogo(),
                    AppSpacing.gapV24,
                    const HeaderTexts(),
                    AppSpacing.gapV48,

                    const CustomTextField(
                      label: 'Email',
                      hintText: 'your@email.com',
                      keyboardType: TextInputType.emailAddress,
                      textinputaction: TextInputAction.next,
                    ),
                    AppSpacing.gapV20,

                    const CustomTextField(
                      label: 'Password',
                      hintText: '........',
                      isPassword: true,
                      textinputaction: TextInputAction.done,
                    ),
                    AppSpacing.gapV12,

                    // زر نسيت كلمة المرور
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.forgotPassword,
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: AppTextStyles.font14SemiBoldOrange,
                        ),
                      ),
                    ),
                    AppSpacing.gapV32,

                    PrimaryButton(text: 'Sign In', onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.mainLayout);
                    }),

                    AppSpacing.gapV24,

                    const BottomActionText(),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
