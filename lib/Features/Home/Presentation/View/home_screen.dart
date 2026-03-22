import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_routes.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/home_header.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/task_filter_row.dart';
import 'package:taskflow/Features/Home/Presentation/View/Widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ملاحظة هندسية: هذه البيانات المؤقتة ستُستبدل بـ BlocBuilder لاحقاً
  // ملاحظة: قمنا بإزالة كلمة const لأن DateTime.now() لا يمكن أن تكون ثابتة وقت الترجمة (Compile time)

  List<TaskEntity> tasks = [
    TaskEntity(
      id: '1',
      title: 'Design Review',
      subtitle: 'Update Figma files based on feedback',
      status: TaskStatus.todo,
      dueDate: DateTime.now().copyWith(
        hour: 10,
        minute: 0,
      ), // محاكاة للساعة 10 صباحاً اليوم
      isCompleted:
          false, // 👈 1. نحددها يدوياً هنا، لكن الكيان سيحسبها تلقائياً بناءً على الـ status
    ),
    TaskEntity(
      id: '2',
      title: 'Weekly Team Meeting',
      status: TaskStatus
          .inProgress, // 👈 لن نكتب isCompleted هنا، الكيان سيحسبها تلقائياً أنها false
      dueDate: DateTime.now().copyWith(hour: 10, minute: 0),
      isCompleted: false,
    ),
    TaskEntity(
      id: '3',
      title: 'Write Content Report',
      subtitle: 'Analyze last month\'s post performance',
      status: TaskStatus.todo,
      dueDate: DateTime.now()
          .add(const Duration(days: 1))
          .copyWith(hour: 14, minute: 0), // Tomorrow 02:00 PM
      isCompleted: false,
    ),
    TaskEntity(
      id: '4',
      title: 'Buy Office Supplies',
      status: TaskStatus
          .done, // 👈 بمجرد وضعها done، الـ isCompleted ستصبح true تلقائياً
      dueDate: DateTime.now().copyWith(month: 10, day: 24), // Oct 24
      isCompleted: false,
    ),
    TaskEntity(
      id: '5',
      title: 'Gym Session',
      status: TaskStatus.todo,
      dueDate: DateTime.now().copyWith(hour: 18, minute: 0), // Today 06:00 PM
      isCompleted: true,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    // 👈 1. تمت إزالة extendBody: true لأن الشاشة الحاضنة هي من تتولى ذلك
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom:
            false, // 👈 2. نبقيها false ليتمكن المحتوى من النزول خلف شريط التنقل الخاص بالشاشة الحاضنة
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. قسم الهيدر والفلاتر
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

            // 2. قسم قائمة المهام
            SliverPadding(
              // 👈 3. نبقي الـ Padding السفلي (100.h) لكي لا تختفي المهمة الأخيرة خلف الـ NavBar الخاص بالشاشة الحاضنة
              padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 100.h),
              sliver: SliverList.separated(
                itemCount: tasks.length,
                separatorBuilder: (context, index) => AppSpacing.gapV16,
                itemBuilder: (context, index) {
                  final task = tasks[index];
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
            ),
          ],
        ),
      ),
      // 👈 4. تم مسح الـ floatingActionButton من هنا (أصبح في MainLayoutScreen)
      // 👈 5. تم مسح الـ bottomNavigationBar من هنا (أصبح في MainLayoutScreen)
    );
  }

  // دالة الحذف المؤقتة (UI Update only)
  void _handleDelete(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task Deleted!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
