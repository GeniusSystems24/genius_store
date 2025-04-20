import 'package:equatable/equatable.dart';

/// كيان صورة المنتج في طبقة الأعمال المنطقية
class ProductImage extends Equatable {
  final String id;
  final String productId;
  final String? colorId;
  final String url;
  final int sortOrder;

  const ProductImage({
    required this.id,
    required this.productId,
    this.colorId,
    required this.url,
    required this.sortOrder,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        colorId,
        url,
        sortOrder,
      ];
}
