import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';

// Screen imports
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/product/product_details_screen.dart';
import '../../presentation/screens/cart/cart_screen.dart';
import '../../presentation/screens/checkout/checkout_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';

/// Provider for the app router
final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.router;
});

/// Class responsible for managing application routes
class AppRouter {
  /// The main router instance
  static final router = GoRouter(
    initialLocation: AppConstants.homeRoute,
    debugLogDiagnostics: true,
    routes: [
      // Shell route for main layout (e.g., with bottom navigation)
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _calculateSelectedIndex(state),
              onTap: (index) => _onItemTapped(index, context),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
        routes: [
          // Home route
          GoRoute(
            path: AppConstants.homeRoute,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),

          // Cart route
          GoRoute(
            path: AppConstants.cartRoute,
            name: 'cart',
            builder: (context, state) => const CartScreen(),
            routes: [
              GoRoute(
                path: 'checkout',
                name: 'checkout',
                builder: (context, state) => const CheckoutScreen(),
              ),
            ],
          ),

          // User account routes
          GoRoute(
            path: AppConstants.profileRoute,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      // Auth routes group (outside the shell)
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'forgot-password',
            name: 'forgotPassword',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
        ],
      ),

      GoRoute(
        path: AppConstants.registerRoute,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Product routes (outside the shell)
      GoRoute(
        path: AppConstants.productDetailsRoute,
        name: 'product',
        builder: (context, state) => const SizedBox.shrink(), // This is just a placeholder
        routes: [
          GoRoute(
            path: ':productId',
            name: 'productDetails',
            builder: (context, state) {
              final productId = state.pathParameters['productId']!;
              return ProductDetailsScreen(productId: productId);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => _errorScreen(context, state.error.toString()),
  );

  // Helper method to determine the selected bottom nav item
  static int _calculateSelectedIndex(GoRouterState state) {
    final String location = state.matchedLocation;
    if (location.startsWith(AppConstants.homeRoute)) {
      return 0;
    }
    if (location.startsWith(AppConstants.cartRoute)) {
      return 1;
    }
    if (location.startsWith(AppConstants.profileRoute)) {
      return 2;
    }
    return 0;
  }

  // Handle bottom navigation bar item taps
  static void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppConstants.homeRoute);
        break;
      case 1:
        context.go(AppConstants.cartRoute);
        break;
      case 2:
        context.go(AppConstants.profileRoute);
        break;
    }
  }

  static Widget _errorScreen(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Navigation Error: $message')),
    );
  }

  /// Navigation helper methods
  static void go(BuildContext context, String location, {Map<String, String> pathParameters = const {}}) {
    String resolvedLocation = location;

    // Replace path parameters
    for (final entry in pathParameters.entries) {
      resolvedLocation = resolvedLocation.replaceAll(':${entry.key}', entry.value);
    }

    context.go(resolvedLocation);
  }

  static void goNamed(BuildContext context, String name, {Map<String, String> pathParameters = const {}}) {
    context.goNamed(name, pathParameters: pathParameters);
  }

  static void push(BuildContext context, String location, {Map<String, String> pathParameters = const {}}) {
    String resolvedLocation = location;

    // Replace path parameters
    for (final entry in pathParameters.entries) {
      resolvedLocation = resolvedLocation.replaceAll(':${entry.key}', entry.value);
    }

    context.push(resolvedLocation);
  }

  static void pushNamed(BuildContext context, String name, {Map<String, String> pathParameters = const {}}) {
    context.pushNamed(name, pathParameters: pathParameters);
  }

  static void replace(BuildContext context, String location, {Map<String, String> pathParameters = const {}}) {
    String resolvedLocation = location;

    // Replace path parameters
    for (final entry in pathParameters.entries) {
      resolvedLocation = resolvedLocation.replaceAll(':${entry.key}', entry.value);
    }

    context.replace(resolvedLocation);
  }

  static void replaceNamed(BuildContext context, String name, {Map<String, String> pathParameters = const {}}) {
    context.replaceNamed(name, pathParameters: pathParameters);
  }

  static void pop<T>(BuildContext context, [T? result]) {
    context.pop(result);
  }
}
