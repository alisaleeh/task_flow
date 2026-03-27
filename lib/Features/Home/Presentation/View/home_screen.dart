import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Utils/context_extensions.dart';
import 'package:taskflow/Core/Widgets/custom_snack_bar.dart';
import 'package:taskflow/Features/Home/Presentation/Manager/Task_cubit/task_cubit.dart';
import 'Widgets/home_header.dart';
import 'Widgets/task_filter_row.dart';
import 'Widgets/tasks_error_widget.dart';
import 'Widgets/tasks_loading_widget.dart';
import 'Widgets/tasks_sliver_list.dart';
import 'Widgets/empty_tasks_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.taskCubit.fetchalltasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<TaskCubit, TaskState>(
          listener: _handleBlocListener,
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.primaryOrange,
              onRefresh: () async => context.taskCubit.fetchalltasks(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  _buildTopSection(),
                  _buildMainContent(state),
                  SliverToBoxAdapter(child: AppSpacing.gapV48),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // 1. المستمع للحالات (المنفصل للترتيب)
  void _handleBlocListener(BuildContext context, TaskState state) {
    if (state is DeleteTaskSuccess) {
      CustomSnackBar.showSuccess(context, 'Task deleted successfully!');
    } else if (state is DeleteTaskError) {
      CustomSnackBar.showError(context, state.errormessage);
    } else if (state is UpdateTaskError) {
      CustomSnackBar.showError(context, state.errormessage);
    }
  }

  // 2. القسم العلوي (الهيدر والفلاتر)
  Widget _buildTopSection() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          AppSpacing.gapV24,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: HomeHeader(),
          ),
          AppSpacing.gapV24,
          const TaskFilterRow(),
          AppSpacing.gapV24,
        ],
      ),
    );
  }

  // 3. المحتوى المتغير بناءً على حالة الكيوبت (Clean Logic!)
  Widget _buildMainContent(TaskState state) {
    if (state is TaskLoading) {
      return const SliverFillRemaining(child: Center(child: TasksLoadingWidget()));
    } else if (state is TaskFailure) {
      return SliverFillRemaining(
        child: TasksErrorWidget(
          errorMessage: state.errorMessage,
          onRetry: () => context.taskCubit.fetchalltasks(),
        ),
      );
    } else if (state is TaskSuccess) {
      if (state.task.isEmpty) {
        return const SliverFillRemaining(child: EmptyTasksWidget());
      }
      return TasksSliverList(tasks: state.task);
    }
    
    // Fallback حالة الصفر
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}