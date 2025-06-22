import 'package:pneu/shared/models/users/AuthUser.dart';
import 'package:pneu/shared/models/users/GuestUser.dart';

abstract class AppUser {
  AppUser({required this.id, String username = ''}) : _username = username;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    // Dacă există un access_token în JSON => e cont autenticat
    if (json.containsKey('access_token')) {
      return AuthUser.fromJson(json);
    }
    // Altfel, dacă există doar id/username => e guest
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
