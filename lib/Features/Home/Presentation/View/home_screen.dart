import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_routes.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Features/Home/Domain/Entities/task_entity.dart';
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
  List<TaskEntity> tasks = [
    const TaskEntity(id: '1', title: 'Design Review', subtitle: 'Update Figma files based on feedback', status: 'To Do', time: 'Today, 10:00 AM', isCompleted: false),
    const TaskEntity(id: '2', title: 'Weekly Team Meeting', status: 'In Progress', time: 'Today, 10:00 AM', isCompleted: true),
    const TaskEntity(id: '3', title: 'Write Content Report', subtitle: 'Analyze last month\'s post performance', status: 'To Do', time: 'Tomorrow, 02:00 PM', isCompleted: false),
    const TaskEntity(id: '4', title: 'Buy Office Supplies', status: 'To Do', time: 'Oct 24', isCompleted: false),
    const TaskEntity(id: '5', title: 'Gym Session', status: 'To Do', time: 'Today, 06:00 PM', isCompleted: false),
  ];

  @override
  Widget build(BuildContext context) {
    // 👈 1. تمت إزالة extendBody: true لأن الشاشة الحاضنة هي من تتولى ذلك
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: false, // 👈 2. نبقيها false ليتمكن المحتوى من النزول خلف شريط التنقل الخاص بالشاشة الحاضنة
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