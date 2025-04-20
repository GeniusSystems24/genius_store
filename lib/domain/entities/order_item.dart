import 'package:equatable/equatable.dart';
import 'product.dart';
import 'product_variant.dart';

/// كيان عنصر الطلب في طبقة الأعمال المنطقية
class OrderItem extends Equatable {
  final String id;
  final String orderId;
  final String productId;
  final String variantId;
  final int quantity;
  final double price;

  // للوصول السهل في واجهة المستخدم
  final Product? product;
  final ProductVariant? variant;

  const OrderItem({
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

  @override
  List<Object?> get props => [
        id,
        orderId,
        productId,
        variantId,
        quantity,
        price,
        product,
        variant,
      ];
}
