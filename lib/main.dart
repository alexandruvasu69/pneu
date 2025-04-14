import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:pneu/features/map/managers/location_manager.dart';
import 'package:pneu/features/map/managers/map_controller_manager.dart';
import 'package:pneu/features/map/presentation/screens/map_screen.dart';
import 'package:pneu/core/themes/app_theme.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/stores/panel_store.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
// TO-DO: add routing

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  _setup();

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
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      home: const MapScreen(),
    ),
  ));
}

Future<void> _setup() async {
  await dotenv.load(fileName: '.env');

  MapboxOptions.setAccessToken(dotenv.env['MAPBOX_ACCESS_TOKEN']!);
}
