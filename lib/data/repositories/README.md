# Repository Implementations

[![Arabic](https://img.shields.io/badge/Language-Arabic-blueviolet?style=for-the-badge)](README-ar.md)

This directory contains concrete implementations of the repository interfaces defined in the domain layer of the Genius Store application.

## Purpose

Repository implementations:

- Connect the domain layer to the data sources
- Coordinate between multiple data sources (remote/local)
- Implement caching strategies
- Handle data transformations between models and entities
- Implement error handling and recovery strategies

## Key Concepts

### Repository Pattern

The Repository pattern provides a clean API for the domain layer to access data without knowing where it comes from. Benefits include:

- Separation of concerns: Domain layer doesn't need to know about data sources
- Testability: Repositories can be easily mocked for testing
- Flexibility: Data sources can be swapped without affecting the domain layer
- Centralized data access logic: Consistent handling of data operations

## Implementation Structure

A typical repository implementation includes:

- Implementation of a domain repository interface
- Dependencies on one or more data sources
- Methods that coordinate data source operations
- Error handling with conversion to domain failures
- Mapping between data models and domain entities

Example:

```dart
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        // Fetch from remote source
        final remoteProducts = await remoteDataSource.getProducts();
        
        // Cache the result
        await localDataSource.cacheProducts(remoteProducts);
        
        // Map models to entities and return
        return Right(remoteProducts.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        // Get from local cache
        final localProducts = await localDataSource.getCachedProducts();
        return Right(localProducts.map((model) => model.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  // Other methods implementation...
}
```

## Available Repositories

The application includes repository implementations for:

- **User-related**: `UserRepositoryImpl`, `AuthRepositoryImpl`
- **Product-related**: `ProductRepositoryImpl`, `CategoryRepositoryImpl`
- **Shopping-related**: `CartRepositoryImpl`, `WishlistRepositoryImpl`
- **Order-related**: `OrderRepositoryImpl`, `PaymentRepositoryImpl`

## Caching Strategies

Repository implementations can use different caching strategies:

1. **Cache-then-Network**: Return cached data first, then fetch from network and update
2. **Network-then-Cache**: Fetch from network first, fallback to cache if network fails
3. **Cache-or-Network**: Use cache if available and fresh, otherwise fetch from network
4. **Network-only**: Always fetch from network (for critical/time-sensitive data)
5. **Cache-only**: Only use cached data (for specific offline features)

## Error Handling

Repositories handle errors by:

1. Catching specific exceptions from data sources
2. Converting them to appropriate domain failure types
3. Returning Either<Failure, T> to propagate errors to the domain layer

## Dependency Injection

Repositories are typically provided through dependency injection:

```dart
// Using Riverpod for dependency injection
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  final localDataSource = ref.watch(productLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  
  return ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
});
```

## Testing

Repository implementations should be thoroughly tested:

- Unit tests with mocked data sources
- Different network connectivity scenarios
- Various error conditions
- Caching behavior verification
