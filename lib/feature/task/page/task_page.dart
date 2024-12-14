import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter/feature/screens/homepage.dart';
import 'package:github_flutter/feature/task/model/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:github_flutter/feature/task/model/cubit/task_cubit.dart';
import 'package:go_router/go_router.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  static const String path = "/task_page";

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void _createtask() {
    final currentUser = _auth.currentUser; // получаем юзера

    if (currentUser == null) {
      // если ошибка существования пользователя
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not logged in')),
      );
      return;
    }

    final task = Task(
      id: '', // сам генерируется
      userId: currentUser.uid, // привязка к юзеру
      title: _titleController.text, // название задачи
      description: _descriptionController.text, // описание
      isCompleted: false, // выполнение, изначально false
    );

    // Добавляем задачу через TaskCubit
    context.read<TaskCubit>().createTask(task).then((_) {
      // Возвращаем задачу на экран задач после успешного добавления
      GoRouter.of(context).go(Homepage.path);
    }).catchError((e) {
      // Обработка ошибки
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Создать заметку")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Событие, Тема...'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'План...'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createtask,
              child: const Text('Создать'),
            ),
            TextButton(
              onPressed: () => GoRouter.of(context).go(Homepage.path),
              child: const Text('Отмена'),
            ),
          ],
        ),
      ),
    );
  }
}
