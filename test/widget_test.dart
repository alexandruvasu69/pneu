// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pneu/features/map/managers/location_manager.dart';
import 'package:pneu/features/map/managers/map_controller_manager.dart';
import 'package:pneu/features/map/presentation/screens/map_screen.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/stores/panel_store.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() {
  testWidgets('MapScreen is displayed on app launch', (WidgetTester tester) async {
    // Construiește aplicația și declanșează un cadru.
    await tester.pumpWidget(
      MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<MapStore>(create: (_) => MapStore()),
          ProxyProvider<MapStore, LocationManager>(
            update: (_, mapStore, __) => LocationManager(mapStore),
          ),
          ProxyProvider<MapStore, MapControllerManager>(
            update: (_, mapStore, __) => MapControllerManager(mapStore),
          ),
          ChangeNotifierProvider<PanelStore>(create: (_) => PanelStore()),
        ],
        child: const MaterialApp(
          home: MapScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verifică dacă Scaffold-ul este afișat (MapScreen folosește un Scaffold).
    expect(find.byType(Scaffold), findsWidgets);
  });
}
