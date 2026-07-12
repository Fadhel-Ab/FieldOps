import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
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
          create: (context) =>
              AuthProvider(authRepository: context.read<AuthRepository>()),
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
        body: Center(
          child: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              return Text(auth.isAuthenticated ? "Logged In" : "Not Logged In");
            },
          ),
        ),
      ),
    );
  }
}
