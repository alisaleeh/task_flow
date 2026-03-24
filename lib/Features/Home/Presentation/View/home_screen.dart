import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_routes.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Features/Home/Presentation/Manager/Task_cubit/task_cubit.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/tasks_error_widget.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/tasks_loading_widget.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/home_header.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/task_filter_row.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: false,
        // 👈 1. نقلنا الـ BlocBuilder ليغلف الـ ScrollView بالكامل
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. قسم الهيدر والفلاتر (سيظل ظاهراً دائماً)
                SliverToBoxAdapter(
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
                ),

                // 2. قسم قائمة المهام (نستخدم if مباشرة داخل مصفوفة الـ slivers!)
                if (state is TaskLoading)
                  // يجب تغليف الويدجت العادية بـ SliverToBoxAdapter أو SliverFillRemaining
                  const SliverFillRemaining(
                    child: Center(child: TasksLoadingWidget()), 
                  )
                else if (state is TaskFailure)
                  SliverFillRemaining(
                    child: TasksErrorWidget(
                      errorMessage: state.errorMessage,
                      onRetry: () {
                        context.read<TaskCubit>().fetchalltasks();
                      },
                    ),
                  )
                else if (state is TaskSuccess)
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: 24.w,
                      right: 24.w,
                      bottom: 100.h,
                    ),
                    sliver: SliverList.separated(
                      itemCount: state.task.length, // لاحظ أنك سميتها task وليس tasks
                      separatorBuilder: (context, index) => AppSpacing.gapV16,
                      itemBuilder: (context, index) {
                        final task = state.task[index];
                        return TaskCard(
                          task: task,
                          onDelete: () => _handleDelete(index),
                          onOpenDetails: () {
                            Navigator.pushNamed(context, AppRoutes.taskDetails);
                          },
                          onToggleCompletion: () {
                            // سيتم ربطها بـ Cubit Method لاحقاً
                          },
                        );
                      },
                    ),
                  )
                else
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleDelete(int index) {
    // سيتم استبدال هذا لاحقاً بـ context.read<TaskCubit>().deleteTask(index)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task Deleted!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}