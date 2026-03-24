import 'package:taskflow/Features/Task/Domain/Entities/subtask_entity.dart';


class SubtaskModel extends SubtaskEntity {
  const SubtaskModel({
    required super.id,
    required super.title,
    required super.isDone,
  });

  factory SubtaskModel.fromJson(Map<String, dynamic> json) {
    return SubtaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'بدون عنوان',
      // 👈 السيرفر يرسل status: "OPEN" أو "DONE"، نحن نحولها لـ boolean
      isDone: (json['status'] as String?)?.toUpperCase() == 'DONE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': isDone ? 'DONE' : 'OPEN', // إعادتها للغة السيرفر
    };
  }
}