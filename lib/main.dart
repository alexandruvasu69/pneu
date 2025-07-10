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
import 'package:pneu/features/login/presentation/account_screen.dart';
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
import 'package:pneu/features/map/domain/usecases/retrieve_location.dart';
import 'package:pneu/features/map/domain/usecases/save_location.dart';
import 'package:pneu/features/map/domain/usecases/suggest_location.dart';
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
import 'package:pneu/features/map/presentation/stores/search_store.dart';
import 'package:pneu/features/search/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _setup();

  final modalStore = ModalStore();
  final SavedLocationsStore savedLocationsStore =
      initSavedLocationsStore(modalStore);
  final userNotifier = await initUserNotifier(savedLocationsStore);
  final routeStore = initRouteStore(modalStore);
  final locationPopupStore = initLocationPopupStore();
  final positionStore = PositionStore();
  final panelStore = initPanelStore();
  final mapStore =
      initMapStore(locationPopupStore, routeStore, positionStore, panelStore);

  final eventsStore = initEventsStore();
  final searchStore = initSearchStore();

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
      ChangeNotifierProvider<SearchStore>.value(value: searchStore),
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      home: const MapScreen(),
      routes: {
        SignupScreen.routeName: (_) => const SignupScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        SearchScreen.routeName: (_) => const SearchScreen(),
        AccountScreen.routeName: (_) => const AccountScreen(),
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

Future<UserNotifier> initUserNotifier(
    SavedLocationsStore savedLocationsStore) async {
  UserSupabaseDataSource remoteSource = UserSupabaseDataSource();
  UserSharedPrefDataSource localSource = UserSharedPrefDataSource();
  UserRepository repository = UserRepositoryImpl(remoteSource, localSource);
  GetUser getUser = GetUser(repository);
  Login login = Login(repository);
  Register register = Register(repository);

  UserNotifier userNotifier = UserNotifier(
      getUser: getUser,
      login: login,
      register: register,
      savedLocationsStore: savedLocationsStore);

  await userNotifier.loadInitialUser();
  return userNotifier;
}

SearchStore initSearchStore() {
  LocationMapboxGeocodingDataSource source =
      LocationMapboxGeocodingDataSource();
  LocationRepository repository = LocationRepositoryImpl(source);
  SuggestLocation suggestLocation = SuggestLocation(repository);
  RetrieveLocation retrieveLocation = RetrieveLocation(repository);
  return SearchStore(
      suggestLocation: suggestLocation, retrieveLocation: retrieveLocation);
}

LocationPopupStore initLocationPopupStore() {
  LocationMapboxGeocodingDataSource locationSource =
      LocationMapboxGeocodingDataSource();
  LocationRepository locationRepository =
      LocationRepositoryImpl(locationSource);
  GetLocation getLocation = GetLocation(locationRepository);

  return LocationPopupStore(getLocation: getLocation);
}

RouteStore initRouteStore(ModalStore modalStore) {
  RouteRepository routeRepository =
      RouteRepositoryImpl(RoutesSupabaseDatasource());
  GetCalculatedRoutes getRoutes = GetCalculatedRoutes(routeRepository);

  return RouteStore(getRoutes: getRoutes, modalStore: modalStore);
}

MapStore initMapStore(LocationPopupStore locationPopupStore,
    RouteStore routeStore, PositionStore positionStore, PanelStore panelStore) {
  return MapStore(
    locationPopupStore: locationPopupStore,
    routeStore: routeStore,
    positionStore: positionStore,
    panelStore: panelStore,
  );
}

PanelStore initPanelStore() {
  PanelStore panelStore = PanelStore();
  panelStore.initController(SlidingPanelController(PanelController()));

  return panelStore;
}
