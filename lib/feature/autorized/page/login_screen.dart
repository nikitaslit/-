import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter/feature/autorized/cubit/auth_cubit.dart';
import 'package:github_flutter/feature/autorized/cubit/auth_cubit_state.dart';
import 'package:github_flutter/feature/autorized/page/registeration.dart';
import 'package:github_flutter/feature/screens/homepage.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const path = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Авторизация"),
      ),
      body: BlocConsumer<AuthCubit, AuthCubitState>(
        listener: (context, state) {
          if (state is AuthCubitAuthorized) {
            GoRouter.of(context).go(Homepage.path); // Переход на главную страницу при успешной авторизации
          }
          if (state is AuthCubitUnAuthorized) {
            final error = state.error ?? "Неизвестная ошибка";
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.toString()))); // Показ ошибки при неудачной авторизации
          }
        },
        builder: (BuildContext context, AuthCubitState state) {
          if (state is AuthCubitLoading) {
            return const Center(child: CircularProgressIndicator()); // Показываем индикатор загрузки
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true, // Скрытие пароля
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().singIn(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                  },
                  child: const Text("Войти"), // Кнопка входа
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => GoRouter.of(context).go(Autorizacia.path), // Переход на экран регистрации
                  child: const Text("Зарегистрироваться"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
