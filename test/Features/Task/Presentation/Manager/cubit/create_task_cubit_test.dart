import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:taskflow/Core/Utils/failure.dart';
import 'package:taskflow/Features/Task/Domain/Entities/task_entity.dart';
import 'package:taskflow/Features/Task/Domain/Use_Cases/create_sub_task_use_case.dart';
import 'package:taskflow/Features/Task/Domain/Use_Cases/create_tesk_use_case.dart';
import 'package:taskflow/Features/Task/Presentation/Manager/cubit/create_task_cubit.dart';

class MockCreateTaskUseCase extends Mock implements CreateTeskUseCase {}

class MockCreateSubTaskUseCase extends Mock implements CreateSubTaskUseCase {}

void main() {
  late MockCreateTaskUseCase mockCreateTaskUseCase;
  late MockCreateSubTaskUseCase mockCreateSubTaskUseCase;
  late CreateTaskCubit createTaskCubit;

  final tTaskEntity = TaskEntity(
    id: "123",
    title: "Test Task",
    subtitle: "This is a test task",
    priority: TaskPriority.high,
    status: TaskStatus.done,
    dueDate: DateTime(2024, 7, 1),
  );

  setUp(() {
    mockCreateTaskUseCase = MockCreateTaskUseCase();
    mockCreateSubTaskUseCase = MockCreateSubTaskUseCase();

    createTaskCubit = CreateTaskCubit(
      mockCreateTaskUseCase,
      mockCreateSubTaskUseCase,
    );
  });

  tearDown(() {
    createTaskCubit.close();
  });

  group('CreateTaskCubit - createTask method', () {
    // 1. اختبار حالة النجاح
    blocTest<CreateTaskCubit, CreateTaskState>(
      // استبدل CreateTaskState بالاسم الفعلي للكلاس الأساسي للحالات
      'should emit [CreateTaskLoading, CreateTaskSuccess] when UseCase returns Right',

      build: () {
        when(
          () => mockCreateTaskUseCase.createTask(tTaskEntity),
        ).thenAnswer((_) async => Right(tTaskEntity));
        return createTaskCubit;
      },

      act: (cubit) => cubit.createTask(tTaskEntity),

      expect: () => [isA<CreateTaskLoading>(), isA<CreateTaskSuccess>()],

      verify: (_) {
        verify(() => mockCreateTaskUseCase.createTask(tTaskEntity)).called(1);
      },
    );

    // 2. اختبار حالة الفشل
    blocTest<CreateTaskCubit, CreateTaskState>(
      'should emit [CreateTaskLoading, CreateTaskError] when UseCase returns Left',

      build: () {
        final tFailure = ServerFailure('there is an error', 500);

        when(
          () => mockCreateTaskUseCase.createTask(tTaskEntity),
        ).thenAnswer((_) async => Left(tFailure));
        return createTaskCubit;
      },

      act: (cubit) => cubit.createTask(tTaskEntity),

      expect: () => [isA<CreateTaskLoading>(), isA<CreateTaskError>()],

      verify: (_) {
        verify(() => mockCreateTaskUseCase.createTask(tTaskEntity)).called(1);
      },
    );
  });
}
