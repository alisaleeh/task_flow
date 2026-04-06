import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/Core/Utils/api_service.dart';
import 'package:taskflow/Features/Home/Data/Models/task_model.dart';
import 'package:taskflow/Features/Task/Data/Data_sources/task_remote_data_source.dart';
import 'package:taskflow/Features/Task/Domain/Entities/subtask_entity.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;
  late TaskRemoteDataSourceImpl taskRemoteDataSource;
  setUp(() {
    mockApiService = MockApiService();
    taskRemoteDataSource = TaskRemoteDataSourceImpl(apiService: mockApiService);
  });

  group("اختبار ال createtask", () {
    final tDueDate = DateTime(2024, 7, 1);
    final tTitle = "Test Task";
    final tDescription = "This is a test task";
    final tPriority = "High";
    final tStatus = "To Do";

    test("لما ينجح الاتصال بالسيرفر لازم يرجع تاسك موديل ", () async {
      when(
        () => mockApiService.postData(
          endpoint: "tasks/main",
          data: any(named: "data"),
        ),
      ).thenAnswer(
        (_) async => {
          // هذا الرد الوهمي يحاكي ما يرسله السيرفر الحقيقي
          'data': {
            'id': '123',
            'title': tTitle,
            'description': tDescription,
            'priority': tPriority,
            'status': tStatus,
            'dueDate': tDueDate.toIso8601String(),
          },
        },
      );
      final result = await taskRemoteDataSource.createtask(
        title: tTitle,
        description: tDescription,
        priority: tPriority,
        status: tStatus,
        dueDate: tDueDate,
      );
      expect(result, isA<TaskModel>());
      verify(
        () => mockApiService.postData(
          endpoint: "tasks/main",
          data: any(named: 'data'),
        ),
      ).called(1);
    });
    test("في حال فشل الاتصال بالسيرفر يجب ان يرجع exeption", () async {
      when(
        () => mockApiService.postData(
          endpoint: "tasks/main",
          data: any(named: "data"),
        ),
      ).thenThrow(Exception("Failed to connect to server"));
      // هي بتفحص النتيجة
      expect(
        () => taskRemoteDataSource.createtask(
          title: tTitle,
          description: tDescription,
          priority: tPriority,
          status: tStatus,
          dueDate: tDueDate,
        ),
        throwsA(isA<Exception>()),
      );
      //هي بتفحص السلوك
      verify(
        () => mockApiService.postData(
          endpoint: "tasks/main",
          data: any(named: 'data'),
        ),
      ).called(1);
    });
  });
  group("اختبار ال createsubtask", () {
    final tTitle = "Test Subtask";
    final tDescription = "This is a test subtask";
    final tPriority = "Medium";
    final tStatus = "In Progress";
    final tTaskId = "123";

    test("لما ينجح الاتصال بالسيرفر لازم يرجع SubtaskEntity ", () async {
      when(
        () => mockApiService.postData(
          endpoint: "tasks/subtasks",
          data: any(named: "data"),
        ),
      ).thenAnswer(
        (_) async => {
          'data': {
            'id': '456',
            'title': tTitle,
            'description': tDescription,
            'priority': tPriority,
            'status': tStatus,
            'taskId': tTaskId,
          },
        },
      );
      final result = await taskRemoteDataSource.createSubtask(
        title: tTitle,
        description: tDescription,
        priority: tPriority,
        status: tStatus,
        taskId: tTaskId,
      );
      expect(result, isA<SubtaskEntity>());
      verify(
        () => mockApiService.postData(
          endpoint: "tasks/subtasks",
          data: any(named: 'data'),
        ),
      ).called(1);
    });

    test("لما يفشل الاتصال بالسيرفر لازم يعطي exeption", () async {
      when(
        () => mockApiService.postData(
          endpoint: "tasks/subtasks",
          data: any(named: "data"),
        ),
      ).thenThrow(Exception("Failed to connect to server"));
      // هي بتفحص النتيجة
      expect(
        () => taskRemoteDataSource.createSubtask(
          title: tTitle,
          description: tDescription,
          priority: tPriority,
          status: tStatus,
          taskId: tTaskId,
        ),
        throwsA(isA<Exception>()),
      );
      //هي بتفحص السلوك
      verify(
        () => mockApiService.postData(
          endpoint: "tasks/subtasks",
          data: any(named: 'data'),
        ),
      ).called(1);
    });
  });
}
