import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflow/Core/Utils/service_locator.dart';
import 'package:taskflow/Features/Auth/Data/Data_sources/local_data_source.dart';
import 'package:taskflow/Features/Home/Domain/Entities/task_summary_entity.dart';
import 'package:taskflow/Features/Home/Domain/Use_Cases/delete_task_use_case.dart';
import 'package:taskflow/Features/Home/Domain/Use_Cases/get_all_tasks_use_case.dart';
import 'package:taskflow/Features/Home/Domain/Use_Cases/update_task_use_case.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit(
    this.getAllTasksUseCase,
    this.deleteTaskUseCase,
    this.updateTaskUseCase,
  ) : super(TaskInitial());

  final GetAllTasksUseCase getAllTasksUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  String firstName = '';
  String lastName = '';

  String _dayKey(DateTime d) {
    final local = d.toLocal();
    return '${local.year}-${local.month}-${local.day}';
  }

  Map<String, List<TaskEntity>> _groupTasksByDay(List<TaskEntity> tasks) {
    final map = <String, List<TaskEntity>>{};
    for (final task in tasks) {
      map.putIfAbsent(_dayKey(task.dueDate), () => <TaskEntity>[]).add(task);
    }
    return map;
  }

  // 🚀 2. دالة جلب بيانات المستخدم من الكاش
  Future<void> fetchUserData() async {
    try {
      // نصل للـ LocalDataSource مباشرة عبر getIt
      final localAuth = getIt<AuthLocalDataSource>();

      firstName = await localAuth.getCachedFirstName() ?? 'ضيف';
      lastName = await localAuth.getCachedLastName() ?? '';

      // إذا أردت تحديث الشاشة بعد جلب الاسم يمكنك إصدار حالة (اختياري)
      // emit(TaskUserDataLoaded());
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // ==========================================
  // 1. جلب المهام (نجلب الملخص من السيرفر مباشرة)
  // ==========================================
  Future<void> fetchalltasks() async {
    try {
      emit(TaskLoading());
      var result = await getAllTasksUseCase.call();

      result.fold(
        (failure) => emit(TaskFailure(errorMessage: failure.errorMessage)),
        (responseEntity) {
          final groupedTasks = _groupTasksByDay(responseEntity.tasks);
          // 🚀 السيرفر أعطانا المهام والملخص الجاهز، نمررهم للشاشة فوراً
          emit(
            TaskSuccess(
              task: responseEntity.tasks,
              tasksByDay: groupedTasks,
              taskSummaryEntity: responseEntity.summary,
            ),
          );
        },
      );
    } catch (e) {
      emit(TaskFailure(errorMessage: "An error occurred"));
    }
  }

  // ==========================================
  // 2. حذف المهمة (Optimistic Delete with Delta)
  // ==========================================
  Future<void> deleteTask(String taskId) async {
    if (state is TaskSuccess) {
      final currentState = state as TaskSuccess;

      // 🛡️ النسخة الاحتياطية
      final backupTasks = List<TaskEntity>.from(currentState.task);
      final backupSummary = currentState.taskSummaryEntity;

      // ⚡️ النسخة المتفائلة
      final optimisticTasks = List<TaskEntity>.from(currentState.task);

      // 🔍 نبحث عن المهمة قبل حذفها لنعرف هل كانت مكتملة أم لا
      final taskToDeleteIndex = optimisticTasks.indexWhere(
        (t) => t.id == taskId,
      );
      if (taskToDeleteIndex == -1) return; // تأمين إضافي

      final wasDone =
          optimisticTasks[taskToDeleteIndex].status == TaskStatus.done;

      // نحذفها محلياً
      optimisticTasks.removeAt(taskToDeleteIndex);

      // 🧮 نحسب الملخص الجديد ذكياً (بدون قراءة القائمة كلها)
      final newSummary = _updateSummaryOnDelete(backupSummary!, wasDone);
      final optimisticTasksByDay = _groupTasksByDay(optimisticTasks);

      // 🚀 نصدر القائمة والملخص الجديد فوراً
      emit(
        TaskSuccess(
          task: optimisticTasks,
          tasksByDay: optimisticTasksByDay,
          taskSummaryEntity: newSummary,
        ),
      );

      // 🌐 نرسل للسيرفر بصمت
      var result = await deleteTaskUseCase.call(taskId);

      result.fold(
        (failure) {
          emit(DeleteTaskError(errormessage: failure.errorMessage));
          // 🔄 تراجع
          emit(
            TaskSuccess(
              task: backupTasks,
              tasksByDay: _groupTasksByDay(backupTasks),
              taskSummaryEntity: backupSummary,
            ),
          );
        },
        (_) {
          emit(DeleteTaskSuccess());
          emit(
            TaskSuccess(
              task: optimisticTasks,
              tasksByDay: optimisticTasksByDay,
              taskSummaryEntity: newSummary,
            ),
          );
        },
      );
    }
  }

  // ==========================================
  // 3. تعديل المهمة (Optimistic Update with Delta)
  // ==========================================
  Future<void> updateTask({
    required String taskId,
    String? status,
    String? priority,
  }) async {
    if (state is TaskSuccess) {
      final currentState = state as TaskSuccess;

      // 🛡️ النسخة الاحتياطية
      final backupTasks = List<TaskEntity>.from(currentState.task);
      final backupSummary = currentState.taskSummaryEntity;

      // ⚡️ النسخة المتفائلة
      final optimisticTasks = List<TaskEntity>.from(currentState.task);
      final taskIndex = optimisticTasks.indexWhere((t) => t.id == taskId);

      if (taskIndex != -1) {
        final oldTask = optimisticTasks[taskIndex];

        // تحديث المهمة بالبيانات الجديدة
        optimisticTasks[taskIndex] = TaskEntity(
          id: oldTask.id,
          title: oldTask.title,
          subtitle: oldTask.subtitle,
          priority: priority != null
              ? TaskPriority.values.firstWhere(
                  (e) => e.name.toUpperCase() == priority.toUpperCase(),
                  orElse: () => oldTask.priority,
                )
              : oldTask.priority,
          status: status != null
              ? TaskStatus.values.firstWhere(
                  (e) => e.name.toUpperCase() == status.toUpperCase(),
                  orElse: () => oldTask.status,
                )
              : oldTask.status,
          dueDate: oldTask.dueDate,
        );

        // 🧮 حساب الملخص الجديد ذكياً
        // نقارن هل الحالة الجديدة التي أرسلناها هي DONE؟
        final isNowDone = status?.toUpperCase() == 'DONE';
        final newSummary = _updateSummaryOnToggle(backupSummary!, isNowDone);
        final optimisticTasksByDay = _groupTasksByDay(optimisticTasks);

        // 🚀 إصدار القائمة المحدثة + الملخص الجديد
        emit(
          TaskSuccess(
            task: optimisticTasks,
            tasksByDay: optimisticTasksByDay,
            taskSummaryEntity: newSummary,
          ),
        );
      }

      // 🌐 نكلم السيرفر بصمت
      var result = await updateTaskUseCase.call(taskId, status, priority);

      result.fold(
        (failure) {
          emit(UpdateTaskError(failure.errorMessage));
          // 🔄 تراجع
          emit(
            TaskSuccess(
              task: backupTasks,
              tasksByDay: _groupTasksByDay(backupTasks),
              taskSummaryEntity: backupSummary,
            ),
          );
        },
        (_) {
          /* ✅ نجاح صامت */
        },
      );
    }
  }

  // ==========================================
  // 🧮 دوال الرياضيات الذكية (Delta Updates)
  // ==========================================
  TaskSummaryEntity _updateSummaryOnDelete(
    TaskSummaryEntity currentSummary,
    bool wasDone,
  ) {
    int newTotal = currentSummary.totalTasksToday - 1;
    if (newTotal < 0) newTotal = 0;

    int newCompleted = currentSummary.completedTasks - (wasDone ? 1 : 0);
    if (newCompleted < 0) newCompleted = 0;

    double newPercentage = newTotal == 0
        ? 0.0
        : (newCompleted / newTotal) * 100;

    return TaskSummaryEntity(
      totalTasksToday: newTotal,
      completedTasks: newCompleted,
      completionPercentage: newPercentage,
    );
  }

  TaskSummaryEntity _updateSummaryOnToggle(
    TaskSummaryEntity currentSummary,
    bool isNowDone,
  ) {
    int newCompleted = currentSummary.completedTasks + (isNowDone ? 1 : -1);

    if (newCompleted < 0) newCompleted = 0;
    if (newCompleted > currentSummary.totalTasksToday)
      newCompleted = currentSummary.totalTasksToday;

    double newPercentage = currentSummary.totalTasksToday == 0
        ? 0.0
        : (newCompleted / currentSummary.totalTasksToday) * 100;

    return TaskSummaryEntity(
      totalTasksToday: currentSummary.totalTasksToday,
      completedTasks: newCompleted,
      completionPercentage: newPercentage,
    );
  }
}
