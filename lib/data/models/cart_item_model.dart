import 'product_model.dart';
import 'product_variant_model.dart';

class CartItemModel {
  final String id;
  final String cartId;
  final String productId;
  final String variantId;
  final int quantity;
  final double price;

  // للوصول السهل في واجهة المستخدم
  final ProductModel? product;
  final ProductVariantModel? variant;

  CartItemModel({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.price,
    this.product,
    this.variant,
  });

  double get total => price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      cartId: json['cart_id'],
      productId: json['product_id'],
      variantId: json['variant_id'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'product_id': productId,
      'variant_id': variantId,
      'quantity': quantity,
      'price': price,
    };
  }
}
