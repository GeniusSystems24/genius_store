import 'package:equatable/equatable.dart';
import 'product.dart';
import 'product_variant.dart';

/// كيان عنصر السلة في طبقة الأعمال المنطقية
class CartItem extends Equatable {
  final String id;
  final String cartId;
  final String productId;
  final String variantId;
  final int quantity;
  final double price;

  // للوصول السهل في واجهة المستخدم
  final Product? product;
  final ProductVariant? variant;

  const CartItem({
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

  @override
  List<Object?> get props => [
        id,
        cartId,
        productId,
        variantId,
        quantity,
        price,
        product,
        variant,
      ];
}
