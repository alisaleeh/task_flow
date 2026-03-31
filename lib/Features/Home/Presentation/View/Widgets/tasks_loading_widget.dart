import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';

class TasksLoadingWidget extends StatelessWidget {
  const TasksLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      physics: const NeverScrollableScrollPhysics(), // منع التمرير أثناء التحميل
      itemCount: 6, // عرض عدد كافٍ لملء الشاشة
      separatorBuilder: (context, index) => AppSpacing.gapV16,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white, // خلفية الكارت تبقى ثابتة داخل الـ Shimmer
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: context.appThemeColors.borderColor,
              width: 1,
            ),
          ),
          // الـ Shimmer يغلف فقط العناصر الداخلية للكارت
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade500,
            highlightColor: Colors.grey.shade300,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. هيكل الشيك بوكس
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: Colors.grey, // لون موحد للسكيليتون
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                AppSpacing.gapH12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. هيكل العنوان
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 140.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          // هيكل التاج (Status Badge)
                          Container(
                            width: 60.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.gapV12,
                      // 3. هيكل الوصف (Subtitle)
                      Container(
                        width: double.infinity,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      AppSpacing.gapV12,
                      // 4. هيكل الوقت
                      Row(
                        children: [
                          Container(
                            width: 14.w,
                            height: 14.w,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          AppSpacing.gapH4,
                          Container(
                            width: 80.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}