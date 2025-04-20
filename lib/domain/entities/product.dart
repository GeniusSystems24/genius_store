import 'package:equatable/equatable.dart';
import 'product_variant.dart';
import 'product_image.dart';

/// كيان المنتج في طبقة الأعمال المنطقية
class Product extends Equatable {
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

  const Product({
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

  String getName(String languageCode) {
    return nameLocalized[languageCode] ?? nameLocalized['en'] ?? '';
  }

  String getDescription(String languageCode) {
    return descriptionLocalized[languageCode] ?? descriptionLocalized['en'] ?? '';
  }

  ProductImage? getMainImage() {
    if (images == null || images!.isEmpty) return null;
    // Sort by sortOrder and return the first
    return images!.reduce(
      (prev, image) => image.sortOrder < prev.sortOrder ? image : prev,
    );
  }

  List<ProductImage> getImagesForColor(String colorId) {
    if (images == null) return [];
    final colorImages = images!.where((image) => image.colorId == colorId).toList();
    colorImages.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return colorImages;
  }

  @override
  List<Object?> get props => [
        id,
        nameLocalized,
        descriptionLocalized,
        basePrice,
        brand,
        categoryId,
        isFeatured,
        isActive,
        createdAt,
        tags,
        averageRating,
        variants,
        images,
      ];
}
