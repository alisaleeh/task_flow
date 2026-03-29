import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_routes.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Utils/context_extensions.dart';
import 'package:taskflow/Core/Widgets/custom_snack_bar.dart';
import 'package:taskflow/Features/Auth/Presentation/Manager/register_cubit/register_cubit.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/already_have_account_text.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/custom_text_field.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/primary_button.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/sign_up_header_texts.dart';

// 1. تحويل الشاشة إلى StatefulWidget
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // 2. تعريف المتغيرات خارج دالة الـ build
  final TextEditingController firstnamecontroller = TextEditingController();
  final TextEditingController lastnamecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  // 3. رفع الـ FormKey ليكون هنا لكي لا يتم إعادة إنشائه
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 4. السحر الهندسي لمنع تسريب الذاكرة (Memory Leak)
  @override
  void dispose() {
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        top: false,
        bottom: true,
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            switch (state) {
              case RegisterInitial():
              case RegisterLoading():
                break;
              case RegisterFailure():
                CustomSnackBar.showError(context, state.errorMessage);
                break;
              case RegisterSuccess():
                CustomSnackBar.showSuccess(context, 'Registration successful!');
                Navigator.pushReplacementNamed(context, AppRoutes.login);
                break;
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey, // 👈 الآن المفتاح آمن ولن يتغير
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
                          const SignUpHeaderTexts(),
                          AppSpacing.gapV40,

                          CustomTextField(
                            label: 'First Name',
                            hintText: 'First Name',
                            keyboardType: TextInputType.name,
                            textinputaction: TextInputAction.next,
                            controller: firstnamecontroller,
                          ),
                          AppSpacing.gapV16,
                          CustomTextField(
                            label: 'Last Name',
                            hintText: 'Last Name',
                            keyboardType: TextInputType.name,
                            textinputaction: TextInputAction.next,
                            controller: lastnamecontroller,
                          ),
                          AppSpacing.gapV16,

                          CustomTextField(
                            label: 'Email Address',
                            hintText: 'Email Address',
                            keyboardType: TextInputType.emailAddress,
                            textinputaction: TextInputAction.next,
                            controller: emailcontroller,
                          ),
                          AppSpacing.gapV16,
                          CustomTextField(
                            label: 'Password',
                            hintText: 'Password',
                            isPassword: true,
                            textinputaction: TextInputAction.done,
                            controller: passwordcontroller,
                          ),
                          AppSpacing.gapV16,

                          state is RegisterLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors
                                        .primaryOrange, // تأكد أن هذا اللون موجود عندك
                                  ),
                                )
                              : PrimaryButton(
                                  text: 'Sign Up',
                                  hasIcon: true,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      FocusScope.of(context).unfocus();
                                      context.registerCubit.register(
                                        firstnamecontroller.text.trim(),
                                        lastnamecontroller.text.trim(),
                                        emailcontroller.text.trim(),
                                        passwordcontroller.text.trim(),
                                      );
                                    }
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
            );
          },
        ),
      ),
    );
  }
}
