import 'package:pneu/features/login/domain/entities/user.dart';

class AuthModel extends AuthUser {
  AuthModel({required super.id, required super.email, required super.accessToken, required super.refreshToken});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['user']['id'] as String,
      email: json['user']['email'] as String,
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }
}
