import 'package:taskflow/Core/Utils/api_service.dart';
import 'package:taskflow/Features/Home/Data/Models/task_model.dart';
import 'package:taskflow/Features/Home/Domain/Entities/task_summary_entity.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';

abstract class HomeRemoteDataSource {
  Future<List<TaskEntity>> fetchAllTasks();
  Future<TaskSummaryEntity> fetchTasksSummary();
}

class HomeRemoteDataSourceImp implements HomeRemoteDataSource {
  final ApiService apiService;

  HomeRemoteDataSourceImp({required this.apiService});
  @override
  Future<List<TaskEntity>> fetchAllTasks() async {
    var result = await apiService.getData(endpoint: "tasks");

    List<dynamic> tasksList = result['data']['data'];

    List<TaskEntity> tasks = [];
    for (var taskData in tasksList) {
      tasks.add(TaskModel.fromJson(taskData));
    }

    return tasks;
  }

  @override
  Future<TaskSummaryEntity> fetchTasksSummary() {
    // TODO: implement fetchTasksSummary
    throw UnimplementedError();
  }
}
