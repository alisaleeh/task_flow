import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_routes.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';
import 'package:taskflow/Core/Utils/app_page_transitions.dart';
import 'package:taskflow/Core/Utils/context_extensions.dart';
import 'package:taskflow/Core/Utils/service_locator.dart';
import 'package:taskflow/Core/Widgets/custom_snack_bar.dart';
import 'package:taskflow/Features/Auth/Presentation/Manager/login_cubit/login_cubit.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/app_logo.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/bottom_action_text.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/custom_text_field.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/header_texts.dart';
import 'package:taskflow/Features/Auth/Presentation/View/Widgets/primary_button.dart';
import 'package:taskflow/Features/Home/Presentation/Manager/Task_cubit/task_cubit.dart';
import 'package:taskflow/Features/Home/Presentation/View/main_layout_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); // تم إضافة const

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appThemeColors.backgroundColor,
      body: SafeArea(
        top: false,
        bottom: true,
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            switch (state) {
              case LoginInitial():
              case LoginLoading():
                break;
              case LoginFailure():
                CustomSnackBar.showError(context, state.errorMessage);
                break;
              case LoginSuccess():
                CustomSnackBar.showSuccess(context, 'Login successful!');
                context.pushAndRemoveUntilRoute(
                  AppTransitions.fadeIn(
                    BlocProvider(
                      // 👈 اسحب الكيوبت من الـ GetIt (Dependency Injection)
                      create: (context) => getIt<TaskCubit>(),
                      child: const MainLayoutScreen(),
                    ),
                  ),
                );
                break;
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
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

                          CustomTextField(
                            label: 'Email',
                            hintText: 'your@email.com',
                            keyboardType: TextInputType.emailAddress,
                            textinputaction: TextInputAction.next,
                            controller: emailcontroller,
                          ),
                          AppSpacing.gapV20,

                          CustomTextField(
                            label: 'Password',
                            hintText: '........',
                            isPassword: true,
                            textinputaction: TextInputAction.done,
                            controller: passwordcontroller,
                          ),
                          AppSpacing.gapV12,

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

                          if (state is LoginLoading)
                            const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryOrange,
                              ),
                            )
                          else
                            PrimaryButton(
                              text: 'Sign In',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  context.logincubit.login(
                                    emailcontroller.text.trim(),
                                    passwordcontroller.text.trim(),
                                  );
                                }
                              },
                            ),

                          AppSpacing.gapV24,
                          const BottomActionText(),
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
