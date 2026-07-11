import 'package:flutter/material.dart';
import '../models/login_request.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider({required this._authRepository});

  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(LoginRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.login(request);
      _isAuthenticated = true;
      return true;
    } catch (e) {
      _errorMessage="Login failed"; 
      return false;
    }finally{
      _isLoading=false;
      notifyListeners();
    }
  }
}
