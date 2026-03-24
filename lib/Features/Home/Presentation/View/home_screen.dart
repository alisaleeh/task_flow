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
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TaskCubit>().fetchalltasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.primaryOrange,
              onRefresh: () async {
                await context.read<TaskCubit>().fetchalltasks();
              },

              child: CustomScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(), // 👈 3. تغيير هام جداً!
                slivers: [
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

                  // حالات الـ Cubit
                  if (state is TaskLoading)
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
                    // 👈 إضافة حالة "لا يوجد مهام" التي تحدثنا عنها مسبقاً
                    state.task.isEmpty
                        ? SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'there is no tasks, start adding some! 🚀',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : SliverPadding(
                            padding: EdgeInsets.only(
                              left: 24.w,
                              right: 24.w,
                              bottom: 100.h,
                            ),
                            sliver: SliverList.separated(
                              itemCount: state.task.length,
                              separatorBuilder: (context, index) =>
                                  AppSpacing.gapV16,
                              itemBuilder: (context, index) {
                                final task = state.task[index];
                                return TaskCard(
                                  task: task,
                                  onDelete: () => _handleDelete(index),
                                  onOpenDetails: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.taskDetails,
                                    );
                                  },
                                  onToggleCompletion: () {},
                                );
                              },
                            ),
                          )
                  else
                    const SliverToBoxAdapter(child: SizedBox.shrink()),
                    SliverToBoxAdapter(child: AppSpacing.gapV48,),
                ],
                
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleDelete(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task Deleted!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
