import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/storage/secure_storage_service.dart';
import '../models/login_request.dart';
import '../repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorageService;

  AuthProvider({
    required AuthRepository authRepository,
    required SecureStorageService secureStorageService,
  }) : _authRepository = authRepository,
       _secureStorageService = secureStorageService;

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
      notifyListeners();
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

  Future<bool> checkLoginStatus() async {
    final token = await _authRepository.autoLogin();
    if (token != null) {
      _token = token;
      _isAuthenticated=true;
      notifyListeners();
      return true;
    }
    return false;
  }

Future<void> signOut() async {
  await _authRepository.logout();

  _token = null;
  _isAuthenticated = false;

  notifyListeners();
}
}
