import 'package:taskflow/Core/Utils/api_service.dart';
import 'package:taskflow/Features/Home/Data/Models/task_model.dart';


abstract class TaskRemoteDataSource {
 
  // 👈 غيرنا void لـ TaskModel لكي نستفيد من النتيجة
  /// أرجعنا TaskModel بدلاً من void لثلاثة أسباب هندسية:
  /// 1. تأكيد البيانات: استلام النسخة النهائية من السيرفر (مثل الـ ID وتاريخ الإنشاء الدقيق).
  /// 2. سرعة الاستجابة (Optimistic UI): إضافة المهمة للقائمة فوراً في الـ Cubit بدون إعادة تحميل كل المهام.
  /// 3. تجربة المستخدم: التمكن من فتح صفحة تفاصيل المهمة الجديدة مباشرة باستخدام الـ ID العائد.
  Future<TaskModel> createtask({
    required String title,
    required String ?description,
    required String priority,
    required String status,
  });
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final ApiService apiService;
  TaskRemoteDataSourceImpl({required this.apiService});

  @override
  Future<TaskModel> createtask({
    required String title,
    required String ?description,
    required String priority,
    required String status,
  }) async {
    var res = await apiService.postData(
      endpoint: "tasks/main",
      data: {
        "title": title,
        "description": description,
        "priority": priority,
        "status": status,
      },
    );

    
    return TaskModel.fromJson(res['data']);
  }
}