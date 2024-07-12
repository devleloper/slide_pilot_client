import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeData() {
  final appColors = AppColors();

  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.redHatDisplayTextTheme(),
    primaryColor: appColors.primaryColor,
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      toolbarTextStyle: GoogleFonts.redHatDisplay(
        textStyle: GoogleFonts.redHatDisplay(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      titleTextStyle: GoogleFonts.redHatDisplay(
        textStyle: GoogleFonts.redHatDisplay(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
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
        textStyle: GoogleFonts.redHatDisplay(),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: appColors.primaryColor,
        textStyle: GoogleFonts.redHatDisplay(),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: appColors.primaryColor,
        side: BorderSide(color: appColors.primaryColor),
        textStyle: GoogleFonts.redHatDisplay(),
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
    color: Color.fromRGBO(255, 255, 255, 0.6),
    offset: Offset(0, 4),
  );

  final defaultShadow = const BoxShadow(
    blurRadius: 20,
    color: Color.fromRGBO(0, 0, 0, 0.5),
    offset: Offset(0, 4),
  );
}
