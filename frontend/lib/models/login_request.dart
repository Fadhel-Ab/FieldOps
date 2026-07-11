class LoginReqeuest {
  final String email;
  final String password;

  LoginReqeuest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "email":email,
      "passwprd":password,
    };
  }
}