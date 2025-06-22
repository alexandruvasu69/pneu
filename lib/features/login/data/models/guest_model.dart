import 'package:pneu/features/login/domain/entities/user.dart';

class GuestModel extends GuestUser {
  GuestModel({required super.id, super.username});

  factory GuestModel.fromJson(Map<String, dynamic> json) {
    return GuestModel(
      id: json['user_id'] as String,
      username: json['username'] as String,
    );
  }
}
