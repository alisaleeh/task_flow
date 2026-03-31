import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_routes.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/custom_text_field.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/forgot_password_icon.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/primary_button.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/remembered_password_text.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appThemeColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.appThemeColors.textDark,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Forgot Password',
          style: AppTextStyles.font18SemiBoldDark(context),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        // نستخدم CustomScrollView بدلاً من SingleChildScrollView لكي نتمكن من استخدام الـ Slivers والتحكم بمرونة الشاشة مع الكيبورد
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // SliverPadding هو البديل لـ Padding العادي، حيث لا يمكننا استخدام ويدجت عادية مباشرة داخل قائمة الـ slivers
            SliverPadding(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: 20.h,
                bottom: 40.h,
              ),
              // هذه الويدجت السحرية تجعل المحتوى يتمدد ليملأ باقي الشاشة، مما يسمح لنا لاحقاً باستخدام Spacer لدفع العناصر للأسفل
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSpacing.gapV32,
                    const ForgotPasswordIcon(),
                    AppSpacing.gapV32,
                    Text(
                      'Enter your registered email address below to receive password reset instructions.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font15RegularLight(context).copyWith(
                        height: 1.5,
                      ),
                    ),
                    AppSpacing.gapV40,
                    const CustomTextField(
                      label: 'Email Address',
                      hintText: 'example@email.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    AppSpacing.gapV32,
                    PrimaryButton(
                      text: 'Send Reset Link',
                      hasIcon: false,
                      onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.verification);
                      },
                    ),

                    AppSpacing.gapV24,
                    const RememberedPasswordText(),
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
