import 'package:taskflow/Features/Home/Data/Models/task_model.dart';
import 'package:taskflow/Features/Home/Domain/Entities/task_summary_entity.dart';
import 'package:taskflow/Features/Home/Domain/Entities/tasks_response_entity.dart';

class TasksResponseModel extends TasksResponseEntity {
  TasksResponseModel({
    required super.tasks,
    required super.summary,
  });

  factory TasksResponseModel.fromJson(Map<String, dynamic> json) {
    // السيرفر يضع البيانات داخل مفتاح اسمه 'data'
    final data = json['data'] ?? {};
    
    // 1. استخراج مصفوفة المهام وتحويلها عبر TaskModel
    final tasksList = (data['data'] as List?) ?? [];
    final tasks = tasksList.map((t) => TaskModel.fromJson(t)).toList();

    // 2. استخراج الملخص
    final summary = TaskSummaryEntity(
      totalTasksToday: data['totalTasks'] ?? 0,
      completedTasks: data['completedTasks'] ?? 0,
      completionPercentage: (data['completionPercentage'] ?? 0).toDouble(),
    );

    return TasksResponseModel(tasks: tasks, summary: summary);
  }
}