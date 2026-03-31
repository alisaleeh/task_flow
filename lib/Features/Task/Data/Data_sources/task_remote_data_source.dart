import 'package:taskflow/Core/Utils/api_service.dart';
import 'package:taskflow/Features/Home/Data/Models/sub_task_model.dart';
import 'package:taskflow/Features/Home/Data/Models/task_model.dart';
import 'package:taskflow/Features/Task/Domain/Entities/subtask_entity.dart';


abstract class TaskRemoteDataSource {
 
  // 👈 غيرنا void لـ TaskModel لكي نستفيد من النتيجة
  /// أرجعنا TaskModel بدلاً من void لثلاثة أسباب هندسية:
  /// 1. تأكيد البيانات: استلام النسخة النهائية من السيرفر (مثل الـ ID وتاريخ الإنشاء الدقيق).
  /// 2. سرعة الاستجابة (Optimistic UI): إضافة المهمة للقائمة فوراً في الـ Cubit بدون إعادة تحميل كل المهام.
  /// 3. تجربة المستخدم: التمكن من فتح صفحة تفاصيل المهمة الجديدة مباشرة باستخدام الـ ID العائد.
  Future<TaskModel> createtask({
    required String title,
    required String? description,
    required String priority,
    required String status,
    required DateTime dueDate,
  });
  Future<SubtaskEntity> createSubtask({
    required String title,
    required String ?description,
    required String priority,
    required String status,
    required String taskId,
  });
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final ApiService apiService;
  TaskRemoteDataSourceImpl({required this.apiService});

  @override
  Future<TaskModel> createtask({
    required String title,
    required String? description,
    required String priority,
    required String status,
    required DateTime dueDate,
  }) async {
    var res = await apiService.postData(
      endpoint: "tasks/main",
      data: {
        "title": title,
        "description": description,
        "priority": priority,
        "status": status,
        "dueDate": dueDate.toUtc().toIso8601String(),
      },
    );

    
    return TaskModel.fromJson(res['data']);
  }
  
 @override
Future<SubtaskEntity> createSubtask({
  required String title,
  required String? description,
  required String priority,
  required String status,
  required String taskId,
}) async {
  // 📦 بناء الـ Request Body حسب متطلبات السيرفر (Batch Format)
  final Map<String, dynamic> requestData = {
    "parentId": taskId, // 👈 السيرفر يطلب parentId في الطبقة الأولى
    "subtasks": [
      {
        "title": title,
        "description": description ?? "",
        "priority": priority.toUpperCase(), // نضمن أنها حروف كبيرة
        "status": status.toUpperCase(),     // نضمن أنها حروف كبيرة
      }
    ],
  };

  var res = await apiService.postData(
    endpoint: "tasks/subtasks",
    data: requestData,
  );

  // 🚀 تحليل الاستجابة:
  // بما أن السيرفر استلم مصفوفة، فمن المرجح أن يرجع مصفوفة في الـ data
  if (res['data'] is List && (res['data'] as List).isNotEmpty) {
    return SubtaskModel.fromJson(res['data'][0]); // نأخذ أول عنصر تم إنشاؤه
  }

  // في حال كان السيرفر يرجع كائن واحد مباشرة بعد الإنشاء
  return SubtaskModel.fromJson(res['data']);
}
}