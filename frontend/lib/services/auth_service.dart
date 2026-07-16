import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../core/constants/api_constants.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {"Content-Type": "application/json"},
    ),
  );

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: request.toJson(),
    );
    debugPrint(response.data.toString());

    return LoginResponse.fromJson(response.data);
  }

  Future<bool> validateToken(String token) async {
    try {
      final response = await _dio.get(
        ApiConstants.tasks,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.statusCode == 200;
    } on DioException {
      return false;
    }
  }

  Future<void> logout(String token) async {
    debugPrint("Sending logout token:");
    debugPrint(token);

    await _dio.post(
      ApiConstants.logout,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
