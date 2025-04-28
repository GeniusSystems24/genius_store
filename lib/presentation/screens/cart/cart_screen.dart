import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/core.dart';
import 'components/cart_item_card.dart';
import 'components/cart_summary_card.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  // Dummy data for preview
  final _dummyCartItems = [
    DummyCartItem(
      id: '1',
      productId: '1',
      name: 'Premium Wireless Headphones',
      price: 129.99,
      discount: 15.0,
      quantity: 1,
      color: 'Black',
      size: 'M',
      imageUrl: 'assets/images/products/headphones_1.png',
    ),
    DummyCartItem(
      id: '2',
      productId: '4',
      name: 'Bluetooth Speaker',
      price: 79.99,
      discount: 0.0,
      quantity: 2,
      color: 'Blue',
      size: 'Standard',
      imageUrl: 'assets/images/products/speaker.png',
    ),
    DummyCartItem(
      id: '3',
      productId: '9',
      name: 'Fitness Tracker',
      price: 89.99,
      discount: 5.0,
      quantity: 1,
      color: 'Red',
      size: 'S',
      imageUrl: 'assets/images/products/tracker.png',
    ),
  ];

  List<DummyCartItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(_dummyCartItems);
  }

  void _updateItemQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(itemId);
      return;
    }

    setState(() {
      final itemIndex = _cartItems.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        _cartItems[itemIndex] = _cartItems[itemIndex].copyWith(quantity: newQuantity);
      }
    });
  }

  void _removeItem(String itemId) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == itemId);
    });
  }

  double get _subtotal => _cartItems.fold(
        0,
        (sum, item) => sum + (item.price * (1 - item.discount / 100) * item.quantity),
      );

  double get _tax => _subtotal * 0.05; // 5% tax

  double get _shippingFee => _subtotal > 100 ? 0 : 10; // Free shipping over $100

  double get _total => _subtotal + _tax + _shippingFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cart (${_cartItems.length})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Cart'),
                    content: const Text('Are you sure you want to remove all items from your cart?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _cartItems.clear();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: _cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(),
      bottomNavigationBar: _cartItems.isEmpty ? null : _buildCheckoutBar(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Looks like you haven\'t added anything to your cart yet',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to home screen
              AppRouter.go(context, AppConstants.homeRoute);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        // Cart items list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              final item = _cartItems[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CartItemCard(
                  item: item,
                  onQuantityChanged: (newQuantity) {
                    _updateItemQuantity(item.id, newQuantity);
                  },
                  onRemove: () {
                    _removeItem(item.id);
                  },
                ),
              );
            },
          ),
        ),

        // Order summary
        CartSummaryCard(
          subtotal: _subtotal,
          tax: _tax,
          shippingFee: _shippingFee,
          total: _total,
        ),
      ],
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Total
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '\$${_total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            // Checkout button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to checkout
                  AppRouter.go(context, AppConstants.checkoutRoute);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Proceed to Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy model for preview only
class DummyCartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final double discount;
  final int quantity;
  final String color;
  final String size;
  final String imageUrl;

  DummyCartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.discount,
    required this.quantity,
    required this.color,
    required this.size,
    required this.imageUrl,
  });

  DummyCartItem copyWith({
    String? id,
    String? productId,
    String? name,
    double? price,
    double? discount,
    int? quantity,
    String? color,
    String? size,
    String? imageUrl,
  }) {
    return DummyCartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      quantity: quantity ?? this.quantity,
      color: color ?? this.color,
      size: size ?? this.size,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
