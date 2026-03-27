import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
  Future<void> fetchalltasks() async {
    try {
      emit(TaskLoading());
      var result = await getAllTasksUseCase.call();
      result.fold(
        (failure) => emit(TaskFailure(errorMessage: failure.errorMessage)),
        (tasks) => emit(TaskSuccess(task: tasks)),
      );
    } catch (e) {
      emit(
        TaskFailure(errorMessage: "An error occurred while fetching tasks."),
      );
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      emit(TaskLoading());
      var result = await deleteTaskUseCase.call(taskId);
      result.fold(
        (failure) => emit(TaskFailure(errorMessage: failure.errorMessage)),
        (_) {
          emit(DeleteTaskSuccess());
          fetchalltasks();
        }, // بعد الحذف، نعيد جلب المهام لتحديث الواجهة
      );
    } catch (e) {
      emit(
        TaskFailure(errorMessage: "An error occurred while deleting the task."),
      );
    }
  }

  Future<void> updateTask({
    required String taskId,
    String? status,
    String? priority,
  }) async {
    // 1. نتأكد أن الشاشة حالياً تعرض البيانات بنجاح
    if (state is TaskSuccess) {
      final currentState = state as TaskSuccess;

      // 🛡️ نأخذ "نسخة احتياطية" من القائمة القديمة قبل التعديل (تحسباً لأي خطأ)
      final List<TaskEntity> backupTasks = List.from(currentState.task);

      // ⚡️ نأخذ "النسخة المتفائلة" التي سنعدلها ونعرضها للمستخدم فوراً
      final List<TaskEntity> optimisticTasks = List.from(currentState.task);

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
                  (e) => e.toString().split('.').last == priority,
                )
              : oldTask.priority,
          status: status != null
              ? TaskStatus.values.firstWhere(
                  // نقارن بحروف كبيرة دائماً لضمان التطابق 100%
                  (e) =>
                      e.toString().split('.').last.toUpperCase() ==
                      status.toUpperCase(),
                  // 🛡️ شبكة الأمان: إذا أرسلنا كلمة غريبة بالخطأ، لا توقف التطبيق، بل احتفظ بالحالة القديمة
                  orElse: () => oldTask.status,
                )
              : oldTask.status,
          dueDate: oldTask.dueDate,
        );

        // 🚀 إصدار حالة النجاح فوراً لتحديث الشاشة (المستخدم سيشعر أن التطبيق صاروخي)
        emit(TaskSuccess(task: optimisticTasks));
      }

      // 🌐 إرسال الطلب للسيرفر في الخلفية بصمت تام
      var result = await updateTaskUseCase.call(taskId, status, priority);

      result.fold(
        (failure) {
          // ❌ السيرفر رفض التعديل أو انقطع الإنترنت!
          // 1. نصدر حالة الخطأ لكي يظهر السناك بار الأحمر
          emit(UpdateTaskError(failure.errorMessage));

          // 2. 🔄 "نتراجع" عن التحديث ونعيد النسخة الاحتياطية للشاشة
          emit(TaskSuccess(task: backupTasks));
        },
        (_) {
          // ✅ السيرفر قَبِل التعديل!
          // لا نفعل أي شيء إطلاقاً! لأن الشاشة محدثة بالفعل.
        },
      );
    }
  }
}
