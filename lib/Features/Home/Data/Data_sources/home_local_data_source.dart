import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskflow/Features/Home/Data/Models/task_model.dart';

abstract class HomeLocalDataSource {
  Future<void> cacheTasks(List<TaskModel> tasksToCache);
  Future<List<TaskModel>> getCachedTasks();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  // المفتاح السري الذي سنحفظ به المهام
  static const cachedTasksKey = 'CACHED_TASKS';

  HomeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheTasks(List<TaskModel> tasksToCache) async {
    // 1. تحويل قائمة الموديلز إلى قائمة من الـ Maps
    List<Map<String, dynamic>> taskModelsToJson = tasksToCache
        .map((taskModel) => taskModel.toJson())
        .toList();

    // 2. تحويل الـ Maps إلى نص (JSON String) لكي يقبله الشيرد بريفرنس
    String jsonString = jsonEncode(taskModelsToJson);

    // 3. الحفظ في الذاكرة المحلية
    await sharedPreferences.setString(cachedTasksKey, jsonString);
  }

  @override
  Future<List<TaskModel>> getCachedTasks() async {
    // 1. قراءة النص من الذاكرة
    final jsonString = sharedPreferences.getString(cachedTasksKey);

    if (jsonString != null) {
      // 2. فك التشفير من نص إلى قائمة من الـ dynamic
      List<dynamic> decodeJsonData = jsonDecode(jsonString);

      // 3. تحويل الـ dynamic إلى قائمة من TaskModel
      List<TaskModel> jsonToTaskModels = decodeJsonData
          .map<TaskModel>((jsonTaskModel) => TaskModel.fromJson(jsonTaskModel))
          .toList();

      return jsonToTaskModels;
    } else {
      // إذا لم يكن هناك مهام محفوظة مسبقاً
      return [];
    }
  }
}