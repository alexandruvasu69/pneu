import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/login/domain/repositiories/user_repository.dart';

class UpdateUserRole {
  UpdateUserRole(this.repository);

  final UserRepository repository;

  Future<User> call(User user) => repository.updateUserRole(user);
}
