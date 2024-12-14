import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:github_flutter/feature/autorized/page/login_screen.dart';
import 'package:go_router/go_router.dart'; // Импортируем GoRouter

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String path = "/settings_page";

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    // Проверка, есть ли текущий пользователь
    if (currentUser == null) {
      return const Center(
        child: Text('Пользователь не авторизован'),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'UID: ${currentUser.uid}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${currentUser.email}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Выход выполнен')),
                  );
                  GoRouter.of(context).go(LoginScreen.path);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка выхода: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }
}
