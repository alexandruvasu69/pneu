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
import 'package:pneu/features/map/data/datasources/location_mapbox_geocoding_data_source.dart';
import 'package:pneu/features/map/data/repositories/location_repository_impl.dart';
import 'package:pneu/features/map/domain/repositories/location_repository.dart';
import 'package:pneu/features/map/domain/usecases/get_location.dart';
import 'package:pneu/features/map/presentation/map_screen.dart';
import 'package:pneu/core/themes/app_theme.dart';
import 'package:pneu/features/map/presentation/stores/location_popup_store.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/stores/panel_store.dart';
import 'package:pneu/features/map/presentation/stores/position_store.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _setup();
  UserSupabaseDataSource remoteSource = UserSupabaseDataSource();
  UserSharedPrefDataSource localSource = UserSharedPrefDataSource();
  UserRepository repository = UserRepositoryImpl(remoteSource, localSource);
  GetUser getUser = GetUser(repository);
  Login login = Login(repository);
  Register register = Register(repository);

  final userNotifier =
      UserNotifier(getUser: getUser, login: login, register: register);
  await userNotifier.loadInitialUser();

  LocationMapboxGeocodingDataSource locationSource =
      LocationMapboxGeocodingDataSource();
  LocationRepository locationRepository =
      LocationRepositoryImpl(locationSource);
  GetLocation getLocation = GetLocation(locationRepository);

  final locationPopupStore = LocationPopupStore(getLocation: getLocation);
  final mapStore = MapStore(locationPopupStore: locationPopupStore);
  final positionStore = PositionStore(mapStore: mapStore);

  runApp(MultiProvider(
    providers: <SingleChildWidget>[
      ChangeNotifierProvider<LocationPopupStore>.value(
          value: locationPopupStore),
      ChangeNotifierProvider<MapStore>.value(value: mapStore),
      ChangeNotifierProvider<PanelStore>(create: (_) => PanelStore()),
      ChangeNotifierProvider<UserNotifier>.value(value: userNotifier),
      ChangeNotifierProvider<PositionStore>.value(
        value: positionStore,
      )
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
