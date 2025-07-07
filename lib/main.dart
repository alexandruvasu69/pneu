import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
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
import 'package:pneu/features/map/data/datasources/events_supabase_datasource.dart';
import 'package:pneu/features/map/data/datasources/location_mapbox_geocoding_data_source.dart';
import 'package:pneu/features/map/data/datasources/routes_supabase_datasource.dart';
import 'package:pneu/features/map/data/datasources/saved_locations_supabase_datasource.dart';
import 'package:pneu/features/map/data/models/sliding_panel_controller.dart';
import 'package:pneu/features/map/data/repositories/events_repository_impl.dart';
import 'package:pneu/features/map/data/repositories/location_repository_impl.dart';
import 'package:pneu/features/map/data/repositories/route_repository_impl.dart';
import 'package:pneu/features/map/data/repositories/saved_location_repository_impl.dart';
import 'package:pneu/features/map/domain/repositories/events_repository.dart';
import 'package:pneu/features/map/domain/repositories/location_repository.dart';
import 'package:pneu/features/map/domain/repositories/route_repository.dart';
import 'package:pneu/features/map/domain/repositories/saved_location_repository.dart';
import 'package:pneu/features/map/domain/usecases/add_event.dart';
import 'package:pneu/features/map/domain/usecases/delete_saved_location.dart';
import 'package:pneu/features/map/domain/usecases/get_calculated_routes.dart';
import 'package:pneu/features/map/domain/usecases/get_events_for_bounds.dart';
import 'package:pneu/features/map/domain/usecases/get_location.dart';
import 'package:pneu/features/map/domain/usecases/get_saved_locations.dart';
import 'package:pneu/features/map/domain/usecases/save_location.dart';
import 'package:pneu/features/map/presentation/map_screen.dart';
import 'package:pneu/core/themes/app_theme.dart';
import 'package:pneu/features/map/presentation/stores/events_store.dart';
import 'package:pneu/features/map/presentation/stores/location_popup_store.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/stores/modal_store.dart';
import 'package:pneu/features/map/presentation/stores/panel_store.dart';
import 'package:pneu/features/map/presentation/stores/position_store.dart';
import 'package:pneu/features/map/presentation/stores/route_store.dart';
import 'package:pneu/features/map/presentation/stores/saved_locations_store.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _setup();

  final modalStore = ModalStore();

  final SavedLocationsStore savedLocationsStore =
      initSavedLocationsStore(modalStore);

  final userNotifier = initUserNotifier(savedLocationsStore);
  await userNotifier.loadInitialUser();

  LocationMapboxGeocodingDataSource locationSource =
      LocationMapboxGeocodingDataSource();
  LocationRepository locationRepository =
      LocationRepositoryImpl(locationSource);
  GetLocation getLocation = GetLocation(locationRepository);

  RouteRepository routeRepository =
      RouteRepositoryImpl(RoutesSupabaseDatasource());
  GetCalculatedRoutes getRoutes = GetCalculatedRoutes(routeRepository);

  final routeStore = RouteStore(getRoutes: getRoutes, modalStore: modalStore);
  final locationPopupStore = LocationPopupStore(getLocation: getLocation);
  final positionStore = PositionStore();
  final mapStore = MapStore(
      locationPopupStore: locationPopupStore,
      routeStore: routeStore,
      positionStore: positionStore);
  final panelStore = PanelStore();
  panelStore.initController(SlidingPanelController(PanelController()));

  final eventsStore = initEventsStore();

  runApp(MultiProvider(
    providers: <SingleChildWidget>[
      ChangeNotifierProvider<ModalStore>.value(value: modalStore),
      ChangeNotifierProvider<LocationPopupStore>.value(
          value: locationPopupStore),
      ChangeNotifierProvider<MapStore>.value(value: mapStore),
      ChangeNotifierProvider<PanelStore>.value(value: panelStore),
      ChangeNotifierProvider<UserNotifier>.value(value: userNotifier),
      ChangeNotifierProvider<PositionStore>.value(value: positionStore),
      ChangeNotifierProvider<RouteStore>.value(value: routeStore),
      ChangeNotifierProvider<SavedLocationsStore>.value(
          value: savedLocationsStore),
      ChangeNotifierProvider<EventsStore>.value(value: eventsStore),
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

EventsStore initEventsStore() {
  EventsSupabaseDatasource datasource = EventsSupabaseDatasource();
  EventsRepository eventsRepository = EventsRepositoryImpl(datasource);
  GetEventsForBounds getEventsForBounds = GetEventsForBounds(eventsRepository);
  AddEvent addEvent = AddEvent(eventsRepository);
  return EventsStore(
      getEventsForBounds: getEventsForBounds, addEvent: addEvent);
}

SavedLocationsStore initSavedLocationsStore(ModalStore modalStore) {
  SavedLocationsSupabaseDatasource datasource =
      SavedLocationsSupabaseDatasource();
  SavedLocationRepository repository = SavedLocationRepositoryImpl(datasource);
  GetSavedLocations getSavedLocations = GetSavedLocations(repository);
  SaveLocation saveLocation = SaveLocation(repository);
  DeleteSavedLocation deleteSavedLocation = DeleteSavedLocation(repository);

  return SavedLocationsStore(
    getSavedLocations: getSavedLocations,
    saveLocation: saveLocation,
    deleteSavedLocation: deleteSavedLocation,
    modalStore: modalStore,
  );
}

UserNotifier initUserNotifier(SavedLocationsStore savedLocationsStore) {
  UserSupabaseDataSource remoteSource = UserSupabaseDataSource();
  UserSharedPrefDataSource localSource = UserSharedPrefDataSource();
  UserRepository repository = UserRepositoryImpl(remoteSource, localSource);
  GetUser getUser = GetUser(repository);
  Login login = Login(repository);
  Register register = Register(repository);

  return UserNotifier(
      getUser: getUser,
      login: login,
      register: register,
      savedLocationsStore: savedLocationsStore);
}
