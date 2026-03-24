import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskflow/Features/Home/Data/Models/task_model.dart';

abstract class TaskLocalDataSource {
  /// إضافة مهمة واحدة جديدة إلى قائمة المهام المحفوظة في الكاش
  Future<void> cacheSingleTask(TaskModel task);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  // نستخدم نفس المفتاح الذي استخدمناه في Home لضمان مزامنة البيانات
  static const cachedTasksKey = 'CACHED_TASKS';

  TaskLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheSingleTask(TaskModel task) async {
    // 1. جلب قائمة المهام القديمة من الكاش أولاً
    final jsonString = sharedPreferences.getString(cachedTasksKey);
    List<TaskModel> currentCachedTasks = [];

    if (jsonString != null) {
      List<dynamic> decodedData = jsonDecode(jsonString);
      currentCachedTasks = decodedData
          .map((item) => TaskModel.fromJson(item))
          .toList();
    }

    // 2. إضافة المهمة الجديدة للقائمة (في بداية القائمة لتظهر أولاً)
    currentCachedTasks.insert(0, task);

    // 3. تحويل القائمة المحدثة لنص JSON وحفظها من جديد
    final updatedJsonString = jsonEncode(
      currentCachedTasks.map((e) => e.toJson()).toList(),
    );

    await sharedPreferences.setString(cachedTasksKey, updatedJsonString);
  }
}