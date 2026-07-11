import '../models/login_request.dart';
import '../models/login_response.dart';
import '../services/auth_service.dart';
import '../core/storage/secure_storage_service.dart';

class AuthRepository {
  final AuthService _authService;
  final SecureStorageService _secureStorageService;

  AuthRepository({
    required this._authService,
    required this._secureStorageService,
  });

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _authService.login(request);
    await _secureStorageService.saveToken(response.token);
    return response;
  }
  Future<String?> getToken() {
  return _secureStorageService.getToken();
}

Future<void> logout() {
  return _secureStorageService.deleteToken();
}
}
