import 'package:pneu/features/login/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> getUser();
  Future<User> logIn(String email, String password);
  Future<User> register(String email, String password);
}
