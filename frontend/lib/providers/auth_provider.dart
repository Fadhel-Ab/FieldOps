import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/login_request.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider({required this._authRepository});

  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  String? _token;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  Future<bool> login(LoginRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepository.login(request);
      _token = response.token;
      _isAuthenticated = true;
      return true;
    } catch (e) {
      if (e is DioException) {
        _errorMessage = e.response?.data["message"] ?? "Login failed";
      } else {
        _errorMessage = "Unexpected error occurred";
      }

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> checkLoginStatus() async {
  final savedToken = await _authRepository.getToken();

  if (savedToken != null) {
    _token = savedToken;
    _isAuthenticated = true;
  }

  notifyListeners();
}
}
