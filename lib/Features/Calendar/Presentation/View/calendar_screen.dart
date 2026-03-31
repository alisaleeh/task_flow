import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Constants/app_routes.dart';
import 'package:taskflow/Core/Utils/context_extensions.dart';
import 'package:taskflow/Features/Calendar/Presentation/View/widgets/calendar_header.dart';
import 'package:taskflow/Features/Calendar/Presentation/View/widgets/calendar_tasks_list.dart';
import 'package:taskflow/Features/Calendar/Presentation/View/widgets/custom_calendar_card.dart';
import 'package:taskflow/Features/Calendar/Presentation/View/widgets/tasks_today_header.dart';
import 'package:taskflow/Features/Home/Presentation/Manager/Task_cubit/task_cubit.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Map<String, List<TaskEntity>> _tasksByDay = <String, List<TaskEntity>>{};

  String _dayKey(DateTime d) {
    final local = d.toLocal();
    return '${local.year}-${local.month}-${local.day}';
  }

  void _rebuildTasksIndex(List<TaskEntity> tasks) {
    final map = <String, List<TaskEntity>>{};
    for (final t in tasks) {
      map.putIfAbsent(_dayKey(t.dueDate), () => <TaskEntity>[]).add(t);
    }
    _tasksByDay = map;
  }

  List<TaskEntity> _tasksForSelectedDay() {
    return _tasksByDay[_dayKey(_selectedDay)] ?? const <TaskEntity>[];
  }

  List<String> _eventLoader(DateTime day) {
    final list = _tasksByDay[_dayKey(day)];
    return (list != null && list.isNotEmpty) ? const ['Task'] : const [];
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.taskCubit;
      if (cubit.state is TaskInitial) {
        cubit.fetchalltasks();
      }
    });
  }

  Future<void> _onNewTaskPressed() async {
    final result = await Navigator.of(context).pushNamed(
      AppRoutes.createTask,
      arguments: _selectedDay,
    );

    if (result == true && mounted) {
      await context.taskCubit.fetchalltasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appThemeColors.backgroundColor,
      body: SafeArea(
        child: BlocListener<TaskCubit, TaskState>(
          listener: (context, state) {
            if (state is TaskSuccess) {
              _rebuildTasksIndex(state.task);
              setState(() {});
            }
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: AppSpacing.gapV24),

              SliverToBoxAdapter(child: const CalendarHeader()),
              SliverToBoxAdapter(child: AppSpacing.gapV24),

              SliverToBoxAdapter(
                child: CustomCalendarCard(
                  selectedDay: _selectedDay,
                  focusedDay: _focusedDay,
                  eventLoader: _eventLoader,
                  onDaySelected: (selected, focused) {
                    setState(() {
                      _selectedDay = selected;
                      _focusedDay = focused;
                    });
                  },
                ),
              ),
              SliverToBoxAdapter(child: AppSpacing.gapV32),

              SliverToBoxAdapter(
                child: TasksTodayHeader(
                  selectedDay: _selectedDay,
                  onNewTask: _onNewTaskPressed,
                ),
              ),
              SliverToBoxAdapter(child: AppSpacing.gapV16),

              CalendarTasksList(tasks: _tasksForSelectedDay()),

              SliverToBoxAdapter(child: SizedBox(height: 100.h)),
            ],
          ),
        ),
      ),
    );
  }
}
