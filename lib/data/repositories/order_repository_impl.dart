import '../../domain/repositories/order_repository.dart';
import '../datasources/datasources.dart';
import '../models/models.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirestoreOrderDataSource _orderDataSource;
  final FirestoreProductDataSource _productDataSource;

  OrderRepositoryImpl({
    required FirestoreOrderDataSource orderDataSource,
    required FirestoreProductDataSource productDataSource,
  })  : _orderDataSource = orderDataSource,
        _productDataSource = productDataSource;

  @override
  Future<List<OrderModel>> getUserOrders(String userId) async {
    final orders = await _orderDataSource.getUserOrders(userId);

    // Load product details for order items
    final populatedOrders = <OrderModel>[];

    for (final order in orders) {
      populatedOrders.add(await _populateOrderWithProductDetails(order));
    }

    return populatedOrders;
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    final order = await _orderDataSource.getOrderById(orderId);
    return _populateOrderWithProductDetails(order);
  }

  Future<OrderModel> _populateOrderWithProductDetails(OrderModel order) async {
    if (order.items == null || order.items!.isEmpty) return order;

    final updatedItems = <OrderItemModel>[];

    for (final item in order.items!) {
      try {
        // Get product and variant details
        final product = await _productDataSource.getProductById(item.productId);
        final variant = await _productDataSource.getProductVariantById(item.variantId);

        // Create updated order item with product and variant details
        updatedItems.add(OrderItemModel(
          id: item.id,
          orderId: item.orderId,
          productId: item.productId,
          variantId: item.variantId,
          quantity: item.quantity,
          price: item.price,
          product: product,
          variant: variant,
        ));
      } catch (e) {
        // If we can't load product details, keep the original item
        updatedItems.add(item);
      }
    }

    // Return order with updated items
    return OrderModel(
      id: order.id,
      userId: order.userId,
      addressId: order.addressId,
      paymentMethodId: order.paymentMethodId,
      status: order.status,
      subtotal: order.subtotal,
      shippingFee: order.shippingFee,
      discount: order.discount,
      total: order.total,
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
      couponCode: order.couponCode,
      items: updatedItems,
    );
  }

  @override
  Future<OrderModel> createOrder({
    required String userId,
    required String addressId,
    required List<CartItemModel> items,
    required double subtotal,
    required double shippingFee,
    double discount = 0,
    String? paymentMethodId,
    String? couponCode,
  }) async {
    // Calculate total
    final total = subtotal + shippingFee - discount;

    // Create order with initial status
    final orderModel = OrderModel(
      id: '', // Will be set by Firestore
      userId: userId,
      addressId: addressId,
      paymentMethodId: paymentMethodId,
      status: 'pending_payment', // Initial status
      subtotal: subtotal,
      shippingFee: shippingFee,
      discount: discount,
      total: total,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      couponCode: couponCode,
    );

    // Convert cart items to order items
    final orderItems = items
        .map((cartItem) => OrderItemModel(
              id: '', // Will be set by Firestore
              orderId: '', // Will be set by Firestore
              productId: cartItem.productId,
              variantId: cartItem.variantId,
              quantity: cartItem.quantity,
              price: cartItem.price,
            ))
        .toList();

    // Create order in Firestore and return the result
    return _orderDataSource.createOrder(orderModel, orderItems);
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _orderDataSource.updateOrderStatus(orderId, status);
  }
}
