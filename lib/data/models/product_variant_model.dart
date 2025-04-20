import 'color_model.dart';
import 'size_model.dart';

class ProductVariantModel {
  final String id;
  final String productId;
  final String colorId;
  final String sizeId;
  final double price;
  final int stockQuantity;
  final String sku;

  // للوصول أسهل في واجهة المستخدم
  final ColorModel? color;
  final SizeModel? size;

  ProductVariantModel({
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

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'],
      productId: json['product_id'],
      colorId: json['color_id'],
      sizeId: json['size_id'],
      price: json['price'].toDouble(),
      stockQuantity: json['stock_quantity'],
      sku: json['sku'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'color_id': colorId,
      'size_id': sizeId,
      'price': price,
      'stock_quantity': stockQuantity,
      'sku': sku,
    };
  }
}
