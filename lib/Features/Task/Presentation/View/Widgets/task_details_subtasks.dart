  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Features/Task/Presentation/View/Widgets/section_title.dart';

// استدعاء الشيك بوكس الدائري
import 'circular_checkbox.dart';

class TaskDetailsSubtasks extends StatefulWidget {
  const TaskDetailsSubtasks({super.key});

  @override
  State<TaskDetailsSubtasks> createState() => _TaskDetailsSubtasksState();
}

class _TaskDetailsSubtasksState extends State<TaskDetailsSubtasks> {
  // بيانات وهمية مؤقتة للـ UI
  List<Map<String, dynamic>> subtasks = [
    {'title': 'Research competitor hero sections', 'isDone': true},
    {'title': 'Wireframe layout variations', 'isDone': false},
    {'title': 'Design high-fidelity mockup', 'isDone': false},
  ];

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      sliver: SliverMainAxisGroup(
        slivers: [
          // عنوان القسم
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: SectionTitle(title: 'SUBTASKS'),
            ),
          ),
          // قائمة الـ Subtasks (Lazy Loading)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final subtask = subtasks[index];
                final isDone = subtask['isDone'] as bool;

                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircularCheckbox(
                        isChecked: isDone,
                        onTap: () {
                          setState(() => subtasks[index]['isDone'] = !isDone);
                        },
                      ),
                      AppSpacing.gapH12,
                      Expanded(
                        child: Text(
                          subtask['title'] as String,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: isDone ? AppColors.textLight : AppColors.textDark,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: subtasks.length,
            ),
          ),
        ],
      ),
    );
  }
}