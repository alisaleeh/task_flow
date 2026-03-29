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

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  /// آخر نسخة متزامنة من TaskCubit (تبقى مرئية أثناء TaskLoading وغيره).
  TaskEntity? _syncedTask;
  String? _trackedTaskId;

  TaskEntity? _findInList(List<TaskEntity> tasks, String id) {
    for (final t in tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  void _applySuccessState(TaskSuccess success, String taskId) {
    final match = _findInList(success.task, taskId);
    if (match != null) {
      setState(() => _syncedTask = match);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeTask = ModalRoute.of(context)!.settings.arguments as TaskEntity;
    if (_trackedTaskId != routeTask.id) {
      _trackedTaskId = routeTask.id;
      _syncedTask = null;
    }
    final cubitState = context.read<TaskCubit>().state;
    if (cubitState is TaskSuccess) {
      final match = _findInList(cubitState.task, routeTask.id);
      if (match != null) {
        _syncedTask = match;
      }
    }
  }

  TaskEntity _resolveCurrentTask(TaskEntity routeTask, TaskState cubitState) {
    if (cubitState is TaskSuccess) {
      return _findInList(cubitState.task, routeTask.id) ?? routeTask;
    }
    return _syncedTask ?? routeTask;
  }

  @override
  Widget build(BuildContext context) {
    final routeTask = ModalRoute.of(context)!.settings.arguments as TaskEntity;

    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: CustomAppBar(title: 'Task Details'),
      body: BlocListener<CreateTaskCubit, CreateTaskState>(
        listener: (context, state) {
          if (state is CreateSubTaskSuccess) {
            CustomSnackBar.showSuccess(
              context,
              'Subtask added successfully! ✅',
            );
            context.read<TaskCubit>().fetchalltasks();
          } else if (state is CreateSubTaskError) {
            CustomSnackBar.showError(context, state.message);
          }
        },
        child: BlocConsumer<TaskCubit, TaskState>(
          listenWhen: (previous, current) => current is TaskSuccess,
          listener: (context, state) {
            _applySuccessState(state as TaskSuccess, routeTask.id);
          },
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            final currentTask = _resolveCurrentTask(routeTask, state);

            return SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s24.h)),
                  SliverToBoxAdapter(
                    child: _DetailsSectionCard(
                      child: TaskDetailsHeader(
                        status: currentTask.status,
                        title: currentTask.title,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s16.h)),
                  SliverToBoxAdapter(
                    child: _DetailsSectionCard(
                      child: TaskDetailsDescription(
                        description: currentTask.subtitle,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s16.h)),
                  SliverToBoxAdapter(
                    child: _DetailsSectionCard(
                      child: TaskDetailsInfoGrid(priority: currentTask.priority),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s20.h)),
                  TaskDetailsSubtasks(
                    subtasks: currentTask.subtasks,
                    taskId: currentTask.id,
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 36.h)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: const TaskDetailsActions(),
                    ),
                  ),
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

class _DetailsSectionCard extends StatelessWidget {
  const _DetailsSectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.borderColor.withOpacity(0.4),
          ),
        ),
        child: child,
      ),
    );
  }
}
