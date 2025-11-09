import 'package:pneu/shared/models/users/AuthUser.dart';
import 'package:pneu/shared/models/users/GuestUser.dart';

abstract class AppUser {
  AppUser({required this.id, String username = ''}) : _username = username;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('access_token')) {
      return AuthUser.fromJson(json);
    }
    return GuestUser.fromJson(json);
  }

  final String id;
  String _username;

  String get username => _username;

  set username(String username) {
    if (username.length > 3) _username = username;
  }

  bool get isGuest;
  String? get token;
  String get role;
  set role(String r);

  Map<String, dynamic> toJson();
}
