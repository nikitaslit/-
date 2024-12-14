import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter/feature/screens/settingpage.dart';
import 'package:github_flutter/feature/task/model/task_model.dart';
import 'package:github_flutter/feature/task/page/task_page.dart';
import 'package:github_flutter/feature/task/model/cubit/task_cubit.dart';
import 'package:github_flutter/feature/task/model/cubit/task_cubit_state.dart';
import 'package:go_router/go_router.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  static const path = '/homepage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    // Загрузить задачи при инициализации виджета
    context.read<TaskCubit>().loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Таск менеджер'),
        actions: [
          // Иконка добавления новой задачи
          IconButton(
            onPressed: () async {
              final result = await GoRouter.of(context).push(NewTaskPage.path); // Переход на страницу создания задачи
              if (result != null && result is Task) {
                context.read<TaskCubit>().createTask(result); // Добавление задачи
              }
            },
            icon: const Icon(Icons.add),
          ),
          // Иконка (профиль)
          IconButton(
            onPressed: () => GoRouter.of(context).go(SettingsPage.path),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body:
          BlocBuilder<TaskCubit, TaskListCubitState>(builder: (context, state) {
        if (state is TaskListStateLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskListStateFailure) {
          return Center(child: Text('Ошибка: ${state.error}'));
        } else if (state is TaskListStateSuccess) {
          final taskList = state.taskList;
          return taskList.isEmpty
              ? const Center(
                  child: Text(
                    'Твой список дел пуст!',
                    style: TextStyle(fontSize: 24),
                  ),
                )
              : ListView.builder(
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    final task = taskList[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: task.isCompleted,
                            onChanged: (bool? value) {
                              // Создаем новый объект задачи с обновленным статусом
                              final updatedTask =
                                  task.copyWith(isCompleted: value ?? false);
                              // Обновляем статус задачи в репозитории
                              context
                                  .read<TaskCubit>()
                                  .updateTaskStatus(updatedTask);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Удаляем задачу
                              context.read<TaskCubit>().deleteTask(task.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
        }
        return const Center(child: Text('Неизвестное состояние'));
      }),
    );
  }
}
