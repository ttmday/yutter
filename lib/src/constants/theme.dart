import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yutter/src/constants/color.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData getTheme() {
    return ThemeData(
      fontFamily: 'GeneralSans',
      primaryColor: AppColors.primary,
      useMaterial3: true,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.text,
        selectionColor: AppColors.background,
        selectionHandleColor: AppColors.foreground,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.foreground,
        surfaceTintColor: AppColors.foreground,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.foreground,
          systemNavigationBarColor: AppColors.foreground,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      scaffoldBackgroundColor: AppColors.foreground,
      iconTheme: const IconThemeData(color: AppColors.background, size: 21.0),
      hintColor: AppColors.field,
      cardColor: AppColors.field,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'GeneralSans',
          fontSize: 26.0,
          color: AppColors.text,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: TextStyle(
          fontSize: 24.0,
          color: AppColors.text,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          fontSize: 20.0,
          color: AppColors.text,
          fontWeight: FontWeight.w500,
        ),
        headlineSmall: TextStyle(
          fontSize: 18.0,
          color: AppColors.text,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'GeneralSans',
          fontSize: 16.0,
          color: AppColors.text,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'GeneralSans',
          fontSize: 14.0,
          color: AppColors.text,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          fontFamily: 'GeneralSans',
          fontSize: 12.0,
          color: AppColors.text,
          fontWeight: FontWeight.w400,
        ),
      ),
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.light(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.background,
        tertiary: AppColors.foreground,
        outline: AppColors.background,
      ),
    );
  }
}
