class RegisterResponse {
  final bool success;
  final String message;
  final User user;
  final String token;
  final String refreshToken;

  RegisterResponse({
    required this.success,
    required this.message,
    required this.user,
    required this.token,
    required this.refreshToken,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'],
      message: json['message'],
      user: User.fromJson(json['data']['user'] ?? {}),
      token: json['data']['token'],
      refreshToken: json['data']['refreshToken'],
    );
  }
}

class User {
  
  User();

  factory User.fromJson(Map<String, dynamic> json) {
    return User();
  }
}
