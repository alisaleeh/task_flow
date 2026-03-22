import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Widgets/custom_app_bar.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/task_details_actions.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/task_details_description.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/task_details_header.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/task_details_info_grid.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/task_details_subtasks.dart';


class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Task Details',
        actions: [
          IconButton(
            icon: Icon(Icons.edit_note_rounded, color: AppColors.textDark, size: 28.sp),
            onPressed: () {
              // TODO: Navigate to Edit
            },
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.gapV24.h)),
            
            // 1. العنوان وحالة المهمة
            const SliverToBoxAdapter(child: TaskDetailsHeader()),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.gapV32.h)),
            
            // 2. الوصف
            const SliverToBoxAdapter(child: TaskDetailsDescription()),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.gapV32.h)),
            
            // 3. شبكة المعلومات (التاريخ، الوقت، الأولوية)
            const SliverToBoxAdapter(child: TaskDetailsInfoGrid()),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.gapV32.h)),
            
            // 4. المهام الفرعية (SliverList جاهزة للأداء العالي)
            const TaskDetailsSubtasks(), 
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.gapV40.h)),
            
            // 5. الأزرار السفلية
            const SliverToBoxAdapter(child: TaskDetailsActions()),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.gapV24.h)),
          ],
        ),
      ),
    );
  }
}

extension on SizedBox {
  double? get h => null;
}