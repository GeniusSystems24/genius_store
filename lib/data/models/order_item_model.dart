import 'product_model.dart';
import 'product_variant_model.dart';

class OrderItemModel {
  final String id;
  final String orderId;
  final String productId;
  final String variantId;
  final int quantity;
  final double price;

  // للوصول السهل في واجهة المستخدم
  final ProductModel? product;
  final ProductVariantModel? variant;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.price,
    this.product,
    this.variant,
  });

  double get total => price * quantity;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      variantId: json['variant_id'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'variant_id': variantId,
      'quantity': quantity,
      'price': price,
    };
  }
}
