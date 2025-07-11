import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/login/domain/repositiories/user_repository.dart';

class LogOut {
  LogOut(this.repository);

  final UserRepository repository;

  Future<User> call() => repository.logOut();
}
