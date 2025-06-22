import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/login/domain/repositiories/user_repository.dart';

class Login {
  Login(this.repository);

  final UserRepository repository;

  Future<User> call(String email, String password) => repository.logIn(email, password);
}
