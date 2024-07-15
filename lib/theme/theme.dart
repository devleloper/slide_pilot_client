import 'package:flutter/material.dart';

ThemeData themeData() {
  final appColors = AppColors();

  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 96.0,
          fontWeight: FontWeight.w300),
      displayMedium: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 60.0,
          fontWeight: FontWeight.w300),
      displaySmall: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 48.0,
          fontWeight: FontWeight.w400),
      headlineMedium: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 34.0,
          fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 24.0,
          fontWeight: FontWeight.w400),
      titleLarge: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 20.0,
          fontWeight: FontWeight.w500),
      titleMedium: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 16.0,
          fontWeight: FontWeight.w400),
      titleSmall: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 14.0,
          fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 16.0,
          fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 14.0,
          fontWeight: FontWeight.w400),
      labelLarge: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 14.0,
          fontWeight: FontWeight.w500),
      bodySmall: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 12.0,
          fontWeight: FontWeight.w400),
      labelSmall: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 10.0,
          fontWeight: FontWeight.w400),
    ),
    primaryColor: appColors.primaryColor,
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      toolbarTextStyle: const TextStyle(
        fontFamily: 'RedHatDisplay',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleTextStyle: const TextStyle(
        fontFamily: 'RedHatDisplay',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      color: appColors.primaryColor,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: appColors.primaryColor,
      secondary: appColors.primaryColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: appColors.primaryColor,
        textStyle: TextStyle(fontFamily: 'RedHatDisplay'),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: appColors.primaryColor,
        textStyle: TextStyle(fontFamily: 'RedHatDisplay'),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: appColors.primaryColor,
        side: BorderSide(color: appColors.primaryColor),
        textStyle: TextStyle(fontFamily: 'RedHatDisplay'),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: appColors.primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: appColors.primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: appColors.primaryColor.withOpacity(0.5)),
      ),
    ),
  );
}

class AppColors {
  final primaryColor = const Color.fromRGBO(92, 107, 192, 1);
}

class AppPresets {
  final neonShadow = const BoxShadow(
    blurRadius: 20,
    color: Color.fromRGBO(92, 107, 192, 0.6),
    offset: Offset(0, 4),
  );

  final whiteShadow = const BoxShadow(
    blurRadius: 20,
    color: Color.fromRGBO(255, 255, 255, 0.4),
    offset: Offset(0, 4),
  );

  final defaultShadow = const BoxShadow(
    blurRadius: 20,
    color: Color.fromRGBO(0, 0, 0, 0.5),
    offset: Offset(0, 4),
  );
}
