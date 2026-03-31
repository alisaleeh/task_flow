import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

class TitleInputField extends StatelessWidget {
  final TextEditingController controller;
  const TitleInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      style: AppTextStyles.font18SemiBoldDark(context).copyWith(fontSize: 20.sp),
      decoration: InputDecoration(
        hintText: 'e.g., Design homepage UI...',
        hintStyle: TextStyle(
          color: context.appThemeColors.textLight.withValues(alpha: 0.5),
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: context.appThemeColors.borderColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryOrange, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8.h),
      ),
    );
  }
}