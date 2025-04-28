import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  bool _isLoading = true;

  // For demo purposes - in a real app this would come from a provider
  late final OrderDetails _orderDetails;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Create dummy order details
    _orderDetails = OrderDetails(
      id: widget.orderId,
      orderNumber: '10045987',
      date: 'July 12, 2023',
      status: 'Processing',
      statusColor: Colors.blue,
      paymentMethod: 'Credit Card (**** 1234)',
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
      shippingAddress: Address(
        name: 'John Doe',
        line1: '123 Main Street, Apt 4B',
        line2: '',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'United States',
        phone: '+1 (555) 123-4567',
      ),
      billingAddress: Address(
        name: 'John Doe',
        line1: '123 Main Street, Apt 4B',
        line2: '',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'United States',
        phone: '+1 (555) 123-4567',
      ),
      trackingInfo: TrackingInfo(
        carrier: 'FedEx',
        trackingNumber: '1234567890',
        estimatedDelivery: 'July 15, 2023',
        status: 'In Transit',
        statusPoints: [
          StatusPoint(
            title: 'Order Placed',
            date: 'July 12, 2023',
            time: '10:30 AM',
            isCompleted: true,
          ),
          StatusPoint(
            title: 'Processing',
            date: 'July 12, 2023',
            time: '2:45 PM',
            isCompleted: true,
          ),
          StatusPoint(
            title: 'Shipped',
            date: 'July 13, 2023',
            time: '9:15 AM',
            isCompleted: true,
          ),
          StatusPoint(
            title: 'Out for Delivery',
            date: 'July 15, 2023',
            time: 'Expected',
            isCompleted: false,
          ),
          StatusPoint(
            title: 'Delivered',
            date: 'July 15, 2023',
            time: 'Expected',
            isCompleted: false,
          ),
        ],
      ),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog
              _showHelpDialog(context);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Header
                  _buildOrderHeader(context),

                  const SizedBox(height: 24),

                  // Order Items
                  _buildSectionTitle(context, 'Items Ordered'),
                  const SizedBox(height: 12),
                  _buildOrderItems(context),

                  const SizedBox(height: 24),

                  // Order Summary
                  _buildSectionTitle(context, 'Order Summary'),
                  const SizedBox(height: 12),
                  _buildOrderSummary(context),

                  const SizedBox(height: 24),

                  // Shipping Information
                  _buildSectionTitle(context, 'Shipping Information'),
                  const SizedBox(height: 12),
                  _buildAddressCard(
                    context,
                    _orderDetails.shippingAddress,
                    showTitle: false,
                  ),

                  const SizedBox(height: 24),

                  // Billing Information
                  _buildSectionTitle(context, 'Billing Information'),
                  const SizedBox(height: 12),
                  _buildBillingInfo(context),

                  const SizedBox(height: 24),

                  // Tracking Information
                  _buildSectionTitle(context, 'Tracking Information'),
                  const SizedBox(height: 12),
                  _buildTrackingInfo(context),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Handle track shipment
                          },
                          icon: const Icon(Icons.local_shipping),
                          label: const Text('Track Shipment'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Handle contact support
                          },
                          icon: const Icon(Icons.headset_mic),
                          label: const Text('Contact Support'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildOrderHeader(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${_orderDetails.orderNumber}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Placed on ${_orderDetails.date}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _orderDetails.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _orderDetails.status,
                    style: TextStyle(
                      color: _orderDetails.statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.payment, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Payment Method: ${_orderDetails.paymentMethod}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildOrderItems(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...List.generate(
              _orderDetails.items.length,
              (index) => Column(
                children: [
                  _buildOrderItem(context, _orderDetails.items[index]),
                  if (index < _orderDetails.items.length - 1) const Divider(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            item.imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(width: 16),

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
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Qty: ${item.quantity}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Optional action buttons
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle buy again
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Buy Again'),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      // Handle write review
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Write Review'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow(context, 'Subtotal', '\$${_orderDetails.subtotal.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildSummaryRow(context, 'Shipping', '\$${_orderDetails.shipping.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildSummaryRow(context, 'Tax', '\$${_orderDetails.tax.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildSummaryRow(
              context,
              'Discount',
              '-\$${_orderDetails.discount.toStringAsFixed(2)}',
              valueColor: Colors.green,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              context,
              'Total',
              '\$${_orderDetails.total.toStringAsFixed(2)}',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null,
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: isBold ? FontWeight.bold : null,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(BuildContext context, Address address, {bool showTitle = true}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle) ...[
              Text(
                'Shipping Address',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              address.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(address.line1),
            if (address.line2.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(address.line2),
            ],
            const SizedBox(height: 2),
            Text('${address.city}, ${address.state} ${address.zipCode}'),
            const SizedBox(height: 2),
            Text(address.country),
            const SizedBox(height: 4),
            Text(
              address.phone,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingInfo(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.credit_card, size: 20),
                const SizedBox(width: 8),
                Text(
                  _orderDetails.paymentMethod,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Billing Address',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(_orderDetails.billingAddress.name),
            const SizedBox(height: 2),
            Text(_orderDetails.billingAddress.line1),
            if (_orderDetails.billingAddress.line2.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(_orderDetails.billingAddress.line2),
            ],
            const SizedBox(height: 2),
            Text(
              '${_orderDetails.billingAddress.city}, ${_orderDetails.billingAddress.state} ${_orderDetails.billingAddress.zipCode}',
            ),
            const SizedBox(height: 2),
            Text(_orderDetails.billingAddress.country),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingInfo(BuildContext context) {
    final trackingInfo = _orderDetails.trackingInfo;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_shipping, size: 20),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${trackingInfo.carrier} - ${trackingInfo.status}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tracking Number: ${trackingInfo.trackingNumber}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Estimated Delivery: ${trackingInfo.estimatedDelivery}',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 24),

            // Tracking Timeline
            ...List.generate(
              trackingInfo.statusPoints.length,
              (index) => _buildTrackingPoint(
                context,
                trackingInfo.statusPoints[index],
                isFirst: index == 0,
                isLast: index == trackingInfo.statusPoints.length - 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingPoint(BuildContext context, StatusPoint point, {required bool isFirst, required bool isLast}) {
    final Color dotColor = point.isCompleted ? Colors.green : Colors.grey.shade400;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline dot and line
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: point.isCompleted ? Colors.green : Colors.grey.shade300,
              ),
          ],
        ),

        const SizedBox(width: 12),

        // Status information
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                point.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: point.isCompleted ? Colors.black : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${point.date} ${point.time}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: isLast ? 0 : 24),
            ],
          ),
        ),
      ],
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Need Help?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem(
              context,
              'Order Issues',
              'For problems with your order, contact our customer service team.',
              Icons.report_problem_outlined,
            ),
            const SizedBox(height: 16),
            _buildHelpItem(
              context,
              'Returns & Refunds',
              'To return an item or request a refund, please use our returns portal.',
              Icons.assignment_return_outlined,
            ),
            const SizedBox(height: 16),
            _buildHelpItem(
              context,
              'Shipping Questions',
              'For questions about shipping or tracking, please check our shipping policy.',
              Icons.local_shipping_outlined,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to customer support
            },
            child: const Text('Contact Support'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Models for order details
class OrderDetails {
  final String id;
  final String orderNumber;
  final String date;
  final String status;
  final Color statusColor;
  final String paymentMethod;
  final List<OrderItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double discount;
  final double total;
  final Address shippingAddress;
  final Address billingAddress;
  final TrackingInfo trackingInfo;

  OrderDetails({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.paymentMethod,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.discount,
    required this.total,
    required this.shippingAddress,
    required this.billingAddress,
    required this.trackingInfo,
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

class Address {
  final String name;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String phone;

  Address({
    required this.name,
    required this.line1,
    this.line2 = '',
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.phone,
  });
}

class TrackingInfo {
  final String carrier;
  final String trackingNumber;
  final String estimatedDelivery;
  final String status;
  final List<StatusPoint> statusPoints;

  TrackingInfo({
    required this.carrier,
    required this.trackingNumber,
    required this.estimatedDelivery,
    required this.status,
    required this.statusPoints,
  });
}

class StatusPoint {
  final String title;
  final String date;
  final String time;
  final bool isCompleted;

  StatusPoint({
    required this.title,
    required this.date,
    required this.time,
    required this.isCompleted,
  });
}
