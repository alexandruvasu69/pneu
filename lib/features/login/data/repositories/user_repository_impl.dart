import 'package:pneu/features/login/data/datasources/user_shared_pref_data_source.dart';
import 'package:pneu/features/login/data/datasources/user_supabase_data_source.dart';
import 'package:pneu/features/login/data/models/auth_model.dart';
import 'package:pneu/features/login/data/models/guest_model.dart';
import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/login/domain/repositiories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this.remoteSource, this.localSource);

  final UserSupabaseDataSource remoteSource;
  final UserSharedPrefDataSource localSource;

  @override
  Future<User> getUser() async {
    Map<String, dynamic>? data = await localSource.getUser();

    if (data != null) {
      if (data.containsKey('access_token')) {
        return AuthModel.fromJson(data);
      } else {
        return GuestModel.fromJson(data);
      }
    } else {
      data = await remoteSource.getOrCreateGuestUser();
    }

    await localSource.saveUser(data);

    return GuestModel.fromJson(data);
  }

  @override
  Future<User> logIn(String email, String password) async {
    final Map<String, dynamic> data = await remoteSource.logIn(email, password);
    await localSource.saveUser(data);

    return AuthModel.fromJson(data);
  }

  @override
  Future<User> register(String email, String password) async {
    final Map<String, dynamic> data = await remoteSource.register(email, password);
    await localSource.saveUser(data);

    return AuthModel.fromJson(data);
  }
}
