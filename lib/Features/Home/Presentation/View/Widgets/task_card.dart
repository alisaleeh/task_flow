import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';
import 'package:taskflow/Features/Home/Domain/Entities/task_entity.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onDelete;
  final VoidCallback onOpenDetails;
  final VoidCallback onToggleCompletion; // 👈 1. أضفنا دالة لتغيير حالة المهمة

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onOpenDetails,
    required this.onToggleCompletion,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: _buildDismissBackground(
        // 👈 2. يفضل لاحقاً إضافة هذا اللون لـ AppColors (مثلاً AppColors.infoBlue)
        color: AppColors.primaryOrange,
        icon: Icons.open_in_new_rounded,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _buildDismissBackground(
        // 👈 يفضل لاحقاً إضافة هذا اللون لـ AppColors (مثلاً AppColors.errorRed)
        color: const Color(0xFFD32F2F),
        icon: Icons.delete_outline_rounded,
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onOpenDetails();
          return false;
        } else if (direction == DismissDirection.endToStart) {
          onDelete();
          return true;
        }
        return false;
      },
      child: _buildCardContent(),
    );
  }

  Widget _buildDismissBackground({
    required Color color,
    required IconData icon,
    required Alignment alignment,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
      ),
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: icon == Icons.delete_outline_rounded
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28.sp),
          AppSpacing.gapH8,
          Text(
            icon == Icons.delete_outline_rounded ? 'Delete' : 'Details',
            style: AppTextStyles.font16BoldDark,
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent() {
    final bgColor = task.isCompleted
        ? AppColors.primaryOrange.withOpacity(0.05)
        : Colors.white;

    // 👈 3. غلفنا المحتوى بـ Material و InkWell لإضافة تأثير الضغط الاحترافي
    return Material(
      color: Colors.transparent, // ضروري لكي يظهر لون الحاوية التي بالأسفل
      child: InkWell(
        onTap: onOpenDetails, // الضغط على الكارت يفتح التفاصيل
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.borderColor, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCheckbox(),
              AppSpacing.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 👈 4. حماية العنوان من الانهيار إذا كان طويلاً جداً
                        Expanded(
                          child: Text(
                            task.title,
                            style: AppTextStyles.font16BoldDark,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AppSpacing
                            .gapH8, // مسافة صغيرة لحماية التاج من الالتصاق بالنص
                        _buildStatusBadge(),
                      ],
                    ),
                    if (task.subtitle != null && task.subtitle!.isNotEmpty) ...[
                      AppSpacing.gapV4,
                      Text(
                        task.subtitle!,
                        style: AppTextStyles.font14RegularLight,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    AppSpacing.gapV12,
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: AppColors.primaryOrange,
                          size: 14.sp,
                        ),
                        AppSpacing.gapH4,
                        Text(
                          task.time,
                          style: AppTextStyles.font12RegularLight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    // 👈 5. جعلنا الشيك بوكس قابلاً للضغط لتغيير حالة المهمة سريعاً
    return GestureDetector(
      onTap: onToggleCompletion,
      child: Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          color: task.isCompleted
              ? AppColors.primaryOrange
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: task.isCompleted
                ? AppColors.primaryOrange
                : AppColors.borderColor,
            width: 2,
          ),
        ),
        child: task.isCompleted
            ? Icon(Icons.check, color: Colors.white, size: 16.sp)
            : null,
      ),
    );
  }

  // ... (دالة _buildStatusBadge تبقى كما هي بدون تغيير)
  Widget _buildStatusBadge() {
    final isInProgress = task.status == 'In Progress';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isInProgress
            ? AppColors.primaryOrange.withOpacity(0.15)
            : AppColors.borderColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(

       task.status.name,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: isInProgress ? AppColors.primaryOrange : AppColors.textDark,
        ),
      ),
    );
  }
}
