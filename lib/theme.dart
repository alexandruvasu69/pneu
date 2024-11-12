import 'package:flutter/material.dart';

class AppColors {
  // app colors
  static Color primaryColor = const Color.fromRGBO(255, 255, 255, 1);
  static Color secondaryColor = const Color.fromRGBO(237, 239, 241, 1);
  static Color primaryAccent = const Color.fromRGBO(138, 89, 222, 1);
  static Color secondaryAccent = const Color.fromRGBO(84, 69, 130, 1);

  // miscellaneous colors
  static Color parkingFound = const Color.fromRGBO(237, 239, 241, 0.9);
  static Color routeColor = const Color.fromRGBO(237, 239, 241, 0.6);
}

ThemeData primaryTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: AppColors.secondaryAccent,
      fontSize: 12,
    ),
    bodyMedium: TextStyle(color: AppColors.secondaryAccent, fontSize: 14),
    bodyLarge: TextStyle(
      color: AppColors.secondaryAccent,
      fontSize: 18,
    ),
    titleLarge: TextStyle(
      color: AppColors.primaryColor,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  ),
);
