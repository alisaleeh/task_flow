import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

class DescriptionInputField extends StatelessWidget {
  final TextEditingController controller;
  const DescriptionInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
      controller: controller,
      maxLines: 5,
      style: AppTextStyles.font14RegularLight(context)
          .copyWith(color: context.appThemeColors.textDark),
      decoration: InputDecoration(
        hintText: 'Add more details about this task...',
        hintStyle: AppTextStyles.font14RegularLight(context),
        filled: true,
        fillColor: context.appThemeColors.surfaceColor,
        contentPadding: EdgeInsets.all(16.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: context.appThemeColors.borderColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.5),
        ),
      ),
    );
  }
}