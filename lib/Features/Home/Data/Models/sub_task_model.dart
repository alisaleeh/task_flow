import 'package:taskflow/Features/Task/Domain/Entities/subtask_entity.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart'; // لجلب الـ Enums

class SubtaskModel extends SubtaskEntity {
  const SubtaskModel({
    required super.id,
    required super.title,
    required super.isDone,
    required super.taskId,
    required super.priority,
    required super.status,
    super.subtitle,
  });

  factory SubtaskModel.fromJson(Map<String, dynamic> json) {
    return SubtaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'بدون عنوان',
      subtitle: json['description'] as String?, // السيرفر يرسلها description أحياناً
      taskId: json['parentId'] as String? ?? '', // في الـ API المهام الفرعية تتبع parentId
      
      // 🚀 تحويل الـ Boolean بناءً على الـ Status القادم من السيرفر
      isDone: (json['status'] as String?)?.toUpperCase() == 'DONE',
      
      // 🚀 استخدام نفس دوال المابنج (Mapping) التي استخدمناها في TaskModel
      status: _parseStatus(json['status'] as String?),
      priority: _parsePriority(json['priority'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': subtitle,
      'parentId': taskId,
      'status': isDone ? 'DONE' : _statusToString(status),
      'priority': _priorityToString(priority),
    };
  }

  // ==========================================
  // 🛠️ دوال مساعدة (يفضل وضعها في Utility أو كلاس أساسي لعدم التكرار)
  // ==========================================

  static TaskStatus _parseStatus(String? statusText) {
    switch (statusText?.toUpperCase()) {
      case 'IN_PROGRESS': return TaskStatus.inProgress;
      case 'DONE': return TaskStatus.done;
      default: return TaskStatus.open;
    }
  }

  static String _statusToString(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProgress: return 'IN_PROGRESS';
      case TaskStatus.done: return 'DONE';
      default: return 'OPEN';
    }
  }

  static TaskPriority _parsePriority(String? priorityText) {
    switch (priorityText?.toUpperCase()) {
      case 'HIGH':
      case 'CRITICAL': return TaskPriority.high;
      case 'LOW': return TaskPriority.low;
      default: return TaskPriority.medium;
    }
  }

  static String _priorityToString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high: return 'HIGH';
      case TaskPriority.low: return 'LOW';
      default: return 'MEDIUM';
    }
  }
}