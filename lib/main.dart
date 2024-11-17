import 'package:flutter/material.dart';
import 'package:pneu/features/map/presentation/screens/map_screen.dart';
import 'package:pneu/core/themes/app_theme.dart';

// TO-DO: add routing

void main() {
  runApp(MaterialApp(
    theme: AppTheme.lightTheme,
    home: const MapScreen(),
  ));
}
