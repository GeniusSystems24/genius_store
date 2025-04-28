import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/core.dart';

class OrderConfirmationScreen extends ConsumerWidget {
  final String orderId;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For demo purposes - in a real app this would come from a provider
    final orderDetails = _getDummyOrderDetails();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmed'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Success Icon and Message
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Order Confirmed!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your order has been placed successfully',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Order ID: #${orderDetails.orderId}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Order Summary Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Order Items
                    ...List.generate(
                      orderDetails.items.length,
                      (index) => _buildOrderItem(context, orderDetails.items[index]),
                    ),

                    const Divider(height: 32),

                    // Order Totals
                    _buildOrderTotalRow(context, 'Subtotal', '\$${orderDetails.subtotal.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    _buildOrderTotalRow(context, 'Shipping', '\$${orderDetails.shipping.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    _buildOrderTotalRow(context, 'Tax', '\$${orderDetails.tax.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    _buildOrderTotalRow(
                      context,
                      'Discount',
                      '-\$${orderDetails.discount.toStringAsFixed(2)}',
                      isDiscount: true,
                    ),

                    const Divider(height: 32),

                    // Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '\$${orderDetails.total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Shipping Information Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shipping Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    _buildInfoRow(
                      context,
                      'Name',
                      orderDetails.shippingInfo.name,
                    ),
                    const SizedBox(height: 8),

                    // Address
                    _buildInfoRow(
                      context,
                      'Address',
                      orderDetails.shippingInfo.address,
                    ),
                    const SizedBox(height: 8),

                    // City, State Zip
                    _buildInfoRow(
                      context,
                      'City',
                      '${orderDetails.shippingInfo.city}, ${orderDetails.shippingInfo.state} ${orderDetails.shippingInfo.zipCode}',
                    ),
                    const SizedBox(height: 8),

                    // Phone
                    _buildInfoRow(
                      context,
                      'Phone',
                      orderDetails.shippingInfo.phone,
                    ),
                    const SizedBox(height: 8),

                    // Shipping Method
                    _buildInfoRow(
                      context,
                      'Shipping Method',
                      orderDetails.shippingInfo.method,
                    ),
                    const SizedBox(height: 8),

                    // Estimated Delivery
                    _buildInfoRow(
                      context,
                      'Estimated Delivery',
                      orderDetails.shippingInfo.estimatedDelivery,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to order details
                      AppRouter.go(context, '${AppConstants.ordersCollection}/${orderDetails.orderId}');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View Order Details'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate back to home
                      AppRouter.replace(context, AppConstants.homeRoute);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Continue Shopping'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Color: ${item.color}, Size: ${item.size}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          ),

          // Price and Quantity
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Qty: ${item.quantity}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTotalRow(BuildContext context, String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: isDiscount ? const TextStyle(color: Colors.green) : null,
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // Dummy data for demo purposes
  OrderConfirmationDetails _getDummyOrderDetails() {
    return OrderConfirmationDetails(
      orderId: orderId,
      items: [
        OrderItem(
          id: '1',
          name: 'Premium Wireless Headphones',
          price: 110.49,
          quantity: 1,
          color: 'Black',
          size: 'One Size',
          imageUrl: 'assets/images/products/headphones_1.png',
        ),
        OrderItem(
          id: '2',
          name: 'Smart Watch Pro',
          price: 249.99,
          quantity: 1,
          color: 'Silver',
          size: 'One Size',
          imageUrl: 'assets/images/products/watch_1.png',
        ),
      ],
      subtotal: 360.48,
      shipping: 9.99,
      tax: 21.63,
      discount: 36.05,
      total: 356.05,
      shippingInfo: ShippingInfo(
        name: 'John Doe',
        address: '123 Main Street, Apt 4B',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        phone: '+1 (555) 123-4567',
        method: 'Express Shipping (2-3 days)',
        estimatedDelivery: 'July 15, 2023',
      ),
    );
  }
}

// Models for order confirmation
class OrderConfirmationDetails {
  final String orderId;
  final List<OrderItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double discount;
  final double total;
  final ShippingInfo shippingInfo;

  OrderConfirmationDetails({
    required this.orderId,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.discount,
    required this.total,
    required this.shippingInfo,
  });
}

class OrderItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String color;
  final String size;
  final String imageUrl;

  OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.color,
    required this.size,
    required this.imageUrl,
  });
}

class ShippingInfo {
  final String name;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String phone;
  final String method;
  final String estimatedDelivery;

  ShippingInfo({
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.phone,
    required this.method,
    required this.estimatedDelivery,
  });
}
