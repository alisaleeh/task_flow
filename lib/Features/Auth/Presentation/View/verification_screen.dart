import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/custom_otp_field.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/primary_button.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/resend_code_text.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/verification_header_texts.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textDark, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: 10.h,
                bottom: 40.h,
              ),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSpacing.gapV20,
                    const VerificationHeaderTexts(),
                    AppSpacing.gapV40,

                    const CustomOtpField(),

                    AppSpacing.gapV40,
                    PrimaryButton(
                      text: 'Verify',
                      hasIcon: false,
                      onPressed: () {},
                    ),
                    AppSpacing.gapV24,
                    const ResendCodeText(),
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
