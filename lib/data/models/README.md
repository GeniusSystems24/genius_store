# Data Models

The models directory contains data transfer objects (DTOs) used to serialize and deserialize data when communicating with external services and local storage in the Genius Store application.

## Purpose

Data models:

- Provide structured representations of data from external sources
- Handle serialization/deserialization (JSON conversion)
- Validate incoming data
- Map between external data formats and internal structures
- Serve as intermediaries between data sources and domain entities

## Key Concepts

### Models vs. Entities

- **Models** (in the Data layer) represent data as it exists in data sources (Firestore, local storage, etc.)
- **Entities** (in the Domain layer) represent business objects with business logic

The separation allows the domain layer to remain independent of data source details.

## Model Structure

A typical model includes:

- Fields corresponding to data from the source
- Serialization methods (toJson)
- Deserialization constructors (fromJson)
- Optional validation logic

Example:

```dart
class ProductModel {
  final String id;
  final Map<String, String> nameLocalized;
  final Map<String, String> descriptionLocalized;
  final double basePrice;
  final String brand;
  final String categoryId;
  final bool isFeatured;
  final bool isActive;
  final DateTime createdAt;
  final List<String> tags;
  final double averageRating;

  ProductModel({
    required this.id,
    required this.nameLocalized,
    required this.descriptionLocalized,
    required this.basePrice,
    required this.brand,
    required this.categoryId,
    required this.isFeatured,
    required this.isActive,
    required this.createdAt,
    required this.tags,
    required this.averageRating,
  });

  // Constructor for creating a model from an entity
  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      nameLocalized: entity.nameLocalized,
      descriptionLocalized: entity.descriptionLocalized,
      basePrice: entity.basePrice,
      brand: entity.brand,
      categoryId: entity.categoryId,
      isFeatured: entity.isFeatured,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      tags: entity.tags,
      averageRating: entity.averageRating,
    );
  }

  // Create an entity from this model
  Product toEntity() {
    return Product(
      id: id,
      nameLocalized: nameLocalized,
      descriptionLocalized: descriptionLocalized,
      basePrice: basePrice,
      brand: brand,
      categoryId: categoryId,
      isFeatured: isFeatured,
      isActive: isActive,
      createdAt: createdAt,
      tags: tags,
      averageRating: averageRating,
    );
  }

  // Create a model from a JSON map
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      nameLocalized: Map<String, String>.from(json['name_localized']),
      descriptionLocalized: Map<String, String>.from(json['description_localized']),
      basePrice: json['base_price'].toDouble(),
      brand: json['brand'],
      categoryId: json['category_id'],
      isFeatured: json['is_featured'],
      isActive: json['is_active'],
      createdAt: (json['created_at'] as Timestamp).toDate(),
      tags: List<String>.from(json['tags']),
      averageRating: json['average_rating'].toDouble(),
    );
  }

  // Convert model to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_localized': nameLocalized,
      'description_localized': descriptionLocalized,
      'base_price': basePrice,
      'brand': brand,
      'category_id': categoryId,
      'is_featured': isFeatured,
      'is_active': isActive,
      'created_at': Timestamp.fromDate(createdAt),
      'tags': tags,
      'average_rating': averageRating,
    };
  }
}
```

## Available Models

The application includes models for:

- **User-related**: `UserModel`, `AddressModel`, `PaymentMethodModel`
- **Product-related**: `ProductModel`, `ProductVariantModel`, `CategoryModel`
- **Shopping-related**: `CartModel`, `CartItemModel`
- **Order-related**: `OrderModel`, `OrderItemModel`
- **Support models**: `ColorModel`, `SizeModel`, `ImageModel`

## Design Patterns

The models implement several design patterns:

1. **Data Transfer Object (DTO) Pattern**: Models serve as DTOs between the data layer and domain layer.

2. **Factory Pattern**: The `fromJson` and `fromEntity` factory constructors create models from different sources.

3. **Adapter Pattern**: Models adapt between the external data representation and the internal entity representation.

## Validation

Models can include validation logic to ensure data integrity:

```dart
factory UserModel.fromJson(Map<String, dynamic> json) {
  // Validate required fields
  if (!json.containsKey('uid') || json['uid'] == null) {
    throw FormatException('Missing required field: uid');
  }
  
  // Process and return the model
  return UserModel(
    uid: json['uid'],
    email: json['email'],
    // ...other fields
  );
}
```

## Testing

Models should be thoroughly tested for:

- Proper serialization to JSON
- Proper deserialization from JSON
- Correct conversion to/from domain entities
- Handling of edge cases (null values, missing fields)
- Validation logic
