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
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll<Color>(AppColors.secondaryColor),
        constraints: const BoxConstraints(maxWidth: double.infinity, maxHeight: double.infinity),
        shape: WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Schimbă aici borderRadius
          ),
        ),
        shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
        textStyle: WidgetStatePropertyAll<TextStyle>(AppTextStyles.bodyLarge),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.all(0)),
        hintStyle: WidgetStatePropertyAll<TextStyle>(AppTextStyles.bodyLarge),
      ));
}
