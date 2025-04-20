/// Application-wide constants
class AppConstants {
  // Routes
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String productDetailsRoute = '/product';
  static const String cartRoute = '/cart';
  static const String checkoutRoute = '/checkout';
  static const String profileRoute = '/profile';

  // Asset paths
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderImagePath = 'assets/images/placeholder.png';

  // Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultIconSize = 24.0;

  // Firebase collections
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String categoriesCollection = 'categories';
  static const String cartsCollection = 'carts';
  static const String ordersCollection = 'orders';

  // SharedPreferences keys
  static const String tokenKey = 'token';
  static const String userIdKey = 'userId';
  static const String themeKey = 'theme';
  static const String localeKey = 'locale';

  // API status codes
  static const int successCode = 200;
  static const int unauthorizedCode = 401;
  static const int notFoundCode = 404;
  static const int serverErrorCode = 500;
}
