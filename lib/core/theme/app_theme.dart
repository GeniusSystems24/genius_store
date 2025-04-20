import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Class responsible for app themes
class AppTheme {
  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: const Color(0xFF3F51B5),
      hintColor: const Color(0xFF303F9F),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      fontFamily: 'Roboto',
      textTheme: GoogleFonts.robotoTextTheme(ThemeData.light().textTheme),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF3F51B5),
        primary: const Color(0xFF3F51B5),
        secondary: const Color(0xFFFF4081),
        surface: Colors.white,
        background: const Color(0xFFF5F5F5),
        error: const Color(0xFFB00020),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF212121),
        onBackground: const Color(0xFF212121),
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      buttonTheme: const ButtonThemeData(buttonColor: Color(0xFF3F51B5), textTheme: ButtonTextTheme.primary),
      appBarTheme: const AppBarTheme(color: Color(0xFF3F51B5), foregroundColor: Colors.white, elevation: 0),
      cardTheme: const CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Color(0xFFFF4081), foregroundColor: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Color(0xFFBDBDBD))),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFF3F51B5), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFB00020), width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      ),
    );
  }

  // Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: const Color(0xFF5C6BC0),
      hintColor: const Color(0xFF9FA8DA),
      scaffoldBackgroundColor: const Color(0xFF121212),
      fontFamily: 'Roboto',
      textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF5C6BC0),
        primary: const Color(0xFF5C6BC0),
        secondary: const Color(0xFFFF80AB),
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
        error: const Color(0xFFCF6679),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFFEEEEEE),
        onBackground: const Color(0xFFEEEEEE),
        onError: Colors.black,
        brightness: Brightness.dark,
      ),
      buttonTheme: const ButtonThemeData(buttonColor: Color(0xFF5C6BC0), textTheme: ButtonTextTheme.primary),
      appBarTheme: const AppBarTheme(color: Color(0xFF1E1E1E), foregroundColor: Colors.white, elevation: 0),
      cardTheme: const CardTheme(
        color: Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Color(0xFFFF80AB), foregroundColor: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Color(0xFF424242))),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFF5C6BC0), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        fillColor: const Color(0xFF2C2C2C),
        filled: true,
      ),
    );
  }
}
