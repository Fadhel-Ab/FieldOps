import 'package:dio/dio.dart';

import '../core/api_constants.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthService {
  final Dio _dio= Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
         "Content-Type": "application/json",
      },
    )
  );


  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: request.toJson(),
    );

    return LoginResponse.fromJson(response.data);
  }
}