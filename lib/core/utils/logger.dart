import 'package:logger/logger.dart';

/// Custom logger class for application-wide logging
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();

  factory AppLogger() => _instance;

  AppLogger._internal();

  final logger = Logger(
    printer: PrettyPrinter(methodCount: 2, errorMethodCount: 8, lineLength: 120, colors: true, printEmojis: true, printTime: true),
  );

  /// Log a debug message
  void d(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.d(message,  error, stackTrace);
  }

  /// Log an info message
  void i(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.i(message, error, stackTrace);
  }

  /// Log a warning message
  void w(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.w(message, error, stackTrace);
  }

  /// Log an error message
  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.e(message, error, stackTrace);
  }

  /// Log a fatal message
  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.wtf(message, error, stackTrace);
  }

  /// Log a verbose message
  void v(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.v(message, error, stackTrace);
  }

  /// Log a Firebase event
  void logFirebase(String event, [Map<String, dynamic>? parameters]) {
    logger.i('Firebase Event: $event', parameters);
  }

  /// Log an API request
  void logApiRequest(String url, {String? method, Map<String, dynamic>? headers, dynamic body}) {
    logger.d('API Request: $method $url', {'headers': headers, 'body': body});
  }

  /// Log an API response
  void logApiResponse(String url, {int? statusCode, dynamic response, Duration? requestDuration}) {
    logger.d('API Response: $statusCode $url (${requestDuration?.inMilliseconds}ms)', response);
  }

  /// Log a navigation event
  void logNavigation(String routeName, {dynamic arguments}) {
    logger.i('Navigation: $routeName', arguments);
  }

  /// Log user action
  void logUserAction(String action, {Map<String, dynamic>? data}) {
    logger.i('User Action: $action', data);
  }

  /// Log application lifecycle event
  void logLifecycle(String event) {
    logger.d('Lifecycle: $event');
  }
}
