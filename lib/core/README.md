# Core

[![Arabic](https://img.shields.io/badge/Language-Arabic-blueviolet?style=for-the-badge)](README-ar.md)

This directory contains foundational components, utilities, and services that are used throughout the Genius Store application.

## Purpose

The core directory:

- Provides fundamental building blocks for the application
- Houses central configuration and constants
- Implements cross-cutting concerns (error handling, logging, etc.)
- Contains global services (analytics, connectivity, etc.)
- Defines visual design system components
- Establishes application-wide utilities and helpers

## Directory Structure

```text
core/
├── config/            # Application configuration
├── constants/         # Application-wide constants
├── errors/            # Error handling and reporting
├── localization/      # Internationalization and localization
├── routes/            # Navigation and routing
├── services/          # Global services
├── theme/             # Visual design system
└── utils/             # Utility functions and extensions
```

## Key Components

### Config

`config/` contains application-wide configuration:

- `app_config.dart`: Environment-specific configuration (dev, staging, prod)
- `firebase_config.dart`: Firebase configuration and initialization
- `api_config.dart`: API endpoints and connection settings
- `storage_config.dart`: Local storage configuration

Configuration is loaded at application startup:

```dart
Future<void> initConfig() async {
  final configMap = await loadConfigForEnvironment(Environment.production);
  AppConfig.instance.initialize(configMap);
}
```

### Constants

`constants/` defines application-wide constant values:

- `app_constants.dart`: General application constants
- `asset_paths.dart`: Paths to static assets (images, fonts, etc.)
- `api_constants.dart`: API endpoints and keys
- `route_constants.dart`: Named navigation routes
- `regex_constants.dart`: Common regular expression patterns
- `error_constants.dart`: Error messages and codes

Constants are accessed throughout the application:

```dart
// Example usage
Text(
  AppConstants.appName,
  style: Theme.of(context).textTheme.headline1,
)
```

### Errors

`errors/` implements error handling and reporting:

- `app_exception.dart`: Base exception class for application-specific errors
- `failure.dart`: Failure result class for Either pattern
- `error_handler.dart`: Centralized error handling
- `error_logger.dart`: Error logging and reporting service
- `network_exceptions.dart`: Network-specific exceptions

Error handling follows this pattern:

```dart
Future<Either<Failure, User>> signIn(String email, String password) async {
  try {
    final user = await _authDataSource.signIn(email, password);
    return Right(user);
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message));
  } on CacheException catch (e) {
    return Left(CacheFailure(message: e.message));
  } catch (e) {
    return Left(UnexpectedFailure(message: e.toString()));
  }
}
```

### Localization

`localization/` handles internationalization and translation:

- `app_localizations.dart`: Localization delegate and string access
- `supported_locales.dart`: Supported languages and locales
- `locale_provider.dart`: Locale state management
- `string_keys.dart`: Translation key constants
- `translations/`: Language-specific translation files

Localization is used throughout the app:

```dart
// Accessing translated strings
final String welcomeMessage = AppLocalizations.of(context).translate(StringKeys.welcome);

// Setting the app locale
AppLocalizations.of(context).setLocale(Locale('es', 'ES'));
```

### Routes

`routes/` manages navigation and routing:

- `app_router.dart`: Main router configuration
- `route_observer.dart`: Navigation observer for analytics
- `route_guards.dart`: Navigation guards for authentication
- `route_transitions.dart`: Custom route transitions
- `deep_link_handler.dart`: Deep link handling

Navigation is performed through the router:

```dart
// Navigate to a named route
AppRouter.go(context, RouteConstants.productDetail, arguments: product);

// Generate route configuration
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteConstants.home:
      return MaterialPageRoute(builder: (_) => HomeScreen());
    case RouteConstants.productDetail:
      final product = settings.arguments as Product;
      return MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product));
    // Other routes...
    default:
      return MaterialPageRoute(builder: (_) => NotFoundScreen());
  }
}
```

### Services

`services/` provides global application services:

- `analytics_service.dart`: Usage tracking and analytics
- `connectivity_service.dart`: Network connectivity monitoring
- `local_storage_service.dart`: Persistent local storage
- `auth_service.dart`: Authentication and user management
- `permission_service.dart`: Device permission handling
- `push_notification_service.dart`: Push notification management
- `device_info_service.dart`: Device information and capabilities

Services are initialized at application startup and accessed via dependency injection:

```dart
// Service initialization
await AnalyticsService.instance.initialize();

// Service usage through dependency injection
final analyticsService = ref.watch(analyticsServiceProvider);
analyticsService.logEvent('product_viewed', {'product_id': product.id});
```

### Theme

`theme/` defines the application's visual design system:

- `app_theme.dart`: Theme configuration and creation
- `color_palette.dart`: Brand colors and semantic color definitions
- `text_styles.dart`: Typography definitions
- `dimensions.dart`: Spacing and sizing constants
- `app_icons.dart`: Custom icon definitions
- `decorations.dart`: Common box decorations and styles
- `input_decorations.dart`: Input field styling

Theme configuration is applied to the MaterialApp:

```dart
MaterialApp(
  title: AppConstants.appName,
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: themeMode,
  // Other configuration...
)
```

### Utils

`utils/` contains utility functions and extensions:

- `date_utils.dart`: Date formatting and manipulation
- `string_utils.dart`: String manipulation and formatting
- `validation_utils.dart`: Input validation helpers
- `currency_formatter.dart`: Currency formatting
- `image_utils.dart`: Image processing utilities
- `device_utils.dart`: Device-specific utilities
- `extensions/`: Extension methods for built-in types

Utilities are used throughout the application:

```dart
// Date formatting
final formattedDate = DateUtils.formatDate(order.createdAt, 'MMM dd, yyyy');

// Currency formatting
final formattedPrice = CurrencyFormatter.format(product.price);

// String extension usage
final truncatedText = productDescription.truncate(100);
```

## Design Patterns

The core module implements several design patterns:

### Singleton Pattern

Used for services that need a single instance throughout the application:

```dart
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  
  factory AnalyticsService() => _instance;
  
  AnalyticsService._internal();
  
  static AnalyticsService get instance => _instance;
  
  // Service implementation...
}
```

### Observer Pattern

Used for state changes and event notifications:

```dart
class ConnectivityService {
  final _connectivitySubject = BehaviorSubject<ConnectivityStatus>();
  
  Stream<ConnectivityStatus> get connectivityStream => 
      _connectivitySubject.stream;
  
  // Service implementation...
  
  void _updateConnectivityStatus(ConnectivityStatus status) {
    _connectivitySubject.add(status);
  }
}
```

### Factory Pattern

Used for creating objects with specific configurations:

```dart
class AppLogger {
  static Logger createLogger(String name) {
    return Logger(
      name: name,
      output: ConsoleOutput(),
      filter: ProductionFilter(),
      printer: PrettyPrinter(),
    );
  }
}
```

### Decorator Pattern

Used to extend functionality of existing classes:

```dart
class CachedHttpClient implements HttpClient {
  final HttpClient _client;
  final CacheService _cacheService;
  
  CachedHttpClient(this._client, this._cacheService);
  
  @override
  Future<Response> get(String url, {Map<String, dynamic>? headers}) async {
    // Check cache first
    final cachedResponse = await _cacheService.get(url);
    if (cachedResponse != null) {
      return cachedResponse;
    }
    
    // If not in cache, call actual client
    final response = await _client.get(url, headers: headers);
    
    // Cache the response
    await _cacheService.set(url, response);
    
    return response;
  }
  
  // Other HTTP methods...
}
```

## Dependencies

The core module is designed to have minimal external dependencies. However, it does rely on certain foundational packages:

- `flutter`: Flutter framework
- `shared_preferences`: Local storage
- `dio`: HTTP client for API requests
- `intl`: Internationalization and formatting
- `logger`: Logging functionality
- `connectivity_plus`: Network connectivity monitoring
- `firebase_core`: Core Firebase functionality
- `dartz`: Functional programming utilities

## Usage Guidelines

When working with the core module:

1. **Keep it Focused**: Core components should address cross-cutting concerns and provide foundational functionality
2. **Minimize Dependencies**: Core should have minimal dependencies on other application modules
3. **Stability First**: Core components should be stable and well-tested as they are used throughout the app
4. **Documentation**: Document public APIs thoroughly as they are used by many developers
5. **Consistent Error Handling**: Follow established error handling patterns
6. **Performance Awareness**: Core utilities are used frequently, so performance is critical

## Testing

Core components are thoroughly tested:

1. Unit tests for utilities and pure functions
2. Integration tests for services with external dependencies
3. Mock testing for services with platform dependencies
4. Performance tests for critical utilities
