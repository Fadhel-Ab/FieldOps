import '../models/login_request.dart';
import '../models/login_response.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({required this._authService});

  Future<LoginResponse> login(LoginRequest request) async {
    return _authService.login(request);
  }
}
