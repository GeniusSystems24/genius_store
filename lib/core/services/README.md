# Services Module

[![Arabic](https://img.shields.io/badge/Language-Arabic-blueviolet?style=for-the-badge)](README-ar.md)

This directory contains application-wide services that provide functionality across different features of the Genius Store application.

## Purpose

The services module provides reusable functionality that can be accessed throughout the application. These services:

- Encapsulate interactions with external systems
- Provide application-wide utilities
- Manage state that needs to be accessed across features
- Abstract platform-specific functionality

## Components

### Firebase Service

`firebase_service.dart` manages interactions with Firebase:

- Initializes Firebase
- Provides access to Firebase instances (Firestore, Auth, Storage)
- Handles Firebase configuration
- Implements utility methods for common Firebase operations

### Storage Service

`storage_service.dart` manages local data persistence:

- Initializes and provides access to shared preferences
- Handles secure storage for sensitive data
- Provides methods for storing and retrieving local data
- Manages caching policies

### Analytics Service

`analytics_service.dart` tracks user behavior:

- Initializes analytics providers
- Tracks screen views
- Logs events and user actions
- Manages user properties and attributes

### Connectivity Service

`connectivity_service.dart` monitors network status:

- Tracks internet connection status
- Provides stream of connectivity changes
- Implements retry mechanisms for network operations
- Caches data for offline use

### Authentication Service

`auth_service.dart` manages user authentication:

- Handles user sign-in and registration
- Manages authentication state
- Provides current user information
- Implements token refresh logic

### Notification Service

`notification_service.dart` manages push notifications:

- Initializes notification providers
- Handles notification permissions
- Processes incoming notifications
- Manages notification topics

## Usage

### Dependency Injection

Services are typically provided through Riverpod providers:

```dart
// Define the provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

// Access the service in a widget
final firebaseService = ref.watch(firebaseServiceProvider);
```

### Direct Usage

Some services can be accessed directly through static methods:

```dart
// Log an analytics event
AnalyticsService.logEvent('product_viewed', {'product_id': 'abc123'});

// Check connectivity
final isConnected = await ConnectivityService.hasInternetConnection();
```

### Service Initialization

Services that require initialization are set up in the application's main method:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await FirebaseService.initialize();
  await StorageService.initialize();
  await NotificationService.initialize();
  
  runApp(const ProviderScope(child: App()));
}
```

## Creating New Services

When creating a new service:

1. Define a clear responsibility for the service
2. Create an interface/abstract class if it might have multiple implementations
3. Consider whether it needs to be injectable or can be static
4. Add initialization logic if needed
5. Document the public API thoroughly
