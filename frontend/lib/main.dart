import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/task_provider.dart';
import 'package:frontend/repositories/task_repository.dart';
import 'package:frontend/screens/AuthGate/auth_gate.dart';
import 'package:frontend/services/camera_service.dart';
import 'package:frontend/services/location_service.dart';
import 'package:frontend/services/task_service.dart';
import 'services/auth_service.dart';
import 'models/login_request.dart';
import 'package:provider/provider.dart';
import 'repositories/auth_repository.dart';
import 'core/storage/secure_storage_service.dart';
import 'screens/login/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<SecureStorageService>(create: (_) => SecureStorageService()),
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            authService: context.read<AuthService>(),
            secureStorageService: context.read<SecureStorageService>(),
          ),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            authRepository: context.read<AuthRepository>(),
            secureStorageService: context.read<SecureStorageService>(),
          ),
        ),
        Provider<TaskService>(create: (_) => TaskService()),
        Provider<TaskRepository>(
          create: (context) =>
              TaskRepository(taskService: context.read<TaskService>()),
        ),

        ChangeNotifierProxyProvider<AuthProvider, TaskProvider>(
          create: (context) =>
              TaskProvider(taskRepository: context.read<TaskRepository>()),
          update: (context, auth, taskProvider) {
            if (auth.token != null) {
              taskProvider!.fetchTasks(auth.token!);
            }
            return taskProvider!;
          },
        ),
        Provider(
      create: (_) => LocationService(),
    ),

    Provider(
      create: (_) => CameraService(),
    ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("FieldOps")),
        body: Center(child: AuthGate()),
      ),
    );
  }
}
