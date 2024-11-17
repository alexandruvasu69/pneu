import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static TextStyle bodySmall = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 12,
    height: 1,
  );

  static TextStyle bodyMedium = TextStyle(
    color: AppColors.secondaryAccent,
    fontSize: 14,
    height: 1,
  );

  static TextStyle bodyLarge = TextStyle(
    color: AppColors.secondaryAccent,
    fontSize: 18,
    height: 1,
  );

  static TextStyle titleLarge = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1,
  );
}
