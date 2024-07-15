import 'package:flutter/material.dart';

ThemeData themeData() {
  final appColors = AppColors();

  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      // Headline Medium
      headlineMedium: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 24.0,
          letterSpacing: 1,
          fontWeight: FontWeight.w600),

      // BodyMedium
      bodyMedium: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 16.0,
          letterSpacing: 1,
          fontWeight: FontWeight.w600),
      // Body Small
      bodySmall: TextStyle(
          fontFamily: 'RedHatDisplay',
          fontSize: 12.0,
          letterSpacing: 1,
          fontWeight: FontWeight.w600),
    ),
    primaryColor: appColors.primaryColor,
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      toolbarTextStyle: const TextStyle(
        fontFamily: 'RedHatDisplay',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
        color: Colors.white,
      ),
      titleTextStyle: const TextStyle(
        fontFamily: 'RedHatDisplay',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
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
        textStyle: const TextStyle(fontFamily: 'RedHatDisplay'),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: appColors.primaryColor,
        textStyle: const TextStyle(fontFamily: 'RedHatDisplay'),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: appColors.primaryColor,
        side: BorderSide(color: appColors.primaryColor),
        textStyle: const TextStyle(fontFamily: 'RedHatDisplay'),
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
