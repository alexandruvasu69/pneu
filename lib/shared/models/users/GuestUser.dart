import 'package:pneu/shared/models/users/AppUser.dart';

class GuestUser extends AppUser {
  GuestUser({required super.id, super.username});

  factory GuestUser.fromJson(Map<String, dynamic> json) {
    print("GUEST USER: " + json.toString());

    return GuestUser(
      id: json['id'] as String,
      username: json['username'] as String,
    );
  }

  @override
  bool get isGuest => true;

  @override
  String? get token => null;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{"id": id, "username": username};

  @override
  String get role => 'guest';

  @override
  set role(String r) {}
}
