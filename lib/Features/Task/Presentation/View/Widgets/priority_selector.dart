import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';

class PrioritySelector extends StatelessWidget {
  final String selectedPriority;
  final ValueChanged<String> onPriorityChanged;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final priorities = ['Low', 'Medium', 'High'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: priorities.map((priority) {
        final isSelected = priority == selectedPriority;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: priority != 'High' ? 12.w : 0),
            child: InkWell(
              onTap: () => onPriorityChanged(priority),
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
                  priority,
                  style: TextStyle(
                    fontSize: 14.sp,
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