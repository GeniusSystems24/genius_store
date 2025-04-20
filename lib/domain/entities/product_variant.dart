import 'package:equatable/equatable.dart';
import 'color.dart';
import 'size.dart';

/// كيان متغير المنتج في طبقة الأعمال المنطقية
class ProductVariant extends Equatable {
  final String id;
  final String productId;
  final String colorId;
  final String sizeId;
  final double price;
  final int stockQuantity;
  final String sku;

  // للوصول أسهل في واجهة المستخدم
  final Color? color;
  final Size? size;

  const ProductVariant({
    required this.id,
    required this.productId,
    required this.colorId,
    required this.sizeId,
    required this.price,
    required this.stockQuantity,
    required this.sku,
    this.color,
    this.size,
  });

  bool get isInStock => stockQuantity > 0;

  @override
  List<Object?> get props => [
        id,
        productId,
        colorId,
        sizeId,
        price,
        stockQuantity,
        sku,
        color,
        size,
      ];
}
