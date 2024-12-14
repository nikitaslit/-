import 'package:github_flutter/feature/task/model/task_model.dart';

abstract class ITaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> getTaskById(String taskId);
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}