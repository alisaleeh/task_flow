
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

class CustomOtpField extends StatelessWidget {
  const CustomOtpField({super.key});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context, // مطلوب أساسي في هذه الحزمة
      length: 4, // عدد المربعات
      obscureText: false,
      keyboardType: TextInputType.number,
      textStyle: AppTextStyles.font24BoldDark(context),
      cursorColor: AppColors.primaryOrange,
      animationType: AnimationType.scale,
      
      // هنا السحر: تخصيص شكل المربعات لتطابق تصميمك 100%
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12.r),
        fieldHeight: 64.w,
        fieldWidth: 64.w,
        
        // لون الإطار للمربع الذي تقف عليه الآن (Focused)
        selectedColor: AppColors.primaryOrange,
        // لون الإطار للمربعات الفارغة (Idle)
        inactiveColor: context.appThemeColors.borderColor,
        // لون الإطار للمربعات التي تم تعبئتها (Filled)
        activeColor: context.appThemeColors.borderColor,
        
        // ألوان الخلفية (جعلناها شفافة لتطابق تصميمك)
        activeFillColor: Colors.transparent,
        inactiveFillColor: Colors.transparent,
        selectedFillColor: Colors.transparent,
      ),
      
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true, // ضروري لتفعيل ألوان الخلفية الشفافة التي وضعناها
      
      onCompleted: (v) {
        // سيتم استدعاء هذه الدالة تلقائياً بمجرد كتابة الرقم الرابع
        debugPrint("Completed: $v");
      },
      onChanged: (value) {
        // تتبع التغيير مع كل حرف
      },
    );
  }
}