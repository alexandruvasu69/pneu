import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/login/domain/repositiories/user_repository.dart';

class Register {
  Register(this.repository);

  final UserRepository repository;

  Future<User> call(String email, String password) => repository.register(email, password);
}
