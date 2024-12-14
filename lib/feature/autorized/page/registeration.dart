import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter/feature/autorized/cubit/auth_cubit.dart';
import 'package:github_flutter/feature/autorized/cubit/auth_cubit_state.dart';
import 'package:github_flutter/feature/autorized/page/login_screen.dart';
import 'package:github_flutter/feature/screens/homepage.dart';
import 'package:go_router/go_router.dart';

class Autorizacia extends StatefulWidget {
  const Autorizacia({super.key});

  static const path = '/regist';

  @override
  State<Autorizacia> createState() => _AutorizaciaState();
}

class _AutorizaciaState extends State<Autorizacia> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Регистрация')),
      body: Center(
        child: BlocConsumer<AuthCubit, AuthCubitState>(
          listener: (context, state) {
            // Обработка состояний после завершения операции регистрации
            if (state is AuthCubitAuthorized) {
              // Если регистрация прошла успешно, перенаправляем на главную страницу
              GoRouter.of(context).go(Homepage.path);
            } else if (state is AuthCubitUnAuthorized) {
              // Если ошибка при регистрации, показываем сообщение об ошибке
              final error = state.error ?? 'Неизвестная ошибка';
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error.toString())));
            }
          },
          builder: (context, state) {
            if (state is AuthCubitLoading) {
              // Если идет процесс регистрации, показываем индикатор загрузки
              return const CircularProgressIndicator();
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
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Вызов метода регистрации из AuthCubit
                      context.read<AuthCubit>().singUp(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                    },
                    child: const Text('Зарегистрироваться'),
                  ),
                  TextButton(
                    onPressed: () => GoRouter.of(context).go(LoginScreen.path),
                    child: const Text('Уже зарегистрированы? Войти'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
