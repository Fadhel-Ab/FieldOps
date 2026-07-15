import '../models/login_request.dart';
import '../models/login_response.dart';
import '../services/auth_service.dart';
import '../core/storage/secure_storage_service.dart';

class AuthRepository {
  final AuthService _authService;
  final SecureStorageService _secureStorageService;

  AuthRepository({
    required AuthService authService,
    required SecureStorageService secureStorageService,
  }) : _authService = authService,
       _secureStorageService = secureStorageService;

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _authService.login(request);
    await _secureStorageService.saveToken(response.token);
    return response;
  }

  Future<String?> autoLogin() async {
    final token = await _secureStorageService.getToken();
    if (token == null) return null;
    final isValid = await _authService.validateToken(token);

    if (!isValid) {
      await _secureStorageService.deleteToken();
      return null;
    }
    return token;
  }

  Future<void> logout(String token) async {
    await _authService.logout(token);

    await _secureStorageService.deleteToken();
  }
}
