import 'package:github_flutter/feature/autorized/page/registeration.dart';
import 'package:github_flutter/feature/autorized/page/login_screen.dart';
import 'package:github_flutter/feature/screens/homepage.dart';
import 'package:github_flutter/feature/screens/settingpage.dart';
import 'package:github_flutter/feature/task/page/task_page.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static final route = GoRouter(
    initialLocation: LoginScreen.path, // Указываем начальную локацию
    routes: [
      GoRoute(
        path: Homepage.path, // Путь для главной страницы
        builder: (context, state) => const Homepage(),
      ),
      GoRoute(
        path: LoginScreen.path, // Путь для страницы входа
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Autorizacia.path,
        builder: (context, state) => const Autorizacia(),
      ),
      GoRoute(
        path: NewTaskPage.path,
        builder: (context, state) => const NewTaskPage(),
      ),
      GoRoute(
        path: SettingsPage.path,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
