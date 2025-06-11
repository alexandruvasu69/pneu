import 'package:pneu/shared/models/users/AppUser.dart';

class AuthUser extends AppUser {
  AuthUser({required super.id, required this.email, required this.accessToken, required this.refreshToken})
      : role = 'auth';

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['user']['id'] as String,
      email: json['user']['email'] as String,
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }

  final String email;
  final String accessToken;
  final String refreshToken;
  @override
  String role;

  @override
  bool get isGuest => false;

  @override
  // TODO: implement token
  String? get token => accessToken;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "email": email,
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "username": username
      };
}
