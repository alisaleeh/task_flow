import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/Features/Home/Data/Models/sub_task_model.dart';
import 'package:taskflow/Features/Home/Data/Models/task_model.dart';
import 'package:taskflow/Features/Task/Data/Data_sources/task_loacal_data_source.dart';
import 'package:taskflow/Features/Task/Data/Data_sources/task_remote_data_source.dart';
import 'package:taskflow/Features/Task/Data/Repo/task_repo_imp.dart';
import 'package:taskflow/Features/Task/Domain/Entities/subtask_entity.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';

class MockTaskRemoteDataSource extends Mock implements TaskRemoteDataSource {}

class MockTaskLocalDataSource extends Mock implements TaskLocalDataSource {}

void main() {
  late MockTaskRemoteDataSource mockTaskRemoteDataSource;
  late MockTaskLocalDataSource mockTaskLocalDataSource;
  late TaskRepoImp taskRepoImp;
  setUp(() {
    mockTaskRemoteDataSource = MockTaskRemoteDataSource();
    mockTaskLocalDataSource = MockTaskLocalDataSource();
    taskRepoImp = TaskRepoImp(
      remoteDataSource: mockTaskRemoteDataSource,
      localDataSource: mockTaskLocalDataSource,
    );
  });
  group("اختبار ال createtask", () {
    test(
      "التأكد من أن الـ Repo يأخذ الـ TaskEntity، يرسله للـ DataSource، ويغلف النتيجة في Right",
      () async {
        final tTaskEntity = TaskEntity(
          id: "123",
          title: "Test Task",
          subtitle: "This is a test task",
          priority: TaskPriority.high,
          status: TaskStatus.done,
          dueDate: DateTime(2024, 7, 1),
        );
        final tTaskModel = TaskModel(
          id: tTaskEntity.id,
          title: tTaskEntity.title,
          status: tTaskEntity.status,
          dueDate: tTaskEntity.dueDate,
          subtasks: tTaskEntity.subtasks,
          priority: tTaskEntity.priority,
        );
        when(
          () => mockTaskRemoteDataSource.createtask(
            title: tTaskEntity.title,
            description: tTaskEntity.subtitle ?? "",
            priority: any(named: "priority"),
            status: any(named: "status"),
            dueDate: tTaskEntity.dueDate,
          ),
        ).thenAnswer((_) async => tTaskModel);
        final result = await taskRepoImp.createTask(tTaskEntity);
        expect(result, equals(Right(tTaskModel)));
        verify(
          () => mockTaskRemoteDataSource.createtask(
            title: tTaskEntity.title,
            description: tTaskEntity.subtitle ?? "",
            priority: any(named: "priority"),
            status: any(named: "status"),
            dueDate: tTaskEntity.dueDate,
          ),
        ).called(1);
      },
    );
    test("التأكد من إرجاع Left عند فشل الاتصال بالـ DataSource", () async {
      final tTaskEntity = TaskEntity(
        id: "123",
        title: "Test Task",
        subtitle: "This is a test task",
        priority: TaskPriority.high,
        status: TaskStatus.done,
        dueDate: DateTime(2024, 7, 1),
      );
      when(
        () => mockTaskRemoteDataSource.createtask(
          title: tTaskEntity.title,
          description: tTaskEntity.subtitle ?? "",
          priority: any(named: "priority"),
          status: any(named: "status"),
          dueDate: tTaskEntity.dueDate,
        ),
      ).thenAnswer((_) async => throw Exception("Failed to connect to server"));
      final result = await taskRepoImp.createTask(tTaskEntity);
      expect(result, isA<Left>());
      verify(
        () => mockTaskRemoteDataSource.createtask(
          title: tTaskEntity.title,
          description: tTaskEntity.subtitle ?? "",
          priority: any(named: "priority"),
          status: any(named: "status"),
          dueDate: tTaskEntity.dueDate,
        ),
      ).called(1);
    });
  });
  group("اختبار ال subtasks", () {
    test(
      "تاكد ان الrepo imp ياخد ال subtasksEntity ,يرسلها لل datasource,يغلفها في Right ",
      () async {
        final tSubtaskEntity = SubtaskEntity(
          id: "123",
          title: "title",
          isDone: true,
          taskId: "1233",
          priority: TaskPriority.high,
          status: TaskStatus.done,
        );
        final tsubtaskModel = SubtaskModel(
          id: tSubtaskEntity.id,
          title: tSubtaskEntity.title,
          isDone: tSubtaskEntity.isDone,
          taskId: tSubtaskEntity.taskId,
          priority: tSubtaskEntity.priority,
          status: tSubtaskEntity.status,
        );
        when(
          () => mockTaskRemoteDataSource.createSubtask(
            title: tSubtaskEntity.title,
            description: "",
            priority: any(named: "priority"),
            status: any(named: "status"),
            taskId: tSubtaskEntity.taskId,
          ),
        ).thenAnswer((_) async => tsubtaskModel);
        final result = await taskRepoImp.createSubtask(tSubtaskEntity);
        expect(result, equals(Right(tsubtaskModel)));
        verify(
          () => mockTaskRemoteDataSource.createSubtask(
            title: tSubtaskEntity.title,
            description: "",
            priority: any(named: "priority"),
            status: any(named: "status"),
            taskId: tSubtaskEntity.taskId,
          ),
        ).called(1);
      },
    );
    test("التأكد من إرجاع Left عند فشل الاتصال بالـ DataSource", () async {
      final tSubtaskEntity = SubtaskEntity(
        id: "123",
        title: "title",
        isDone: true,
        taskId: "1233",
        priority: TaskPriority.high,
        status: TaskStatus.done,
      );
      when(
        () => mockTaskRemoteDataSource.createSubtask(
          title: tSubtaskEntity.title,
          description: "",
          priority: any(named: "priority"),
          status: any(named: "status"),
          taskId: tSubtaskEntity.taskId,
        ),
      ).thenAnswer((_) async => throw Exception("Failed to connect to server"));
      final result = await taskRepoImp.createSubtask(tSubtaskEntity);
      expect(result, isA<Left>());
      verify(
        () => mockTaskRemoteDataSource.createSubtask(
          title: tSubtaskEntity.title,
          description: "",
          priority: any(named: "priority"),
          status: any(named: "status"),
          taskId: tSubtaskEntity.taskId,
        ),
      ).called(1);
    });
  });
}
