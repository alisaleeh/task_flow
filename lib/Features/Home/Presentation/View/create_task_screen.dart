import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Widgets/custom_app_bar.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/description_input_field.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/priority_selector.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/save_task_button.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/schedule_card.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/section_title.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/title_input_field.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  // --- Ephemeral UI State (حالة الواجهة المؤقتة) ---
  // لن نضع هذه المتغيرات في الـ Cubit لأنها تخص الواجهة فقط حتى لحظة الضغط على حفظ
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedPriority = 'Medium'; // القيمة الافتراضية
  String _selectedDate = 'Select Date';
  String _selectedTime = 'Select Time';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Create New Task'),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              sliver: SliverFillRemaining(
                hasScrollBody: false, // حماية من خطأ الكيبورد (Overflow)
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Task Title Section
                    const SectionTitle(title: 'TASK TITLE'),
                    AppSpacing.gapV8,
                    TitleInputField(controller: _titleController),
                    AppSpacing.gapV32,

                    // 2. Description Section
                    const SectionTitle(title: 'DESCRIPTION'),
                    AppSpacing.gapV12,
                    DescriptionInputField(controller: _descriptionController),
                    AppSpacing.gapV32,

                    // 3. Schedule Section
                    const SectionTitle(title: 'SCHEDULE'),
                    AppSpacing.gapV12,
                    Row(
                      children: [
                        Expanded(
                          child: ScheduleCard(
                            icon: Icons.calendar_today_outlined,
                            title: 'DATE',
                            value: _selectedDate,
                            onTap: () {
                              // TODO: Show Date Picker
                            },
                          ),
                        ),
                        AppSpacing.gapH16,
                        Expanded(
                          child: ScheduleCard(
                            icon: Icons.access_time_rounded,
                            title: 'TIME',
                            value: _selectedTime,
                            onTap: () {
                              // TODO: Show Time Picker
                            },
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapV32,

                    // 4. Priority Section
                    const SectionTitle(title: 'PRIORITY'),
                    AppSpacing.gapV12,
                    PrioritySelector(
                      selectedPriority: _selectedPriority,
                      onPriorityChanged: (newPriority) {
                        setState(() {
                          _selectedPriority = newPriority;
                        });
                      },
                    ),

                    AppSpacing.gapV40,

                    // 5. Save Button
                    SaveTaskButton(),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
