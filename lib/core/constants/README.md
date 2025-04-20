# Constants Module

[![Arabic](https://img.shields.io/badge/Language-Arabic-blueviolet?style=for-the-badge)](README-ar.md)

This directory contains constant values used throughout the Genius Store application.

## Purpose

Constants centralize fixed values that are used across the application, providing:

- Consistency in naming and values
- Single source of truth for important application values
- Prevention of "magic numbers" and hardcoded strings
- Improved code readability and maintainability

## Components

### AppConstants

The main class containing general application constants:

- **Route Names**: Navigation route constants
- **API Endpoints**: API path constants
- **UI Constants**: Padding, margin, spacing values
- **Animation Constants**: Duration values for animations
- **Regex Patterns**: Common validation patterns
- **Storage Keys**: Keys used for local storage

### Enums

Enumeration types that define fixed sets of values:

- **OrderStatus**: Status values for orders (pending, processing, shipped, etc.)
- **PaymentType**: Types of payment methods
- **UserRole**: Different user roles in the application
- **NetworkStatus**: Connection status values

### String Constants

Textual constants organized by feature:

- **ErrorMessages**: Standard error messages
- **ValidationMessages**: Input validation messages
- **SuccessMessages**: Success confirmation messages

## Usage

Import the constants file and use the values directly:

```dart
import 'package:genius_store/core/constants/app_constants.dart';

// Navigate to the home screen
Navigator.pushNamed(context, AppConstants.homeRoute);

// Apply standard padding
Container(
  padding: EdgeInsets.all(AppConstants.defaultPadding),
  child: Text('Hello'),
);

// Use a validation pattern
final emailRegex = RegExp(AppConstants.emailPattern);
```

## Guidelines

When adding new constants:

1. Group related constants together
2. Use clear, descriptive names
3. Add comments explaining the purpose of complex constants
4. Consider creating separate files for feature-specific constants
5. Avoid adding mutable values as constants
