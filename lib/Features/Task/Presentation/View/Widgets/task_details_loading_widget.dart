import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';

class TaskDetailsLoadingWidget extends StatelessWidget {
  const TaskDetailsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(), // نمنع السحب أثناء التحميل
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. هيكل العنوان (Title)
            Container(width: 250.w, height: 32.h, color: Colors.white),
            AppSpacing.gapV8,
            Container(width: 180.w, height: 32.h, color: Colors.white),
            AppSpacing.gapV16,
            
            // 2. هيكل التاج (Status Badge)
            Container(
              width: 100.w,
              height: 28.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            AppSpacing.gapV32,

            // 3. هيكل عنوان القسم (Section Title)
            Container(width: 100.w, height: 14.h, color: Colors.white),
            AppSpacing.gapV12,

            // 4. هيكل الوصف (Description)
            Container(width: double.infinity, height: 14.h, color: Colors.white),
            AppSpacing.gapV8,
            Container(width: double.infinity, height: 14.h, color: Colors.white),
            AppSpacing.gapV8,
            Container(width: 200.w, height: 14.h, color: Colors.white),
            AppSpacing.gapV32,

            // 5. هيكل شبكة المعلومات (Info Grid)
            Row(
              children: [
                Expanded(child: _buildInfoCardSkeleton()),
                AppSpacing.gapH16,
                Expanded(child: _buildInfoCardSkeleton()),
              ],
            ),
            AppSpacing.gapV16,
            Row(
              children: [
                Expanded(child: _buildInfoCardSkeleton()),
                AppSpacing.gapH16,
                Expanded(child: _buildInfoCardSkeleton()),
              ],
            ),
            AppSpacing.gapV32,

            // 6. هيكل المهام الفرعية (Subtasks)
            Container(width: 80.w, height: 14.h, color: Colors.white),
            AppSpacing.gapV16,
            _buildSubtaskSkeleton(),
            AppSpacing.gapV16,
            _buildSubtaskSkeleton(),
            AppSpacing.gapV16,
            _buildSubtaskSkeleton(),
          ],
        ),
      ),
    );
  }

  // --- دوال مساعدة لبناء الهياكل المتكررة ---

  Widget _buildInfoCardSkeleton() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }

  Widget _buildSubtaskSkeleton() {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        AppSpacing.gapH12,
        Expanded(
          child: Container(height: 14.h, color: Colors.white),
        ),
      ],
    );
  }
}