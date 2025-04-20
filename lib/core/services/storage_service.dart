import 'package:shared_preferences/shared_preferences.dart';
import '../errors/exceptions.dart';

/// Service class to handle local storage operations
class StorageService {
  late SharedPreferences _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      throw CacheException(message: 'Failed to initialize SharedPreferences: ${e.toString()}');
    }
  }

  // String operations
  Future<bool> saveString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save string: ${e.toString()}');
    }
  }

  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get string: ${e.toString()}');
    }
  }

  // Int operations
  Future<bool> saveInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save int: ${e.toString()}');
    }
  }

  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get int: ${e.toString()}');
    }
  }

  // Double operations
  Future<bool> saveDouble(String key, double value) async {
    try {
      return await _prefs.setDouble(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save double: ${e.toString()}');
    }
  }

  double? getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get double: ${e.toString()}');
    }
  }

  // Bool operations
  Future<bool> saveBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save bool: ${e.toString()}');
    }
  }

  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get bool: ${e.toString()}');
    }
  }

  // String List operations
  Future<bool> saveStringList(String key, List<String> value) async {
    try {
      return await _prefs.setStringList(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save string list: ${e.toString()}');
    }
  }

  List<String>? getStringList(String key) {
    try {
      return _prefs.getStringList(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get string list: ${e.toString()}');
    }
  }

  // Check if key exists
  bool hasKey(String key) {
    try {
      return _prefs.containsKey(key);
    } catch (e) {
      throw CacheException(message: 'Failed to check key: ${e.toString()}');
    }
  }

  // Remove a key
  Future<bool> removeKey(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      throw CacheException(message: 'Failed to remove key: ${e.toString()}');
    }
  }

  // Clear all data
  Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear storage: ${e.toString()}');
    }
  }
}
