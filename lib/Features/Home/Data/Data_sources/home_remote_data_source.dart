import 'package:taskflow/Core/Utils/api_service.dart';
import 'package:taskflow/Features/Home/Data/Models/task_model.dart';
import 'package:taskflow/Features/Home/Domain/Entities/task_summary_entity.dart';
import 'package:taskflow/Features/Home/Domain/Entities/tasks_response_entity.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';

abstract class HomeRemoteDataSource {
  Future<TasksResponseEntity> fetchAllTasks();
  Future<TaskSummaryEntity> fetchTasksSummary();
  Future<void> deleteTask(String taskId);
  Future<void> updateTask(String taskid, String? status, String? priority);
}

class HomeRemoteDataSourceImp implements HomeRemoteDataSource {
  final ApiService apiService;

  HomeRemoteDataSourceImp({required this.apiService});
  @override
  Future<TasksResponseEntity> fetchAllTasks() async {
    var result = await apiService.getData(endpoint: "tasks");

    List<dynamic> tasksList = result['data']['data'];
    TaskSummaryEntity summary = TaskSummaryEntity(
      totalTasksToday: result['data']["totalTasks"],
      completedTasks: result['data']["completedTasks"],
      completionPercentage: (result['data']["completionPercentage"]).toDouble(),
    );

    List<TaskEntity> tasks = [];
    for (var taskData in tasksList) {
      tasks.add(TaskModel.fromJson(taskData));
    }

    return TasksResponseEntity(tasks: tasks, summary: summary);
  }

  @override
  Future<TaskSummaryEntity> fetchTasksSummary() async {
    var result = await apiService.getData(endpoint: "tasks");
    int total = result['data']["totalTasks"];
    int completed = result['data']["completedTasks"];
    double completionPercentage = result['data']["completionPercentage"];
    return TaskSummaryEntity(
      totalTasksToday: total,
      completedTasks: completed,
      completionPercentage: completionPercentage,
    );
  }

  @override
  Future<void> deleteTask(String taskId) async {
    return await apiService.deleteData(endpoint: "tasks/$taskId");
  }

  @override
  Future<void> updateTask(String taskid, String? status, String? priority) {
    final Map<String, dynamic> data = {};
    if (status != null) data['status'] = status;
    if (priority != null) data['priority'] = priority;

    return apiService.patchData(
      // 2. 🐛 إصلاح الـ 404: حرف الـ 's' هو الذي كان يعطل العملية بأكملها!
      endpoint: "tasks/$taskid", // 👈 tasks بدلاً من task
      data: data,
    );
  }
}
