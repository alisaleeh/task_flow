import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'info_card.dart';

class TaskDetailsInfoGrid extends StatelessWidget {
  const TaskDetailsInfoGrid({super.key, required this.priority});
  final TaskPriority priority;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: InfoCard(icon: Icons.calendar_today_outlined, title: 'DUE DATE', value: 'Oct 24,\n2023'),
              ),
              AppSpacing.gapH16,
              const Expanded(
                child: InfoCard(icon: Icons.access_time_rounded, title: 'TIME', value: '10:00 AM'),
              ),
            ],
          ),
          AppSpacing.gapV16,
          Row(
            children: [
              Expanded(
                child: InfoCard(
                  icon: Icons.flag_outlined,
                  title: 'PRIORITY',
                  value: priority.toString().split('.').last.toUpperCase(),
                  bgColor: AppColors.primaryOrange.withOpacity(0.05),
                  borderColor: AppColors.primaryOrange.withOpacity(0.2),
                  iconColor: AppColors.primaryOrange,
                  valueColor: AppColors.primaryOrange,
                ),
              ),
              AppSpacing.gapH16,
              const Expanded(
                child: InfoCard(icon: Icons.folder_outlined, title: 'CATEGORY', value: 'Design'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}