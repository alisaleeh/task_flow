import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_routes.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_text_styles.dart';
import 'package:taskflow/Core/Utils/context_extensions.dart';
import 'package:taskflow/Core/Widgets/custom_snack_bar.dart'; 
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
      context.taskCubit.fetchalltasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: false,
        // 👈 1. تم التحويل من BlocBuilder إلى BlocConsumer
        child: BlocConsumer<TaskCubit, TaskState>(
          // 👈 2. إضافة الـ Listener للاستماع لحالات الحذف
          listener: (context, state) {
            if (state is DeleteTaskSuccess) {
              CustomSnackBar.showSuccess(context, 'Task deleted successfully!');
            } else if (state is DeleteTaskError) {
              CustomSnackBar.showError(context, state.errormessage);
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.primaryOrange,
              onRefresh: () async {
                await context.taskCubit.fetchalltasks();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(), 
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
                          context.taskCubit.fetchalltasks();
                        },
                      ),
                    )
                  else if (state is TaskSuccess)
                    state.task.isEmpty
                        ? SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'there are no tasks, start adding some! 🚀',
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
                                  onDelete: () => _handleDelete(
                                    context,
                                    state.task[index].id,
                                  ),
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
                  SliverToBoxAdapter(child: AppSpacing.gapV48),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleDelete(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // نستخدم dialogContext لتجنب تداخل الـ context
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // حواف دائرية لشكل عصري
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.error),
              AppSpacing.gapH8,
              Text('confirm deletion', style: AppTextStyles.font12RegularLight),
            ],
          ),
          content: const Text(
            'are you sure you want to delete this task? this action cannot be undone.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            // 👈 زر الإلغاء
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // إغلاق الـ Dialog فقط
              },
              child: const Text(
                'cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 👈 زر الحذف الفعلي
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // لون أحمر للتنبيه بخطورة الإجراء
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // 1. إغلاق الـ Dialog أولاً

                // 2. استدعاء دالة الحذف من الكيوبت باستخدام الـ context الأصلي للشاشة
                context.taskCubit.deleteTask(taskId);
              },
              child: const Text(
                'delete',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}