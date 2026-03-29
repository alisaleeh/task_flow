import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_routes.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Utils/app_haptics.dart';
import 'package:taskflow/Core/Utils/context_extensions.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'task_card.dart';
import 'delete_task_dialog.dart';

class TasksSliverList extends StatelessWidget {
  final List<TaskEntity> tasks;

  const TasksSliverList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 100.h),
      sliver: SliverList.separated(
        itemCount: tasks.length,
        separatorBuilder: (context, index) => AppSpacing.gapV16,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskCard(
            task: task,
            onOpenDetails: () {
              Navigator.pushNamed(context, AppRoutes.taskDetails, arguments: task);
            },
            onDelete: () {
              DeleteTaskDialog.show(
                context,
                onConfirm: () => context.taskCubit.deleteTask(task.id),
              );
            },
            onToggleCompletion: () {
              AppHaptics.light();
              final currentStatus = task.status.toString().split('.').last.toUpperCase();
              context.taskCubit.updateTask(
                taskId: task.id,
                status: currentStatus == 'DONE' ? 'OPEN' : 'DONE',
              );
            },
          );
        },
      ),
    );
  }
}