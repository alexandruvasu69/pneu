import 'package:jwt_decode/jwt_decode.dart';
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
        User authUser = AuthModel.fromJson(data);
        final exp = Jwt.parseJwt(authUser.token!)['exp'] as int;
        if (DateTime.now()
            .isAfter(DateTime.fromMillisecondsSinceEpoch(exp * 1000))) {
          data = await remoteSource.refreshToken(authUser.refreshToken!);
        }
        authUser = AuthModel.fromJson(data);
        return authUser;
      } else {
        return GuestModel.fromJson(data);
      }
    } else {
      print("ELSE");
      data = await remoteSource.getOrCreateGuestUser();
    }

    await localSource.saveUser(data);

    print("USER DATA: ${data}");

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
    final Map<String, dynamic> data =
        await remoteSource.register(email, password);
    await localSource.saveUser(data);

    return AuthModel.fromJson(data);
  }

  @override
  Future<User> updateUserRole(User user) async {
    final Map<String, dynamic> data = await remoteSource.getRole(user);
    user.role = data['role'];
    print("USER: ${user.id}, ${user.isGuest}, ${user.token}");

    return user;
  }

  @override
  Future<User> logOut() async {
    await localSource.clearUser();
    return await getUser();
  }
}
