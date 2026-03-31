import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';
import 'package:taskflow/Features/Task/Domain/Entities/subtask_entity.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'package:taskflow/Features/Task/Presentation/Manager/cubit/create_task_cubit.dart';
import 'package:taskflow/Features/Task/Presentation/View/Widgets/section_title.dart';

class TaskDetailsSubtasks extends StatelessWidget {
  final List<SubtaskEntity> subtasks;
  final String taskId;

  const TaskDetailsSubtasks({
    super.key,
    required this.subtasks,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 36.w),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionTitle(title: 'SUBTASKS'),
                  GestureDetector(
                    onTap: () => _showAddSubtaskSheet(context),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        color: AppColors.primaryOrange,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (subtasks.isEmpty)
            SliverToBoxAdapter(
              child: Text(
                'No subtasks added yet.',
                style: TextStyle(color: Colors.grey, fontSize: 13.sp),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildSubtaskItem(subtasks[index]),
                childCount: subtasks.length,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubtaskItem(SubtaskEntity subtask) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: const BoxDecoration(
              color: AppColors.primaryOrange,
              shape: BoxShape.circle,
            ),
          ),
          AppSpacing.gapH12,
          Expanded(
            child: Text(subtask.title, style: TextStyle(fontSize: 15.sp)),
          ),
        ],
      ),
    );
  }

  void _showAddSubtaskSheet(BuildContext parentContext) {
    showModalBottomSheet<void>(
      context: parentContext,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: _AddSubtaskBottomSheet(
          taskId: taskId,
          cubitContext: parentContext,
        ),
      ),
    );
  }
}

class _AddSubtaskBottomSheet extends StatefulWidget {
  const _AddSubtaskBottomSheet({
    required this.taskId,
    required this.cubitContext,
  });

  final String taskId;
  final BuildContext cubitContext;

  @override
  State<_AddSubtaskBottomSheet> createState() => _AddSubtaskBottomSheetState();
}

class _AddSubtaskBottomSheetState extends State<_AddSubtaskBottomSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    final newSubtask = SubtaskEntity(
      id: '',
      title: title,
      isDone: false,
      taskId: widget.taskId,
      priority: TaskPriority.medium,
      status: TaskStatus.open,
      subtitle: '',
    );

    widget.cubitContext.read<CreateTaskCubit>().createSubtask(newSubtask);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appThemeColors.surfaceColor,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.appThemeColors.borderColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'New subtask',
              style: AppTextStyles.font18SemiBoldDark(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Add a short title for this step.',
              style: AppTextStyles.font15RegularLight(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Text('Title', style: AppTextStyles.font14SemiBoldDark(context)),
            SizedBox(height: 8.h),
            TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              style: AppTextStyles.font16RegularDark(context),
              decoration: InputDecoration(
                hintText: 'e.g. Review design mockups',
                hintStyle: AppTextStyles.font15RegularLight(context),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                filled: true,
                fillColor: context.appThemeColors.surfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(color: context.appThemeColors.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(color: context.appThemeColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: const BorderSide(
                    color: AppColors.primaryOrange,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      foregroundColor: context.appThemeColors.textLight,
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.font16RegularDark(context).copyWith(
                        color: context.appThemeColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
