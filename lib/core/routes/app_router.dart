import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Class responsible for managing application routes
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Get route name and arguments
    final name = settings.name;
    final args = settings.arguments;

    // Using switch statement to return the appropriate page route
    switch (name) {
      case AppConstants.homeRoute:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Home Screen - To be implemented'))));

      case AppConstants.loginRoute:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Login Screen - To be implemented'))));

      case AppConstants.registerRoute:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Register Screen - To be implemented'))));

      case AppConstants.productDetailsRoute:
        // Check if we have the required parameter
        if (args is String) {
          return MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('Product Details for ID: $args'))));
        }
        return _errorRoute('Product ID is required');

      case AppConstants.cartRoute:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Cart Screen - To be implemented'))));

      case AppConstants.checkoutRoute:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Checkout Screen - To be implemented'))));

      case AppConstants.profileRoute:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Profile Screen - To be implemented'))));

      default:
        return _errorRoute('Route not found');
    }
  }

  // Default error route
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(appBar: AppBar(title: const Text('Error')), body: Center(child: Text('Navigation Error: $message')));
      },
    );
  }

  // Navigation methods
  static void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndRemove(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (Route<dynamic> route) => false, arguments: arguments);
  }

  static void navigateAndReplace(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
