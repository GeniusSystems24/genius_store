import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = "Genius Store";
  static const String appVersion = "1.0.0";

  // API Endpoints for Firebase
  static const String apiBaseUrl = "https://genius-store.firebaseapp.com";

  // Available locales
  static const List<Locale> supportedLocales = [Locale('en', 'US'), Locale('ar', 'SA')];

  // Default app settings
  static const Locale defaultLocale = Locale('en', 'US');
  static const ThemeMode defaultThemeMode = ThemeMode.system;

  // Firebase configuration
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;

  // Pagination defaults
  static const int defaultPageSize = 20;

  // Cache configuration
  static const Duration cacheTimeout = Duration(minutes: 30);
}
