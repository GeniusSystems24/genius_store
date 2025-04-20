# Data Sources

The data sources directory contains classes that handle direct communication with different data providers in the Genius Store application.

## Purpose

Data sources:

- Encapsulate the details of how data is retrieved or stored
- Provide a clean API for repositories to access data
- Handle the specifics of different data providers (Firebase, local storage, etc.)
- Implement the low-level data operations (CRUD)

## Types of Data Sources

### Remote Data Sources

Remote data sources handle communication with external services:

- **Firebase Firestore**: Retrieves and stores product, user, and order data in Firestore
- **Firebase Storage**: Manages image uploads and retrieval
- **Firebase Authentication**: Handles user authentication operations
- **Cloud Functions**: Calls serverless functions for complex operations

Example:

```dart
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
  Future<List<ProductModel>> searchProducts(String query);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;
  
  ProductRemoteDataSourceImpl({required this.firestore});
  
  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await firestore.collection('products').get();
      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch products: ${e.toString()}');
    }
  }
  
  // Other method implementations...
}
```

### Local Data Sources

Local data sources interact with on-device storage:

- **SharedPreferences**: Stores small pieces of data (user preferences, tokens)
- **Hive/SQLite**: Caches larger datasets for offline access
- **Secure Storage**: Manages sensitive data with encryption

Example:

```dart
abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts();
  Future<void> clearCache();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  ProductLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final jsonString = json.encode(
      products.map((product) => product.toJson()).toList(),
    );
    await sharedPreferences.setString('CACHED_PRODUCTS', jsonString);
  }
  
  // Other method implementations...
}
```

## Design Patterns

The data sources implement several design patterns:

1. **Repository Pattern**: Data sources are part of the Repository pattern, serving as the actual data providers for repositories.

2. **Adapter Pattern**: Data sources adapt external data formats to the application's model format.

3. **Facade Pattern**: They provide a simplified interface to complex subsystems (like Firebase).

4. **Singleton Pattern**: Some data sources may be implemented as singletons to ensure consistent access to resources.

## Error Handling

Data sources use a consistent approach to error handling:

- They catch provider-specific exceptions
- They translate these exceptions into application-specific exceptions
- They include meaningful error messages and metadata

For example:

```dart
@override
Future<UserModel> getUserProfile(String userId) async {
  try {
    final userDoc = await firestore.collection('users').doc(userId).get();
    
    if (!userDoc.exists) {
      throw NotFoundException('User with ID $userId not found');
    }
    
    return UserModel.fromJson(userDoc.data()!);
  } on FirebaseException catch (e) {
    throw ServerException('Firebase error: ${e.message}');
  } catch (e) {
    throw ServerException('Failed to get user profile: ${e.toString()}');
  }
}
```

## Testing

Data sources should be tested in isolation:

- Use mocks for external dependencies (Firebase, SharedPreferences)
- Test success and failure scenarios
- Verify proper exception handling
- For integration testing, use Firebase emulators or test instances
