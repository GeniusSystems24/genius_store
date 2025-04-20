# Routing Module

[![Arabic](https://img.shields.io/badge/Language-Arabic-blueviolet?style=for-the-badge)](README-ar.md)

This directory contains the navigation and routing system for the Genius Store application.

## Purpose

The routing module provides a central place to define, manage, and navigate between screens in the application. It:

- Defines named routes for all screens
- Handles route generation and parameter passing
- Manages navigation transitions and animations
- Implements route guards for authentication and authorization

## Components

### AppRouter

The `AppRouter` class is the main routing controller:

- `generateRoute`: Creates route objects based on route names and arguments
- `onUnknownRoute`: Handles navigation to undefined routes
- Navigation helper methods for common operations

### Route Constants

Route name constants are defined in `AppConstants` (within the constants module):

- `homeRoute`: Path to the home screen
- `productDetailsRoute`: Path to product details screen
- `cartRoute`: Path to shopping cart
- `checkoutRoute`: Path to checkout flow
- `profileRoute`: Path to user profile
- etc.

### Route Guards

The routing system includes protection mechanisms:

- `AuthGuard`: Verifies user authentication before navigating to protected routes
- `MaintenanceGuard`: Redirects to maintenance screen when features are unavailable

## Usage

### Declaring Routes

Routes are centrally defined in the `AppRouter.generateRoute` method:

```dart
static Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppConstants.homeRoute:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
      
    case AppConstants.productDetailsRoute:
      final productId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(productId: productId),
      );
      
    // Other routes...
      
    default:
      return MaterialPageRoute(
        builder: (_) => const NotFoundScreen(),
      );
  }
}
```

### Basic Navigation

Navigate to named routes:

```dart
// Navigate to a screen
Navigator.pushNamed(
  context, 
  AppConstants.productDetailsRoute,
  arguments: 'product-123',
);

// Navigate and replace current screen
Navigator.pushReplacementNamed(
  context,
  AppConstants.homeRoute,
);

// Navigate and clear history
Navigator.pushNamedAndRemoveUntil(
  context,
  AppConstants.homeRoute,
  (route) => false,
);
```

### Using Navigation Helper Methods

The `AppRouter` provides convenience methods:

```dart
// Navigate to product details
AppRouter.toProductDetails(context, productId: 'product-123');

// Navigate to checkout
AppRouter.toCheckout(context, cart: currentCart);

// Go back to home screen and clear history
AppRouter.toHomeAndClear(context);
```

## Deep Linking

The routing system supports deep linking to specific screens from external sources:

- URI scheme: `geniusstore://`
- Mapping from deep link URIs to application routes
- Handling of parameters from deep links

## Route Transitions

Custom transitions between routes can be defined:

- Slide transitions
- Fade transitions
- Custom animated transitions

Example:

```dart
// Create a fade transition
static Route<dynamic> _createFadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
```
