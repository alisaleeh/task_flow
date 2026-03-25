import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Widgets/custom_app_bar.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'package:taskflow/Features/Task/Presentation/Manager/cubit/create_task_cubit.dart';
import 'package:taskflow/Features/Task/Presentation/View/Widgets/description_input_field.dart';
import 'package:taskflow/Features/Task/Presentation/View/Widgets/priority_selector.dart';
import 'package:taskflow/Features/Task/Presentation/View/Widgets/section_title.dart';
import 'package:taskflow/Features/Task/Presentation/View/Widgets/status_selector.dart';
import 'package:taskflow/Features/Task/Presentation/View/Widgets/title_input_field.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  // القيم الافتراضية كما يتوقعها الـ Selector والـ API
  String _selectedStatus = "TO_DO"; 
  String _selectedPriority = 'MEDIUM';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Create New Task'),
      body: SafeArea(
        child: BlocConsumer<CreateTaskCubit, CreateTaskState>(
          listener: (context, state) {
            if (state is CreateTaskSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ تم إنشاء المهمة بنجاح!'), backgroundColor: Colors.green),
              );
              Navigator.pop(context); // العودة للشاشة الرئيسية بعد النجاح
            } else if (state is CreateTaskError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('❌ خطأ: ${state.message}'), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  sliver: SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(title: 'TASK TITLE'),
                        AppSpacing.gapV8,
                        TitleInputField(controller: _titleController),
                        AppSpacing.gapV32,

                        const SectionTitle(title: 'DESCRIPTION'),
                        AppSpacing.gapV12,
                        DescriptionInputField(controller: _descriptionController),
                        AppSpacing.gapV32,

                        const SectionTitle(title: 'PRIORITY'),
                        AppSpacing.gapV12,
                        PrioritySelector(
                          selectedPriority: _selectedPriority,
                          onPriorityChanged: (val) => setState(() => _selectedPriority = val),
                        ),
                        AppSpacing.gapV32,

                        const SectionTitle(title: 'STATUS'),
                        AppSpacing.gapV12,
                        StatusSelector(
                          selectedStatus: _selectedStatus,
                          onStatusChanged: (val) => setState(() => _selectedStatus = val),
                        ),
                        
                        const Spacer(),
                        AppSpacing.gapV40,

                        // زر الحفظ مدمج هنا مع حالة الـ Loading
                        SizedBox(
                          width: double.infinity,
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: state is CreateTaskLoading ? null : _onSavePressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryOrange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                            ),
                            child: state is CreateTaskLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text('Save Task', style: TextStyle(fontSize: 18.sp, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onSavePressed() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال عنوان المهمة')),
      );
      return;
    }

    // تجهيز الكيان (Entity) لإرساله للكيوبت
    final newTask = TaskEntity(
      id: '', // سيتم توليده في السيرفر
      title: _titleController.text.trim(),
      subtitle: _descriptionController.text.trim(),
      status: _mapStringToStatus(_selectedStatus),
      priority: _mapStringToPriority(_selectedPriority),
      dueDate: DateTime.now(), 
    );

    context.read<CreateTaskCubit>().createTask(newTask);
  }

  // دوال التحويل من نصوص الواجهة إلى Enums الـ Domain
  TaskStatus _mapStringToStatus(String status) {
    switch (status.toUpperCase()) {
      case 'IN_PROGRESS': return TaskStatus.inProgress;
      case 'DONE': return TaskStatus.done;
      default: return TaskStatus.open;
    }
  }

  TaskPriority _mapStringToPriority(String priority) {
    switch (priority.toUpperCase()) {
      case 'HIGH': return TaskPriority.high;
      case 'LOW': return TaskPriority.low;
      default: return TaskPriority.medium;
    }
  }
}