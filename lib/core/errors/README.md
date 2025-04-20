# Error Handling Module

[![Arabic](https://img.shields.io/badge/Language-Arabic-blueviolet?style=for-the-badge)](README-ar.md)

This directory contains the error handling infrastructure for the Genius Store application.

## Purpose

The error handling module provides a structured approach to handling exceptions and failures throughout the application. It:

- Separates errors by layer (data, domain, presentation)
- Provides clear error types for different failure scenarios
- Facilitates consistent error reporting and recovery
- Enables proper error translation for user-facing messages

## Components

### Exceptions

`exceptions.dart` defines custom exception classes for specific error scenarios:

- **ServerException**: Occurs when there's a failure in communicating with the server
- **CacheException**: Occurs when there's an error with local data storage operations
- **NetworkException**: Occurs when there's no internet connection
- **AuthenticationException**: Occurs when authentication fails
- **ValidationException**: Occurs when data validation fails

These exceptions are primarily thrown in the data layer.

### Failures

`failures.dart` defines failure classes representing business logic errors:

- **Failure**: Abstract base class for all failures
- **ServerFailure**: Indicates a server-related issue
- **CacheFailure**: Indicates a local storage issue
- **NetworkFailure**: Indicates a network connectivity issue  
- **AuthenticationFailure**: Indicates authentication problems
- **ValidationFailure**: Indicates data validation errors

These failures are used in the domain and presentation layers.

### Error Handler

`error_handler.dart` provides utilities to:

- Convert exceptions to failures
- Map failures to user-friendly messages
- Log errors appropriately
- Handle generic errors

## Usage

### Handling Exceptions

In data sources or repositories:

```dart
try {
  // API call or database operation
} on ServerException catch (e) {
  return Left(ServerFailure(e.message));
} on CacheException catch (e) {
  return Left(CacheFailure(e.message));
} catch (e) {
  return Left(UnexpectedFailure(e.toString()));
}
```

### Using Failures with Either

The domain layer uses `Either` (from `dartz` package) to represent success or failure:

```dart
// Repository interface
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
}

// Use case
class GetProductsUseCase {
  final ProductRepository repository;
  
  GetProductsUseCase(this.repository);
  
  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}
```

### Displaying User-friendly Messages

In the presentation layer:

```dart
state.productResult.fold(
  (failure) => Text(ErrorHandler.getErrorMessage(failure)),
  (products) => ProductListView(products: products),
);
```

## Error Reporting

Serious errors are automatically logged using the application's logging service for later analysis and debugging.
