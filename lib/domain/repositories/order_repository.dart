import '../../data/models/models.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getUserOrders(String userId);

  Future<OrderModel> getOrderById(String orderId);

  Future<OrderModel> createOrder({
    required String userId,
    required String addressId,
    required List<CartItemModel> items,
    required double subtotal,
    required double shippingFee,
    double discount = 0,
    String? paymentMethodId,
    String? couponCode,
  });

  Future<void> updateOrderStatus(String orderId, String status);
}
