import 'package:github_flutter/feature/task/model/task_model.dart';

abstract interface class TaskListCubitState {}

final class TaskListStateLoading implements TaskListCubitState {}

final class TaskListStateSuccess implements TaskListCubitState {
  final List<Task> taskList;

  TaskListStateSuccess({required this.taskList});
}

final class TaskListStateFailure implements TaskListCubitState {
  final Object? error;

  TaskListStateFailure({required this.error});
}
