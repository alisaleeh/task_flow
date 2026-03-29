import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskflow/Features/Home/Data/Models/task_model.dart';
import 'package:taskflow/Features/Home/Domain/Entities/task_summary_entity.dart';

abstract class HomeLocalDataSource {
  Future<void> cacheTasks(List<TaskModel> tasksToCache);
  Future<void> cacheTaskSummary(TaskSummaryEntity summary);
  Future<TaskSummaryEntity?> getCachedTaskSummary();
  Future<List<TaskModel>> getCachedTasks();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const cachedTasksKey = 'CACHED_TASKS';
  static const cachedTaskSummaryKey = 'CACHED_TASK_SUMMARY';

  HomeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheTasks(List<TaskModel> tasksToCache) async {
    // كل مهمة تُحفظ مع مصفوفة subtasks داخل نفس الكائن (انظر TaskModel.toJson).
    final taskModelsToJson = tasksToCache.map((t) => t.toJson()).toList();
    await sharedPreferences.setString(cachedTasksKey, jsonEncode(taskModelsToJson));
  }

  @override
  Future<void> cacheTaskSummary(TaskSummaryEntity summary) async {
    final map = <String, dynamic>{
      'totalTasksToday': summary.totalTasksToday,
      'completedTasks': summary.completedTasks,
      'completionPercentage': summary.completionPercentage,
    };
    await sharedPreferences.setString(
      cachedTaskSummaryKey,
      jsonEncode(map),
    );
  }

  @override
  Future<TaskSummaryEntity?> getCachedTaskSummary() async {
    final jsonString = sharedPreferences.getString(cachedTaskSummaryKey);
    if (jsonString == null) return null;
    final map = jsonDecode(jsonString);
    if (map is! Map) return null;
    final m = Map<String, dynamic>.from(map);
    return TaskSummaryEntity(
      totalTasksToday: (m['totalTasksToday'] as num).toInt(),
      completedTasks: (m['completedTasks'] as num).toInt(),
      completionPercentage: (m['completionPercentage'] as num).toDouble(),
    );
  }

  @override
  Future<List<TaskModel>> getCachedTasks() async {
    // 1. قراءة النص من الذاكرة
    final jsonString = sharedPreferences.getString(cachedTasksKey);

    if (jsonString != null) {
      // 2. فك التشفير من نص إلى قائمة من الـ dynamic
      List<dynamic> decodeJsonData = jsonDecode(jsonString);

      final jsonToTaskModels = decodeJsonData
          .map<TaskModel>(
            (jsonTaskModel) => TaskModel.fromJson(
              Map<String, dynamic>.from(jsonTaskModel as Map),
            ),
          )
          .toList();

      return jsonToTaskModels;
    } else {
      // إذا لم يكن هناك مهام محفوظة مسبقاً
      return [];
    }
  }
}