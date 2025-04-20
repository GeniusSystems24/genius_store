/// Utility class for form field validation
class Validators {
  /// Validates an email address
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates a password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validates a name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates a phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  /// Validates a required field
  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates a credit card number
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required';
    }

    // Remove spaces and dashes
    final sanitized = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if the number consists of only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(sanitized)) {
      return 'Credit card number can only contain digits';
    }

    // Check length (most credit cards are 13-19 digits)
    if (sanitized.length < 13 || sanitized.length > 19) {
      return 'Credit card number must be 13-19 digits';
    }

    // Apply Luhn algorithm
    int sum = 0;
    bool alternate = false;
    for (int i = sanitized.length - 1; i >= 0; i--) {
      int digit = int.parse(sanitized[i]);
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      sum += digit;
      alternate = !alternate;
    }

    if (sum % 10 != 0) {
      return 'Invalid credit card number';
    }

    return null;
  }

  /// Validates a zip/postal code
  static String? validateZipCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Postal code is required';
    }

    // Most common postal code formats
    final zipRegex = RegExp(r'^[0-9]{5}(-[0-9]{4})?$|^[A-Za-z][0-9][A-Za-z] [0-9][A-Za-z][0-9]$');
    if (!zipRegex.hasMatch(value)) {
      return 'Enter a valid postal code';
    }
    return null;
  }

  /// Validates a number within a range
  static String? validateNumberRange(String? value, {double? min, double? max}) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    final numValue = double.tryParse(value);
    if (numValue == null) {
      return 'Please enter a valid number';
    }

    if (min != null && numValue < min) {
      return 'Value must be greater than or equal to $min';
    }

    if (max != null && numValue > max) {
      return 'Value must be less than or equal to $max';
    }

    return null;
  }

  /// Validates a date
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }

    final dateRegex = RegExp(r'^([0-9]{4})-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$');
    if (!dateRegex.hasMatch(value)) {
      return 'Enter a valid date in YYYY-MM-DD format';
    }

    try {
      final date = DateTime.parse(value);
      final now = DateTime.now();
      if (date.isAfter(now)) {
        return 'Date cannot be in the future';
      }
    } catch (e) {
      return 'Invalid date';
    }

    return null;
  }
}
