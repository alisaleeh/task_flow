import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
// ملاحظة: قد تحتاج لاستيراد AppColors إذا كنت تريد تخصيص ألوان الشيمر لتناسب الـ Dark/Light Mode

class HomeHeaderLoading extends StatelessWidget {
  const HomeHeaderLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      // 👈 ألوان الشيمر (رمادي فاتح يلمع)
      baseColor: Colors.grey.shade500,
      highlightColor: Colors.grey.shade300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. قسم النصوص (على اليسار)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // بديل عنوان "My Tasks"
              Container(
                width: 140.w, // عرض افتراضي مقارب للكلمة
                height: 30.h,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              AppSpacing.gapV8,
              // بديل النص الفرعي "You have X tasks today"
              Container(
                width: 200.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
          
          // 2. قسم الدائرة (على اليمين)
          Container(
            width: 56.w,
            height: 56.w,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle, // شكل دائري ليتطابق مع الـ CircularProgressIndicator
            ),
          ),
        ],
      ),
    );
  }
}