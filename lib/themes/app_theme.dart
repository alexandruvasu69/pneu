import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'SF Pro Display',
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryAccent),
    scaffoldBackgroundColor: AppColors.primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.secondaryAccent,
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodySmall: AppTextStyles.bodySmall,
      bodyMedium: AppTextStyles.bodyMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      titleLarge: AppTextStyles.titleLarge,
    ),
  );
}
