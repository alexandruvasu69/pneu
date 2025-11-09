abstract class User {
  User({required this.id, String username = ''}) : _username = username;

  final String id;
  String _username;

  String get username => _username;

  set username(String username) {
    if (username.length > 3) _username = username;
  }

  bool get isGuest;
  String? get token;
  String? get refreshToken;
  String get role;
  set role(String r);

  Map<String, dynamic> toJson();
}

class AuthUser extends User {
  AuthUser(
      {required super.id,
      required this.email,
      required this.accessToken,
      required this.refreshToken})
      : role = 'auth';

  final String email;
  final String accessToken;
  final String refreshToken;
  @override
  String role;

  @override
  bool get isGuest => false;

  @override
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

class GuestUser extends User {
  GuestUser({required super.id, super.username});

  @override
  bool get isGuest => true;

  @override
  String? get token => null;

  @override
  String get role => 'guest';

  @override
  set role(String r) {}

  @override
  Map<String, dynamic> toJson() =>
      <String, dynamic>{"id": id, "username": username};

  @override
  String? get refreshToken => null;
}
