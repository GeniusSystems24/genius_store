# Utilities Module

[![Arabic](https://img.shields.io/badge/Language-Arabic-blueviolet?style=for-the-badge)](README-ar.md)

This directory contains general-purpose utility functions and classes used throughout the Genius Store application.

## Purpose

The utilities module provides commonly used functions and tools that:

- Reduce code duplication
- Simplify common operations
- Standardize implementation of frequently used patterns
- Enhance code readability and maintainability

## Components

### Logger

`logger.dart` provides a standardized logging system:

- Different log levels (debug, info, warning, error)
- Consistent log formatting
- Environment-based log filtering
- Integration with crash reporting

```dart
final logger = AppLogger();
logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message', exception, stackTrace);
```

### Date Formatter

`date_formatter.dart` offers date and time manipulation utilities:

- Format dates into various string representations
- Parse date strings
- Calculate relative times (e.g., "2 hours ago")
- Handle timezone conversions

```dart
// Format a date
final formattedDate = DateFormatter.format(
  DateTime.now(),
  format: DateFormat.medium,
);

// Calculate relative time
final relativeTime = DateFormatter.getRelativeTime(pastDate);
```

### Validators

`validators.dart` contains data validation functions:

- Email validation
- Password strength checking
- Phone number validation
- Credit card validation
- Required field validation

```dart
// Validate an email
final isValid = Validators.isValidEmail('user@example.com');

// Validate password strength
final strength = Validators.getPasswordStrength('p@ssw0rd');
```

### String Utils

`string_utils.dart` provides string manipulation helpers:

- Capitalization functions
- Truncation with ellipsis
- Search term highlighting
- String masks (e.g., for credit cards or phone numbers)

```dart
// Capitalize a string
final capitalized = StringUtils.capitalize('hello');

// Truncate with ellipsis
final truncated = StringUtils.truncate('Long text to truncate', 10);
```

### Number Utils

`number_utils.dart` contains numeric utility functions:

- Number formatting
- Currency formatting
- Unit conversions
- Rounding helpers

```dart
// Format as currency
final price = NumberUtils.formatCurrency(19.99, 'USD');

// Format with precision
final formatted = NumberUtils.formatWithPrecision(3.14159, 2);
```

### Device Utils

`device_utils.dart` provides device-specific utilities:

- Screen size detection
- Platform detection
- Device capability checking
- Safe area calculations

```dart
// Check if on iOS
final isIOS = DeviceUtils.isIOS();

// Get device type
final deviceType = DeviceUtils.getDeviceType();
```

### UI Utils

`ui_utils.dart` contains UI helper functions:

- Show snackbars
- Display dialogs
- Handle keyboard visibility
- Manage focus

```dart
// Show a snackbar
UIUtils.showSnackBar(context, 'Item added to cart');

// Show dialog
await UIUtils.showConfirmationDialog(
  context,
  title: 'Confirm',
  message: 'Are you sure?',
);
```

### Extensions

Various extension files add functionality to existing types:

- `context_extensions.dart`: Adds helper methods to BuildContext
- `string_extensions.dart`: Extends String class functionality
- `list_extensions.dart`: Enhances List operations
- `datetime_extensions.dart`: Adds methods to DateTime

```dart
// Context extension for screen size
final screenWidth = context.screenWidth;

// String extension
final slugified = 'Hello World'.slugify();  // "hello-world"
```

## Best Practices

When using or creating utilities:

1. Keep utility functions focused on a single responsibility
2. Add clear documentation for each function
3. Write unit tests for all utility functions
4. Avoid stateful utilities when possible
5. Group related functions in logical modules
6. Use extension methods when enhancing existing types
