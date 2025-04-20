# Repository Interfaces

This directory contains abstract classes that define the data access contracts for the Genius Store application. These interfaces establish how the domain layer interacts with data without knowing the implementation details.

## Purpose

Repository interfaces:

- Define the contract between domain and data layers
- Specify data operations without implementation details
- Enable dependency inversion (domain layer defines the interface, data layer implements it)
- Facilitate testing through mocking
- Establish a clean separation of concerns

## Key Concept: Dependency Inversion

Repository interfaces are a key application of the Dependency Inversion Principle (the 'D' in SOLID):

- High-level modules (domain) should not depend on low-level modules (data)
- Both should depend on abstractions (interfaces)
- Abstractions should not depend on details
- Details should depend on abstractions

By defining repository interfaces in the domain layer, the domain layer controls the contract and remains independent of data implementation details.

## Interface Structure

A typical repository interface includes:

- Methods for CRUD operations on domain entities
- Other data access methods specific to the business domain
- Use of the Either type for returning success or failure

Example:

```dart
abstract class ProductRepository {
  /// Get a list of all products
  Future<Either<Failure, List<Product>>> getProducts();
  
  /// Get a product by its ID
  Future<Either<Failure, Product>> getProductById(String id);
  
  /// Get products by category
  Future<Either<Failure, List<Product>>> getProductsByCategory(String categoryId);
  
  /// Search products by query
  Future<Either<Failure, List<Product>>> searchProducts(String query);
  
  /// Get featured products
  Future<Either<Failure, List<Product>>> getFeaturedProducts();
  
  /// Get product variants
  Future<Either<Failure, List<ProductVariant>>> getProductVariants(String productId);
}
```

## Available Repositories

The application includes repository interfaces for:

- **AuthRepository**: Authentication operations
- **UserRepository**: User profile management
- **ProductRepository**: Product data access
- **CategoryRepository**: Product category management
- **CartRepository**: Shopping cart operations
- **OrderRepository**: Order processing and history
- **PaymentRepository**: Payment method management
- **AddressRepository**: Shipping address management
- **WishlistRepository**: Saved/favorite products

## Error Handling

Repository interfaces use the Either type (from the dartz package) for error handling:

- `Left<Failure>`: Represents an operation failure with a specific failure type
- `Right<T>`: Represents a successful operation with the result

This approach:

- Makes error handling explicit and impossible to ignore
- Allows for typed failures rather than generic exceptions
- Separates error handling from normal control flow

## Implementation Requirements

Implementations of these interfaces in the data layer must:

- Return the appropriate entity types (not data models)
- Handle all possible error conditions
- Map data source exceptions to domain failures
- Follow any caching or offline-first requirements

## Testing

The domain layer typically uses mocked implementations of these interfaces for testing use cases:

```dart
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProductsUseCase useCase;
  late MockProductRepository mockRepository;
  
  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductsUseCase(mockRepository);
  });
  
  test('should get products from the repository', () async {
    // Arrange
    final products = [Product(...), Product(...)];
    when(mockRepository.getProducts())
        .thenAnswer((_) async => Right(products));
    
    // Act
    final result = await useCase();
    
    // Assert
    expect(result, Right(products));
    verify(mockRepository.getProducts());
    verifyNoMoreInteractions(mockRepository);
  });
}
```
