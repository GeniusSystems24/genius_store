import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/models.dart';

abstract class FirestoreOrderDataSource {
  Future<List<OrderModel>> getUserOrders(String userId);

  Future<OrderModel> getOrderById(String orderId);

  Future<OrderModel> createOrder(OrderModel order, List<OrderItemModel> items);

  Future<void> updateOrderStatus(String orderId, String status);

  Future<List<OrderItemModel>> getOrderItems(String orderId);
}

class FirestoreOrderDataSourceImpl implements FirestoreOrderDataSource {
  final FirebaseFirestore _firestore;

  FirestoreOrderDataSourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<OrderModel>> getUserOrders(String userId) async {
    final querySnapshot =
        await _firestore.collection('orders').where('user_id', isEqualTo: userId).orderBy('created_at', descending: true).get();

    final orders = querySnapshot.docs
        .map((doc) => OrderModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();

    // Load items for each order
    for (var i = 0; i < orders.length; i++) {
      final items = await getOrderItems(orders[i].id);
      orders[i] = _attachItemsToOrder(orders[i], items);
    }

    return orders;
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();

    if (!doc.exists) {
      throw Exception('Order not found');
    }

    // Create the basic order
    final order = OrderModel.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });

    // Get order items
    final items = await getOrderItems(orderId);

    // Return order with items
    return _attachItemsToOrder(order, items);
  }

  OrderModel _attachItemsToOrder(OrderModel order, List<OrderItemModel> items) {
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
      items: items,
    );
  }

  @override
  Future<OrderModel> createOrder(OrderModel order, List<OrderItemModel> items) async {
    // Use a transaction to ensure all operations succeed or fail together
    return _firestore.runTransaction<OrderModel>((transaction) async {
      // Generate a timestamp
      final now = DateTime.now();

      // Prepare order data
      final orderData = {
        ...order.toJson(),
        'created_at': Timestamp.fromDate(now),
        'updated_at': Timestamp.fromDate(now),
      };

      // Create new order document reference
      final orderRef = _firestore.collection('orders').doc();

      // Add order to transaction
      transaction.set(orderRef, orderData);

      // Add order items to transaction
      for (final item in items) {
        final itemData = {
          ...item.toJson(),
          'order_id': orderRef.id,
        };

        final itemRef = _firestore.collection('order_items').doc();
        transaction.set(itemRef, itemData);
      }

      // Return the created order with ID and timestamps
      return OrderModel.fromJson({
        'id': orderRef.id,
        ...orderData,
      }).copyWith(items: items);
    });
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    // Update status and timestamp
    await _firestore.collection('orders').doc(orderId).update({
      'status': status,
      'updated_at': Timestamp.fromDate(DateTime.now()),
    });
  }

  @override
  Future<List<OrderItemModel>> getOrderItems(String orderId) async {
    final querySnapshot = await _firestore.collection('order_items').where('order_id', isEqualTo: orderId).get();

    return querySnapshot.docs
        .map((doc) => OrderItemModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            }))
        .toList();
  }
}

extension OrderModelExtension on OrderModel {
  OrderModel copyWith({
    String? id,
    String? userId,
    String? addressId,
    String? paymentMethodId,
    String? status,
    double? subtotal,
    double? shippingFee,
    double? discount,
    double? total,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? couponCode,
    List<OrderItemModel>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      addressId: addressId ?? this.addressId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      shippingFee: shippingFee ?? this.shippingFee,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      couponCode: couponCode ?? this.couponCode,
      items: items ?? this.items,
    );
  }
}
