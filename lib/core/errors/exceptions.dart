/// Exception thrown when server fails to respond
class ServerException implements Exception {
  final String? message;
  final int? statusCode;

  ServerException({this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (Status code: $statusCode)';
}

/// Exception thrown when cache operations fail
class CacheException implements Exception {
  final String? message;

  CacheException({this.message});

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown during authentication process
class AuthException implements Exception {
  final String? message;
  final String? code;

  AuthException({this.message, this.code});

  @override
  String toString() => 'AuthException: $message (Code: $code)';
}

/// Exception thrown for network connectivity issues
class NetworkException implements Exception {
  final String? message;

  NetworkException({this.message});

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when format of received data is unexpected
class FormatException implements Exception {
  final String? message;

  FormatException({this.message});

  @override
  String toString() => 'FormatException: $message';
}

/// Exception thrown when requested resource is not found
class NotFoundException implements Exception {
  final String? resource;
  final String? id;

  NotFoundException({this.resource, this.id});

  @override
  String toString() => 'NotFoundException: $resource with id $id not found';
}
