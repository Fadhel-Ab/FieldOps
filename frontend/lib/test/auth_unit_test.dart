import 'package:flutter_test/flutter_test.dart';
import '../models/login_request.dart';
import '../services/auth_service.dart';
import 'package:dio/dio.dart';

void main() {
  test('Verify login API returns a valid token', () async {
    final authService = AuthService();

    try {
      final response = await authService.login(
        LoginRequest(email: "employee@test.com", password: "123456"),
      );

      print('✅ Token received: ${response.token}');

      expect(response.token, isNotNull);
      expect(response.token, isNotEmpty);
    } on DioException catch (e) {
      print(
        '❌ Server rejected the request with status: ${e.response?.statusCode}',
      );

      print('📄 Server Response Body: ${e.response?.data}');

      fail('Login failed with 401');
    } catch (e) {
      fail('The login request threw an exception: $e');
    }
  });
}
