import 'package:equatable/equatable.dart';
import 'order_item.dart';

/// كيان الطلب في طبقة الأعمال المنطقية
class Order extends Equatable {
  final String id;
  final String userId;
  final String addressId;
  final String? paymentMethodId;
  final String status;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? couponCode;
  final List<OrderItem>? items;

  const Order({
    required this.id,
    required this.userId,
    required this.addressId,
    this.paymentMethodId,
    required this.status,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    this.couponCode,
    this.items,
  });

  bool get isPaid => status != 'pending_payment' && status != 'payment_failed';

  bool get isCompleted => status == 'delivered' || status == 'canceled';

  int get itemCount {
    if (items == null) return 0;
    return items!.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        addressId,
        paymentMethodId,
        status,
        subtotal,
        shippingFee,
        discount,
        total,
        createdAt,
        updatedAt,
        couponCode,
        items,
      ];
}
