import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';

class TaskFilterRow extends StatelessWidget {
  final TaskStatus? selectedStatus;
  final ValueChanged<TaskStatus?> onSelected;

  const TaskFilterRow({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      _FilterItem('All', null),
      _FilterItem('To Do', TaskStatus.open),
      _FilterItem('Done', TaskStatus.done),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = selectedStatus == item.status;

          return Padding(
            padding: EdgeInsets.only(right: index == items.length - 1 ? 0 : 12.w),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: () => onSelected(item.status),
                child: Container(
                  constraints: BoxConstraints(minHeight: 40.h),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryOrange
                    : context.appThemeColors.borderColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                      : context.appThemeColors.borderColor.withOpacity(0.35),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : context.appThemeColors.textDark,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _FilterItem {
  final String label;
  final TaskStatus? status;

  const _FilterItem(this.label, this.status);
}