import 'package:docu_ai_app/core/app_styles/app_palette.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppPalette.primaryColor,
      onPrimary: AppPalette.background,
      secondary: AppPalette.secondaryColor,
      onSecondary: AppPalette.background,
      tertiary: AppPalette.successColor,
      onTertiary: AppPalette.background,
      error: AppPalette.errorColor,
      onError: AppPalette.background,
      surface: AppPalette.background,
      onSurface: AppPalette.textPrimary,
      onSurfaceVariant: AppPalette.textSecondary,
      outline: AppPalette.neutral,
      shadow: AppPalette.shadow,
      inverseSurface: AppPalette.primaryColor,
      onInverseSurface: Colors.white,
      inversePrimary: AppPalette.successColor,
    ),
    fontFamily: 'ComicNeue',
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppPalette.primaryColor,
      onPrimary: AppPalette.textPrimary,
      secondary: AppPalette.secondaryColor,
      onSecondary: AppPalette.textPrimary,
      tertiary: AppPalette.successColor,
      onTertiary: AppPalette.textPrimary,
      error: AppPalette.errorColor,
      onError: AppPalette.textPrimary,
      surface: AppPalette.textPrimary,
      onSurface: AppPalette.background,
      onSurfaceVariant: AppPalette.textSecondary,
      outline: AppPalette.neutral,
      shadow: AppPalette.background,
      inverseSurface: AppPalette.primaryColor,
      onInverseSurface: AppPalette.textPrimary,
      inversePrimary: AppPalette.successColor,
    ),
    fontFamily: 'ComicNeue',
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
