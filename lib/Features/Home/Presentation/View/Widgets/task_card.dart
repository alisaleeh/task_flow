import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';

// ==========================================
// 1. أداة الحوار المُعدلة (ترجع Future<bool>)
// ==========================================
class DeleteTaskDialog {
  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.error),
              AppSpacing.gapH8,
              Text(
                'confirm deletion',
                style: AppTextStyles.font12RegularLight(dialogContext),
              ),
            ],
          ),
          content: const Text(
            'are you sure you want to delete this task? this action cannot be undone.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false), // إرجاع false عند الإلغاء
              child: const Text('cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true), // إرجاع true عند التأكيد
              child: const Text('delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    ) ?? false; // في حال قام المستخدم بإغلاق النافذة من الخارج
  }
}

// ==========================================
// 2. كرت المهمة مع الـ Dismissible المُعدل
// ==========================================
class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onDelete;
  final VoidCallback onOpenDetails;
  final VoidCallback onToggleCompletion;

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
      key: Key(task.id.toString()),
      background: _buildDismissBackground(
        context: context,
        color: AppColors.primaryOrange,
        icon: Icons.open_in_new_rounded,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _buildDismissBackground(
        context: context,
        color: AppColors.error,
        icon: Icons.delete_outline_rounded,
        alignment: Alignment.centerRight,
      ),
      // التعديل السحري لحل مشكلة الـ Context والأنيميشن
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // تأخير بسيط لمنع تعارض الأنيميشن مع انتقال الشاشة (يمنع الـ Exception)
          Future.delayed(const Duration(milliseconds: 200), () {
            onOpenDetails();
          });
          return false; // نرفض الحذف ونعيد الكرت لمكانه
        } else if (direction == DismissDirection.endToStart) {
          // انتظار إجابة المستخدم من نافذة الحوار المخصصة
          bool isConfirmed = await DeleteTaskDialog.show(context);
          
          // حارس الأمان: التأكد أن الصفحة لم تُغلق أثناء الانتظار
          if (!context.mounted) return false;
          
          return isConfirmed; // سيختفي الكرت فقط إذا كانت النتيجة true
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete(); // استدعاء الحذف لتحديث الـ Bloc وإزالة المهمة من الـ UI
        }
      },
      child: _buildCardContent(context),
    );
  }

  Widget _buildDismissBackground({
    required BuildContext context,
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
            style: AppTextStyles.font16BoldDark(context).copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    final bgColor = task.status == TaskStatus.done
        ? AppColors.primaryOrange.withOpacity(0.05)
        : context.appThemeColors.backgroundColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOpenDetails,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: context.appThemeColors.borderColor,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCheckbox(context),
              AppSpacing.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: AppTextStyles.font16BoldDark(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AppSpacing.gapH8,
                        _buildStatusBadge(context),
                      ],
                    ),
                    if (task.subtitle != null && task.subtitle!.isNotEmpty) ...[
                      AppSpacing.gapV4,
                      Text(
                        task.subtitle!,
                        style: AppTextStyles.font14RegularLight(context),
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
                          // ignore: unnecessary_null_comparison
                          task.dueDate != null
                              ? '${task.dueDate.hour}:${task.dueDate.minute.toString().padLeft(2, '0')} ${task.dueDate.hour >= 12 ? 'PM' : 'AM'}'
                              // ignore: dead_code
                              : 'No due time',
                          style: AppTextStyles.font12RegularLight(context),
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

  Widget _buildCheckbox(BuildContext context) {
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
                : context.appThemeColors.borderColor,
            width: 2,
          ),
        ),
        child: task.isCompleted
            ? Icon(Icons.check, color: Colors.white, size: 16.sp)
            : null,
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final isInProgress = task.status == TaskStatus.inProgress;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isInProgress
            ? AppColors.primaryOrange.withOpacity(0.15)
            : context.appThemeColors.borderColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        task.status.name,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: isInProgress ? AppColors.primaryOrange : context.appThemeColors.textDark,
        ),
      ),
    );
  }
}