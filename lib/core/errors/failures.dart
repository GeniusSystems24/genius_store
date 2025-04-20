import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure related to server issues
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({String message = 'Server failure occurred', this.statusCode}) : super(message);

  @override
  List<Object> get props => [message, statusCode ?? ''];
}

/// Failure related to cache operations
class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache failure occurred'}) : super(message);
}

/// Failure related to authentication
class AuthFailure extends Failure {
  final String? code;

  const AuthFailure({String message = 'Authentication failure', this.code}) : super(message);

  @override
  List<Object> get props => [message, code ?? ''];
}

/// Failure related to network issues
class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Network failure occurred'}) : super(message);
}

/// Failure related to data formatting
class FormatFailure extends Failure {
  const FormatFailure({String message = 'Data format failure occurred'}) : super(message);
}

/// Failure related to not found resources
class NotFoundFailure extends Failure {
  final String resource;
  final String? id;

  const NotFoundFailure({required this.resource, this.id, String message = 'Resource not found'}) : super(message);

  @override
  List<Object> get props => [message, resource, id ?? ''];
}

/// Failure related to validation errors
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({String message = 'Validation failed', this.errors}) : super(message);

  @override
  List<Object> get props => [message, errors ?? {}];
}
