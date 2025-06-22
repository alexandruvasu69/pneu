import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:pneu/features/login/data/datasources/user_shared_pref_data_source.dart';
import 'package:pneu/features/login/data/datasources/user_supabase_data_source.dart';
import 'package:pneu/features/login/data/repositories/user_repository_impl.dart';
import 'package:pneu/features/login/domain/repositiories/user_repository.dart';
import 'package:pneu/features/login/domain/usecases/get_user.dart';
import 'package:pneu/features/login/domain/usecases/login.dart';
import 'package:pneu/features/login/domain/usecases/register.dart';
import 'package:pneu/features/login/presentation/login_screen.dart';
import 'package:pneu/features/login/presentation/notifiers/user_notifier.dart';
import 'package:pneu/features/login/presentation/signup_screen.dart';
import 'package:pneu/features/map/managers/location_manager.dart';
import 'package:pneu/features/map/managers/map_controller_manager.dart';
import 'package:pneu/features/map/presentation/screens/map_screen.dart';
import 'package:pneu/core/themes/app_theme.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/stores/panel_store.dart';
import 'package:pneu/shared/stores/user_store.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
// TO-DO: add routing

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _setup();
  UserSupabaseDataSource remoteSource = UserSupabaseDataSource();
  UserSharedPrefDataSource localSource = UserSharedPrefDataSource();
  UserRepository repository = UserRepositoryImpl(remoteSource, localSource);
  GetUser getUser = GetUser(repository);
  Login login = Login(repository);
  Register register = Register(repository);

  final userNotifier = UserNotifier(getUser: getUser, login: login, register: register);
  await userNotifier.loadInitialUser();

  runApp(MultiProvider(
    providers: <SingleChildWidget>[
      ChangeNotifierProvider<MapStore>(create: (_) => MapStore()),
      ProxyProvider<MapStore, LocationManager>(
        update: (_, MapStore mapStore, __) => LocationManager(mapStore),
      ),
      ProxyProvider<MapStore, MapControllerManager>(
        update: (_, MapStore mapStore, __) => MapControllerManager(mapStore),
      ),
      ChangeNotifierProvider<PanelStore>(create: (_) => PanelStore()),
      ChangeNotifierProvider<UserNotifier>.value(value: userNotifier),
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      home: const MapScreen(),
      routes: {
        SignupScreen.routeName: (_) => const SignupScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
      },
    ),
  ));
}

Future<void> _setup() async {
  await dotenv.load(fileName: '.env');

  MapboxOptions.setAccessToken(dotenv.env['MAPBOX_ACCESS_TOKEN']!);
}
