import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 👈 أضفنا bloc
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
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
    // 💡 ملاحظة Tech Lead: بما أننا نستخدم BlocProvider في الشاشة الأب، الـ context هنا يرى الـ Cubit
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                    // 👈 نمرر الـ context الحالي للـ Sheet
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
    final controller = TextEditingController();

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24.w,
          right: 24.w,
          top: 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add New Subtask',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            AppSpacing.gapV16,
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Enter subtask title...',
                border: OutlineInputBorder(),
              ),
            ),
            AppSpacing.gapV16,
            // 🚀 ربط الزر بالكيوبت
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final title = controller.text.trim();
                  if (title.isNotEmpty) {
                    final newSubtask = SubtaskEntity(
                      id: '', 
                      title: title,
                      isDone: false,
                      taskId: taskId, 
                      priority:
                          TaskPriority.medium, 
                      status: TaskStatus.open, 
                      subtitle: '', 
                    );

                    // 🚀 مناداة الكيوبت
                    parentContext.read<CreateTaskCubit>().createSubtask(
                      newSubtask,
                    );

                    // 🚀 إغلاق النافذة
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Subtask'),
              ),
            ),
            AppSpacing.gapV64,
          ],
        ),
      ),
    );
  }
}
