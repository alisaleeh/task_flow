import 'package:flutter/material.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';

class DeleteTaskDialog {
  // 1. تغيير void إلى Future<bool> وإزالة onConfirm
  static Future<bool> show(BuildContext context) async {
    // 2. إضافة return await وتحديد نوع showDialog بـ <bool>
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
              // 3. إرجاع false عند الإلغاء
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              // 4. إرجاع true عند تأكيد الحذف
              onPressed: () {
                Navigator.of(dialogContext).pop(true); 
              },
              child: const Text('delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    ) ?? false; // 5. إرجاع false في حال قام المستخدم بإغلاق النافذة بالضغط خارجها
  }
}