import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Widgets/custom_app_bar.dart';
import 'package:taskflow/Core/Widgets/custom_snack_bar.dart';
import 'package:taskflow/Features/Home/Presentation/Manager/Task_cubit/task_cubit.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'package:taskflow/Features/Task/Presentation/Manager/cubit/create_task_cubit.dart';
import 'package:taskflow/Features/Task/Presentation/View/Widgets/task_details_actions.dart';
import 'package:taskflow/Features/Task/Presentation/View/Widgets/task_details_description.dart';
import 'package:taskflow/Features/Task/Presentation/View/Widgets/task_details_header.dart';
import 'package:taskflow/Features/Task/Presentation/View/Widgets/task_details_info_grid.dart';
import 'package:taskflow/Features/Task/Presentation/View/Widgets/task_details_subtasks.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. استلام البيانات الأولية من الـ Navigator
    final initialTask =
        ModalRoute.of(context)!.settings.arguments as TaskEntity;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Task Details'),
      // 🚀 2. استخدام BlocListener للتعامل مع رسائل النجاح والخطأ
      body: BlocListener<CreateTaskCubit, CreateTaskState>(
        listener: (context, state) {
          if (state is CreateSubTaskSuccess) {
            CustomSnackBar.showSuccess(
              context,
              'Subtask added successfully! ✅',
            );

            // 🚀 الخطوة الذهبية: نطلب من الـ TaskCubit إعادة جلب البيانات
            // لكي يشعر الـ BlocBuilder بالتغيير ويحدث القائمة فوراً
            context.read<TaskCubit>().fetchalltasks();
          } else if (state is CreateSubTaskError) {
            CustomSnackBar.showError(context, state.message);
          }
        },
        // 🚀 3. استخدام BlocBuilder لتحديث الواجهة عند تغير حالة المهام
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            // نحدد أي مهمة سنعرض بياناتها
            // إذا كنا في حالة نجاح، نبحث عن المهمة المحدثة في القائمة
            TaskEntity currentTask = initialTask;

            if (state is TaskSuccess) {
              currentTask = state.task.firstWhere(
                (t) => t.id == initialTask.id,
                orElse: () => initialTask,
              );
            }

            return SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s24.h)),

                  // 1. العنوان وحالة المهمة
                  SliverToBoxAdapter(
                    child: TaskDetailsHeader(
                      status: currentTask.status,
                      title: currentTask.title,
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s32.h)),

                  // 2. الوصف
                  SliverToBoxAdapter(
                    child: TaskDetailsDescription(
                      description: currentTask.subtitle,
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s32.h)),

                  // 3. شبكة المعلومات
                  SliverToBoxAdapter(
                    child: TaskDetailsInfoGrid(priority: currentTask.priority),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s32.h)),

                  // 4. قسم المهام الفرعية (سيحدث تلقائياً)
                  TaskDetailsSubtasks(
                    subtasks: currentTask.subtasks,
                    taskId: currentTask.id,
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s40.h)),

                  // 5. الأزرار السفلية
                  const SliverToBoxAdapter(child: TaskDetailsActions()),
                  SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s24.h)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
