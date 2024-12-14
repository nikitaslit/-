import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:github_flutter/feature/autorized/cubit/auth_cubit.dart';
import 'package:github_flutter/feature/task/repository/task_repository.dart';
import 'package:github_flutter/feature/task/model/cubit/task_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:github_flutter/firebase_options.dart';
import 'package:github_flutter/route/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return MultiBlocProvider(
      providers: [
        // Provider для AuthCubit
        BlocProvider(
          create: (_) => AuthCubit(firebaseAuth: FirebaseAuth.instance),
        ),
        // Provider для TaskRepository
        BlocProvider(
          create: (_) => TaskCubit(
            TaskRepository(firestore: firestore, user: auth.currentUser!),
          ),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.route,
        title: "Firebase Auth Project",
      ),
    );
  }
}
