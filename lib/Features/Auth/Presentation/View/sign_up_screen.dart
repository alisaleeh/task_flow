import 'package:flutter/material.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_routes.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/already_have_account_text.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/custom_text_field.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/primary_button.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/sign_up_header_texts.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                    // 1. النصوص العلوية (تم تصميمها لتكون على اليسار)
                    const SignUpHeaderTexts(),
                    AppSpacing.gapV40, // مسافة أكبر قبل الفورم
                    // 2. حقول الإدخال (إعادة استخدام سريعة جداً!)
                    const CustomTextField(
                      label: 'Full Name',
                      hintText: 'Full Name',
                      keyboardType: TextInputType.name,
                      textinputaction: TextInputAction.next,
                    ),
                    AppSpacing.gapV16,
                    const CustomTextField(
                      label: 'Email Address',
                      hintText: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                      textinputaction: TextInputAction.next,
                    ),
                    AppSpacing.gapV16,
                    const CustomTextField(
                      label: 'Password',
                      hintText: 'Password',
                      isPassword: true,
                      textinputaction: TextInputAction.next,
                    ),
                    AppSpacing.gapV16,
                    const CustomTextField(
                      label: 'Confirm Password',
                      hintText: 'Confirm Password',
                      isPassword: true,
                      textinputaction: TextInputAction.done,
                    ),
                    AppSpacing.gapV32,
                    // 3. زر التسجيل (بدون أيقونة)
                    PrimaryButton(
                      text: 'Sign Up',
                      hasIcon: true, // 👈 هنا أخفينا السهم ليطابق تصميمك
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.verification);
                      },
                    ),
                    AppSpacing.gapV24,
                    const AlreadyHaveAccountText(),
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
