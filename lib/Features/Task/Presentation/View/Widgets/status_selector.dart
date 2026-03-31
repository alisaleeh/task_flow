import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';

class StatusSelector extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;

  const StatusSelector({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    // 👈 الخريطة هنا تربط بين "ما يراه المستخدم" و "ما يرسل للسيرفر"
    final statusMap = {
      'To Do': 'TO_DO',
      'In Progress': 'IN_PROGRESS',
      'Done': 'DONE',
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: statusMap.keys.map((label) {
        final serverValue = statusMap[label]!;
        final isSelected = serverValue == selectedStatus;
        
        return Expanded(
          child: Padding(
            // 👈 المسافات بين العناصر
            padding: EdgeInsets.only(right: label != 'Done' ? 10.w : 0),
            child: InkWell(
              onTap: () => onStatusChanged(serverValue),
              borderRadius: BorderRadius.circular(24.r),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryOrange
                      : context.appThemeColors.surfaceColor,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.primaryOrange 
                        : context.appThemeColors.borderColor.withOpacity(0.5),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  label, // نعرض الاسم اللطيف للمستخدم
                  style: TextStyle(
                    fontSize: 13.sp, // أصغر قليلاً لأن النصوص أطول من Priority
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : context.appThemeColors.textDark,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}