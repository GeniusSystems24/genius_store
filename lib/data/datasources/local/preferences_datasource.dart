import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Interface for accessing local preferences data
abstract class PreferencesDataSource {
  /// Gets the stored language code
  Future<String?> getLanguage();

  /// Sets the language code
  Future<void> setLanguage(String languageCode);

  /// Gets the stored theme mode (light, dark, system)
  Future<String?> getThemeMode();

  /// Sets the theme mode
  Future<void> setThemeMode(String themeMode);

  /// Gets the current user ID
  Future<String?> getCurrentUserId();

  /// Sets the current user ID
  Future<void> setCurrentUserId(String? userId);

  /// Gets the active cart ID
  Future<String?> getActiveCartId();

  /// Sets the active cart ID
  Future<void> setActiveCartId(String? cartId);

  /// Gets the recent search queries
  Future<List<String>> getRecentSearches();

  /// Adds a search query to recent searches
  Future<void> addRecentSearch(String query);

  /// Clears all recent searches
  Future<void> clearRecentSearches();

  /// Gets the recently viewed product IDs
  Future<List<String>> getRecentlyViewedProducts();

  /// Adds a product ID to recently viewed products
  Future<void> addRecentlyViewedProduct(String productId);

  /// Clears all app data from preferences
  Future<void> clearAllData();
}

/// Implementation of PreferencesDataSource using SharedPreferences
class PreferencesDataSourceImpl implements PreferencesDataSource {
  final SharedPreferences _prefs;

  // Keys for SharedPreferences
  static const String _languageKey = 'language_code';
  static const String _themeModeKey = 'theme_mode';
  static const String _currentUserIdKey = 'current_user_id';
  static const String _activeCartIdKey = 'active_cart_id';
  static const String _recentSearchesKey = 'recent_searches';
  static const String _recentlyViewedKey = 'recently_viewed_products';

  // Maximum number of items to store in lists
  static const int _maxRecentSearches = 10;
  static const int _maxRecentlyViewed = 20;

  PreferencesDataSourceImpl(this._prefs);

  /// Factory constructor to create an instance with initialized SharedPreferences
  static Future<PreferencesDataSourceImpl> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesDataSourceImpl(prefs);
  }

  @override
  Future<String?> getLanguage() async {
    return _prefs.getString(_languageKey);
  }

  @override
  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
  }

  @override
  Future<String?> getThemeMode() async {
    return _prefs.getString(_themeModeKey);
  }

  @override
  Future<void> setThemeMode(String themeMode) async {
    await _prefs.setString(_themeModeKey, themeMode);
  }

  @override
  Future<String?> getCurrentUserId() async {
    return _prefs.getString(_currentUserIdKey);
  }

  @override
  Future<void> setCurrentUserId(String? userId) async {
    if (userId != null) {
      await _prefs.setString(_currentUserIdKey, userId);
    } else {
      await _prefs.remove(_currentUserIdKey);
    }
  }

  @override
  Future<String?> getActiveCartId() async {
    return _prefs.getString(_activeCartIdKey);
  }

  @override
  Future<void> setActiveCartId(String? cartId) async {
    if (cartId != null) {
      await _prefs.setString(_activeCartIdKey, cartId);
    } else {
      await _prefs.remove(_activeCartIdKey);
    }
  }

  @override
  Future<List<String>> getRecentSearches() async {
    final jsonString = _prefs.getString(_recentSearchesKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<String>();
    } catch (e) {
      // In case of error, return empty list and reset stored value
      await clearRecentSearches();
      return [];
    }
  }

  @override
  Future<void> addRecentSearch(String query) async {
    final searches = await getRecentSearches();

    // Remove the query if it already exists to prevent duplicates
    searches.remove(query);

    // Add the new query at the beginning
    searches.insert(0, query);

    // Keep only the maximum number of recent searches
    if (searches.length > _maxRecentSearches) {
      searches.removeLast();
    }

    await _prefs.setString(_recentSearchesKey, jsonEncode(searches));
  }

  @override
  Future<void> clearRecentSearches() async {
    await _prefs.remove(_recentSearchesKey);
  }

  @override
  Future<List<String>> getRecentlyViewedProducts() async {
    final jsonString = _prefs.getString(_recentlyViewedKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<String>();
    } catch (e) {
      // In case of error, return empty list and reset stored value
      await _prefs.remove(_recentlyViewedKey);
      return [];
    }
  }

  @override
  Future<void> addRecentlyViewedProduct(String productId) async {
    final products = await getRecentlyViewedProducts();

    // Remove the product if it already exists to prevent duplicates
    products.remove(productId);

    // Add the new product at the beginning
    products.insert(0, productId);

    // Keep only the maximum number of recently viewed products
    if (products.length > _maxRecentlyViewed) {
      products.removeLast();
    }

    await _prefs.setString(_recentlyViewedKey, jsonEncode(products));
  }

  @override
  Future<void> clearAllData() async {
    await _prefs.clear();
  }
}
