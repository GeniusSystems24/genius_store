# Configuration Module

This directory contains configuration settings for the Genius Store application.

## Purpose

The configuration module centralizes application settings in one place, making it easier to adjust parameters without searching through the codebase. This promotes maintainability and configuration isolation.

## Components

### AppConfig

`AppConfig` is the main class that holds application-wide configuration:

- **App Information**: Name, version, build number
- **Environment Configuration**: Development, production, staging settings
- **Localization Settings**: Default and supported locales
- **Theme Configuration**: Default theme mode (light/dark/system)
- **API Configuration**: Endpoints, timeout settings
- **Feature Toggles**: Flags for enabling/disabling features

## Usage

Access configuration values through the `AppConfig` class:

```dart
// Get the application name
final appName = AppConfig.appName;

// Check if a feature is enabled
if (AppConfig.isFeatureEnabled('new_checkout')) {
  // Use new checkout flow
}

// Get the API base URL for the current environment
final apiUrl = AppConfig.apiBaseUrl;
```

## Environment-specific Configuration

The configuration adapts based on the current build environment:

- **Development**: Points to development servers, enables debugging features
- **Staging**: Uses staging servers with test data
- **Production**: Uses production endpoints with optimized settings

## Extending Configuration

To add new configuration parameters:

1. Add the new parameter to the appropriate section in `app_config.dart`
2. Document the parameter with clear comments
3. Update environment-specific values if needed
