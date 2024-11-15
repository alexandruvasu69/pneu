// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pneu/features/map/presentation/screens/map_screen.dart';

import 'package:pneu/main.dart';

void main() {
  testWidgets('MapScreen is displayed on app launch', (WidgetTester tester) async {
    // Construiește aplicația și declanșează un cadru.
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData.light(),
      home: const MapScreen(),
    ));

    // Verifică dacă Scaffold-ul este afișat (MapScreen folosește un Scaffold).
    expect(find.byType(Scaffold), findsOneWidget);

    // Verifică dacă MapScreen este afișat corect.
    expect(find.byType(MapScreen), findsOneWidget);
  });
}
