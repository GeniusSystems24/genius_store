# Theme Module

[![Arabic](https://img.shields.io/badge/Language-Arabic-blueviolet?style=for-the-badge)](README-ar.md)

This directory contains the visual styling infrastructure for the Genius Store application.

## Purpose

The theme module provides a consistent visual design across the application by:

- Defining color schemes, typography, and component styles
- Supporting both light and dark themes
- Centralizing design tokens and styling decisions
- Providing utilities for theme management

## Components

### AppTheme

`app_theme.dart` is the main theme configuration class:

- Defines light and dark `ThemeData` objects
- Configures global component themes (buttons, inputs, cards, etc.)
- Provides convenience methods for theme manipulation

### Color Palette

`color_palette.dart` defines the application color scheme:

- Primary colors
- Secondary colors
- Accent colors
- Semantic colors (success, error, warning, info)
- Neutral colors (for backgrounds, texts, dividers)
- Gradients and color combinations

### Typography

`typography.dart` defines text styles:

- Font families
- Text sizes
- Font weights
- Line heights
- Letter spacing
- Text styles for different purposes (headings, body, captions, etc.)

### Theme Extensions

Custom theme extensions for application-specific components:

- `card_theme_extension.dart`: Extended styling for cards
- `button_theme_extension.dart`: Custom button variants
- Other component-specific extensions

## Usage

### Accessing Theme Data

In widgets, access the theme through the `Theme.of(context)` method:

```dart
final theme = Theme.of(context);

// Use colors
Container(
  color: theme.colorScheme.background,
  child: Text(
    'Hello',
    style: TextStyle(color: theme.colorScheme.onBackground),
  ),
);

// Use text themes
Text(
  'Heading',
  style: theme.textTheme.headline5,
);
```

### Using Custom Theme Extensions

For application-specific theme extensions:

```dart
// Get custom button theme extension
final buttonTheme = Theme.of(context).extension<ButtonThemeExtension>();

// Use custom button style
ElevatedButton(
  style: buttonTheme?.primaryOutlined,
  onPressed: () {},
  child: Text('Custom Button'),
);
```

### Theme Switching

Changing between light and dark themes:

```dart
// In a stateful widget or provider
ThemeMode _themeMode = ThemeMode.system;

// Update the theme mode
void setThemeMode(ThemeMode mode) {
  setState(() {
    _themeMode = mode;
  });
}

// In the MaterialApp
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: _themeMode,
  // ...
);
```

## Design System Alignment

The theme module is aligned with the application's design system, ensuring:

- Consistent use of colors, spacing, and typography
- Proper implementation of design tokens
- Accurate representation of component styles
- Support for design system evolution

## Extending the Theme

To add new theme elements:

1. Define the new styles or components in the appropriate theme file
2. For complex components, create a new extension class
3. Register extensions with the theme in `AppTheme`
4. Document usage examples for other developers
