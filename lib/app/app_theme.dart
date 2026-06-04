import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFFEF6C00);
  static const primaryLight = Color(0xFFFFB74D);
  static const warmSurface = Color(0xFFFFE0B2);
  static const warmSurfaceAlt = Color(0xFFFFCC80);
  static const brown = Color(0xFF8D6E63);
  static const darkBrown = Color(0xFF3E2723);
}

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    );

    return ThemeData(
      colorScheme: colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: const Color(0xFFFFFBF7),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFFBF7),
      useMaterial3: true,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
