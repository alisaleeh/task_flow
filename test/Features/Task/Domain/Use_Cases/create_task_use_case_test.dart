import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'package:taskflow/Features/Task/Domain/Repos/task_repo.dart';
import 'package:taskflow/Features/Task/Domain/Use_Cases/create_tesk_use_case.dart';

class Mocktaskrepo extends Mock implements TaskRepo {}

void main() {
  late Mocktaskrepo mocktaskrepo;
  late CreateTeskUseCase createTaskUseCase;
  setUp(() {
    mocktaskrepo = Mocktaskrepo();
    createTaskUseCase = CreateTeskUseCase(taskRepo: mocktaskrepo);
  });
  group("testing create task ", () {
    test(
      "اختبار انه في حالة نجاح الاتصال مع الريبو يتم ارسال taskentity ارجاع Right<taskentity>",
      () async {
        final tTaskEntity = TaskEntity(
          id: "123",
          title: "Test Task",
          subtitle: "This is a test task",
          priority: TaskPriority.high,
          status: TaskStatus.done,
          dueDate: DateTime(2024, 7, 1),
        );

        when(
          () => mocktaskrepo.createTask(tTaskEntity),
        ).thenAnswer((_) async => Right(tTaskEntity));
        final result = await createTaskUseCase.createTask(tTaskEntity);
        expect(result, equals(Right(tTaskEntity)));
        verify(() => mocktaskrepo.createTask(tTaskEntity)).called(1);
      },
    );
  });
  test('اختبار انه في حال فشل الاتصال بالريبو يرجع left', () async {
    final tTaskEntity = TaskEntity(
      id: "123",
      title: "Test Task",
      subtitle: "This is a test task",
      priority: TaskPriority.high,
      status: TaskStatus.done,
      dueDate: DateTime(2024, 7, 1),
    );
    when(
      () => mocktaskrepo.createTask(tTaskEntity),
    ).thenAnswer((_) async => Left(ServerFailure('there is an error', 500)));
    final result = await createTaskUseCase.createTask(tTaskEntity);
    expect(result, isA<Left>());
    verify(() => mocktaskrepo.createTask(tTaskEntity)).called(1);
  });
}
