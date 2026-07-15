class LoginResponse {
  final String token;
  final String username;
  final String? refreshToken; // for later

  LoginResponse({
    required this.token,
    this.refreshToken,
    required this.username,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      refreshToken: json['refreshToken'],
      username: json["username"],
    );
  }
}
