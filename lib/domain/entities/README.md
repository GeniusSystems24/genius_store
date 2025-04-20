# Domain Entities

[![Arabic](https://img.shields.io/badge/Language-Arabic-blueviolet?style=for-the-badge)](README-ar.md)

This directory contains the core business entities for the Genius Store application. These entities represent the fundamental business objects that encapsulate the most essential business rules.

## Purpose

Domain entities:

- Define the core data structures of the business domain
- Encapsulate business rules and validation logic
- Represent the application's business concepts
- Remain independent of how data is stored or displayed
- Provide a common language between developers and domain experts

## Key Characteristics

Entities in the Domain layer have several important characteristics:

1. **Framework Independence**: They don't depend on any external framework
2. **Business Focus**: They represent business concepts, not data structures
3. **Validation Logic**: They include validation of business rules
4. **Immutability**: They are typically immutable to prevent unexpected state changes
5. **No External Dependencies**: They depend only on other domain entities and basic Dart types

## Core Entities

### User

`User` represents a customer of the store:

```dart
class User {
  final String uid;
  final String email;
  final String name;
  final String? phone;
  final DateTime createdAt;
  final DateTime lastLogin;
  final String? profileImage;

  User({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    required this.createdAt,
    required this.lastLogin,
    this.profileImage,
  });
  
  // Business logic methods
  bool get isVerified => email.isNotEmpty;
  
  // Validation logic
  bool hasValidContactInfo() {
    return email.isNotEmpty || (phone != null && phone!.isNotEmpty);
  }
}
```

### Product

`Product` represents items available for purchase:

```dart
class Product {
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
  final List<ProductVariant>? variants;
  final List<ProductImage>? images;

  Product({
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
    this.variants,
    this.images,
  });

  // Business methods
  String getName(String languageCode) {
    return nameLocalized[languageCode] ?? nameLocalized['en'] ?? '';
  }

  String getDescription(String languageCode) {
    return descriptionLocalized[languageCode] 
        ?? descriptionLocalized['en'] 
        ?? '';
  }
  
  // Business rules
  bool get isAvailable => isActive && hasAvailableVariants();
  
  bool hasAvailableVariants() {
    if (variants == null || variants!.isEmpty) return false;
    return variants!.any((variant) => variant.isInStock);
  }
  
  double get lowestPrice {
    if (variants == null || variants!.isEmpty) return basePrice;
    return variants!.map((v) => v.price).reduce((a, b) => a < b ? a : b);
  }
}
```

### Cart

`Cart` represents a collection of items selected for purchase:

```dart
class Cart {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.items,
  });

  // Business calculations
  double get subtotal {
    if (items.isEmpty) return 0;
    return items.fold(0, (sum, item) => sum + item.total);
  }
  
  // Business methods
  Cart addItem(CartItem item) {
    final existingItemIndex = items.indexWhere(
      (i) => i.productId == item.productId && i.variantId == item.variantId
    );
    
    if (existingItemIndex >= 0) {
      // Update quantity if item already exists
      final updatedItems = List<CartItem>.from(items);
      final existingItem = items[existingItemIndex];
      updatedItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity
      );
      
      return copyWith(items: updatedItems, updatedAt: DateTime.now());
    } else {
      // Add new item
      return copyWith(
        items: [...items, item],
        updatedAt: DateTime.now(),
      );
    }
  }
  
  // Create a copy with updated fields
  Cart copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    List<CartItem>? items,
  }) {
    return Cart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      items: items ?? this.items,
    );
  }
}
```

## Other Entities

The domain layer includes other entities such as:

- **Order**: Represents a completed purchase
- **Address**: Represents shipping or billing address
- **Category**: Represents product groupings
- **Payment**: Represents payment information

## Differences from Data Models

Domain entities differ from data models in several ways:

1. **Focus**: Entities focus on business concepts and rules, models focus on data representation
2. **Dependencies**: Entities have no external dependencies, models may depend on data source specifics
3. **Serialization**: Entities don't handle serialization, models do
4. **Validation**: Entities contain business validation, models contain format validation

## Testing

Domain entities should be thoroughly tested:

- Business logic methods
- Validation rules
- State manipulation methods
- Edge cases

Since entities contain important business rules, their tests serve as documentation of the business requirements.
