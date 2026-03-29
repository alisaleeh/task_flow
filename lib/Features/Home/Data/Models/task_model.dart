import 'package:taskflow/Features/Home/Data/Models/sub_task_model.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';



class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    super.subtitle,
    required super.status,
    required super.dueDate,
    required super.subtasks,
    required super.priority,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'بدون عنوان',
      subtitle: json['description'] as String?, // في الـ API اسمها description
      
      // 👈 استخدام دوال مساعدة لتحويل نصوص الـ API إلى Enums
      status: _parseStatus(json['status'] as String?),
      priority: _parsePriority(json['priority'] as String?),
      
      // 👈 السيرفر لا يرسل dueDate، فسنعتمد على createdAt مبدئياً
      dueDate: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
          
      subtasks: json['subtasks'] != null
          ? (json['subtasks'] as List<dynamic>)
              .map(
                (sub) => SubtaskModel.fromJson(
                  Map<String, dynamic>.from(sub as Map),
                ),
              )
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': subtitle,
      'status': _statusToString(status),
      'priority': _priorityToString(priority),
      'createdAt': dueDate.toIso8601String(),
      'subtasks': subtasks.map(SubtaskModel.mapEntityToJson).toList(),
    };
  }

  // ==========================================
  // 🛠️ دوال مساعدة للترجمة بين الـ Enum والـ API
  // ==========================================
  
  static TaskStatus _parseStatus(String? statusText) {
    switch (statusText?.toUpperCase()) {
      case 'IN_PROGRESS': return TaskStatus.inProgress;
      case 'DONE': return TaskStatus.done;
      case 'OPEN':
      default: return TaskStatus.open;
    }
  }

  static String _statusToString(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProgress:
        return 'IN_PROGRESS';
      case TaskStatus.done:
        return 'DONE';
      case TaskStatus.open:
        return 'OPEN';
    }
  }

  static TaskPriority _parsePriority(String? priorityText) {
    switch (priorityText?.toUpperCase()) {
      case 'CRITICAL':
      case 'HIGH': return TaskPriority.high;
      case 'LOW': return TaskPriority.low;
      case 'MEDIUM':
      case 'NORMAL':
      default: return TaskPriority.medium;
    }
  }

  static String _priorityToString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high: return 'HIGH';
      case TaskPriority.low: return 'LOW';
      case TaskPriority.medium: return 'MEDIUM';
    }
  }
}