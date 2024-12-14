import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter/feature/task/model/cubit/task_cubit_state.dart';
import 'package:github_flutter/feature/task/model/task_model.dart';

import 'package:github_flutter/feature/task/repository/task_repository.dart';

class TaskCubit extends Cubit<TaskListCubitState> {
  final TaskRepository _taskRepository;

  TaskCubit(this._taskRepository) : super(TaskListStateLoading());

  Future<void> loadTasks() async {
    try {
      final tasks = await _taskRepository.getTasks();
      emit(TaskListStateSuccess(taskList: tasks));
    } catch (e) {
      emit(TaskListStateFailure(error: e.toString()));
    }
  }

  Future<void> createTask(Task task) async {
    try {
      await _taskRepository.addTask(task);
      // Не загружаем заново, просто добавляем задачу в текущий список
      if (state is TaskListStateSuccess) {
        final currentState = state as TaskListStateSuccess;
        final updatedList = List<Task>.from(currentState.taskList)..add(task);
        emit(TaskListStateSuccess(taskList: updatedList));
      }
    } catch (e) {
      emit(TaskListStateFailure(error: e.toString()));
    }
  }

  Future<void> updateTaskStatus(Task task) async {
    try {
      await _taskRepository.updateTaskStatus(task);
      if (state is TaskListStateSuccess) {
        final currentState = state as TaskListStateSuccess;
        final updatedList = currentState.taskList.map((t) {
          return t.id == task.id ? task : t;
        }).toList();
        emit(TaskListStateSuccess(taskList: updatedList));
      }
    } catch (e) {
      emit(TaskListStateFailure(error: e.toString()));
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _taskRepository.deleteTask(taskId);
      if (state is TaskListStateSuccess) {
        final currentState = state as TaskListStateSuccess;
        final updatedList =
            currentState.taskList.where((task) => task.id != taskId).toList();
        emit(TaskListStateSuccess(taskList: updatedList));
      }
    } catch (e) {
      emit(TaskListStateFailure(error: e.toString()));
    }
  }
}
