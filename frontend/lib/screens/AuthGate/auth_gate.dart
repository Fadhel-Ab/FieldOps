import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/login/login_screen.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AuthProvider>().checkLoginStatus();
    });
  }

  @override
Widget build(BuildContext context) {
 final authProvider = context.watch<AuthProvider>();

debugPrint(
  "AuthGate instance: ${authProvider.hashCode}",
);

debugPrint(
  "AuthGate state: ${authProvider.isAuthenticated}",
);

  if (authProvider.isCheckingAuth) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  if (authProvider.isAuthenticated) {
    return const HomeScreen();
  }

  return const LoginScreen();
}
}
