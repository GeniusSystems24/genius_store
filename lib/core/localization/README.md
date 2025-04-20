# Localization Module

[![Arabic](https://img.shields.io/badge/Language-Arabic-blueviolet?style=for-the-badge)](README-ar.md)

This directory contains the internationalization and localization infrastructure for the Genius Store application.

## Purpose

The localization module provides multi-language support, allowing the application to display text in different languages based on user preferences or device settings. It:

- Manages translation strings for all application texts
- Handles locale changes and language switching
- Provides utilities for formatting locale-specific values (dates, numbers, currencies)
- Supports right-to-left (RTL) languages

## Components

### AppLocalizations

The `AppLocalizations` class is the main entry point for localization:

- Loads and holds translations for the current locale
- Provides access to translated strings
- Includes the delegate for the Flutter localization system
- Handles fallback to default language when translations are missing

### Translation Files

JSON files containing the translated strings for each supported language:

- `en.json`: English translations (default)
- `ar.json`: Arabic translations
- Additional language files as needed

### Localization Utilities

Helper functions for locale-specific operations:

- `LocaleFormatter`: Formats dates, numbers, and currencies according to locale
- `LocaleUtils`: Utilities for working with locales, including RTL detection
- `LocalePrefService`: Manages user language preferences

## Supported Languages

The application currently supports the following languages:

- English (en) - Default
- Arabic (ar)

## Usage

### Accessing Translations

```dart
// Using the BuildContext extension
Text(context.l10n.welcomeMessage);

// Using the AppLocalizations directly
final localizations = AppLocalizations.of(context);
Text(localizations.productDetails);

// Using parameterized translations
Text(context.l10n.itemCount(5));
```

### Switching Languages

```dart
// Change the application language
await LocalePrefService.setPreferredLocale(const Locale('ar'));
```

### Formatting Values Based on Locale

```dart
// Format a date according to the current locale
final formattedDate = LocaleFormatter.formatDate(
  dateTime: DateTime.now(),
  context: context,
);

// Format currency
final formattedPrice = LocaleFormatter.formatCurrency(
  amount: 99.99,
  context: context,
);
```

## Adding New Translations

To add translations for a new string:

1. Add the key and English value to `en.json`
2. Add the key and translated value to all other language files
3. Add the getter method to the `AppLocalizations` class

## Adding a New Language

To add support for a new language:

1. Create a new JSON file named with the language code (e.g., `fr.json`)
2. Translate all keys from the English file
3. Add the locale to the supported locales in `AppConfig`
4. Update the `AppLocalizations.delegate.supportedLocales`
