import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import 'components/address_card.dart';
import 'components/checkout_summary_card.dart';
import 'components/payment_method_card.dart';
import 'components/shipping_method_card.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  int _selectedAddressIndex = 0;
  int _selectedPaymentMethodIndex = 0;
  int _selectedShippingMethodIndex = 0;
  bool _isPlacingOrder = false;
  String? _appliedCoupon;

  // Dummy data for preview
  final _dummyAddresses = [
    DummyAddress(
      id: '1',
      name: 'Home',
      recipient: 'John Doe',
      addressLine1: '123 Main Street',
      addressLine2: 'Apt 4B',
      city: 'New York',
      state: 'NY',
      postalCode: '10001',
      country: 'United States',
      phoneNumber: '+1 (555) 123-4567',
      isDefault: true,
    ),
    DummyAddress(
      id: '2',
      name: 'Office',
      recipient: 'John Doe',
      addressLine1: '456 Business Ave',
      addressLine2: 'Floor 12',
      city: 'Boston',
      state: 'MA',
      postalCode: '02108',
      country: 'United States',
      phoneNumber: '+1 (555) 987-6543',
      isDefault: false,
    ),
  ];

  final _dummyPaymentMethods = [
    DummyPaymentMethod(
      id: '1',
      type: 'Credit Card',
      name: 'Visa ending in 1234',
      icon: Icons.credit_card,
      isDefault: true,
    ),
    DummyPaymentMethod(
      id: '2',
      type: 'PayPal',
      name: 'johndoe@example.com',
      icon: Icons.payment,
      isDefault: false,
    ),
  ];

  final _dummyShippingMethods = [
    DummyShippingMethod(
      id: '1',
      name: 'Standard Shipping',
      price: 5.99,
      deliveryTime: '3-5 business days',
    ),
    DummyShippingMethod(
      id: '2',
      name: 'Express Shipping',
      price: 12.99,
      deliveryTime: '1-2 business days',
    ),
    DummyShippingMethod(
      id: '3',
      name: 'Same Day Delivery',
      price: 19.99,
      deliveryTime: 'Today, before 8PM',
    ),
  ];

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
  ];

  double get subtotal => _dummyCartItems.fold(
        0,
        (sum, item) => sum + (item.price * (1 - item.discount / 100) * item.quantity),
      );

  double get tax => subtotal * 0.05; // 5% tax

  double get shipping => _dummyShippingMethods[_selectedShippingMethodIndex].price;

  double get discount => _appliedCoupon != null ? 10.0 : 0.0; // Example discount

  double get total => subtotal + tax + shipping - discount;

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _placeOrder() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isPlacingOrder = true;
    });

    // Simulate order processing
    Future.delayed(const Duration(seconds: 2), () {
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Order Placed Successfully!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Your order has been placed and will be processed shortly.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Order Total: \$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigate to home and clear the stack
                AppRouter.replace(context, AppConstants.homeRoute);
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _nextStep,
          onStepCancel: _previousStep,
          controlsBuilder: (context, details) {
            return const SizedBox.shrink(); // We'll use our own controls
          },
          steps: [
            // Step 1: Shipping Address
            Step(
              title: const Text('Shipping Address'),
              content: Column(
                children: [
                  for (int i = 0; i < _dummyAddresses.length; i++)
                    AddressCard(
                      address: _dummyAddresses[i],
                      isSelected: i == _selectedAddressIndex,
                      onSelect: () {
                        setState(() {
                          _selectedAddressIndex = i;
                        });
                      },
                      onEdit: () {
                        // Navigate to edit address screen
                      },
                    ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to add new address screen
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Address'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousStep,
                          child: const Text('Back'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _nextStep,
                          child: const Text('Continue'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),

            // Step 2: Shipping Method
            Step(
              title: const Text('Shipping Method'),
              content: Column(
                children: [
                  for (int i = 0; i < _dummyShippingMethods.length; i++)
                    ShippingMethodCard(
                      shippingMethod: _dummyShippingMethods[i],
                      isSelected: i == _selectedShippingMethodIndex,
                      onSelect: () {
                        setState(() {
                          _selectedShippingMethodIndex = i;
                        });
                      },
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousStep,
                          child: const Text('Back'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _nextStep,
                          child: const Text('Continue'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),

            // Step 3: Payment Method
            Step(
              title: const Text('Payment Method'),
              content: Column(
                children: [
                  for (int i = 0; i < _dummyPaymentMethods.length; i++)
                    PaymentMethodCard(
                      paymentMethod: _dummyPaymentMethods[i],
                      isSelected: i == _selectedPaymentMethodIndex,
                      onSelect: () {
                        setState(() {
                          _selectedPaymentMethodIndex = i;
                        });
                      },
                    ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to add new payment method screen
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Payment Method'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousStep,
                          child: const Text('Back'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _nextStep,
                          child: const Text('Continue'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            ),

            // Step 4: Review & Place Order
            Step(
              title: const Text('Review & Place Order'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Display cart items in a summarized way
                  for (var item in _dummyCartItems)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${item.color}, ${item.size} | Qty: ${item.quantity}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${(item.price * (1 - item.discount / 100) * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                  const Divider(),

                  // Shipping Address
                  const Text(
                    'Shipping Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_dummyAddresses[_selectedAddressIndex].recipient),
                  Text(_dummyAddresses[_selectedAddressIndex].addressLine1),
                  if (_dummyAddresses[_selectedAddressIndex].addressLine2.isNotEmpty)
                    Text(_dummyAddresses[_selectedAddressIndex].addressLine2),
                  Text(
                    '${_dummyAddresses[_selectedAddressIndex].city}, ${_dummyAddresses[_selectedAddressIndex].state} ${_dummyAddresses[_selectedAddressIndex].postalCode}',
                  ),
                  Text(_dummyAddresses[_selectedAddressIndex].country),
                  Text(_dummyAddresses[_selectedAddressIndex].phoneNumber),

                  const SizedBox(height: 16),

                  // Shipping Method
                  const Text(
                    'Shipping Method',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_dummyShippingMethods[_selectedShippingMethodIndex].name),
                  Text(_dummyShippingMethods[_selectedShippingMethodIndex].deliveryTime),

                  const SizedBox(height: 16),

                  // Payment Method
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(_dummyPaymentMethods[_selectedPaymentMethodIndex].icon),
                      const SizedBox(width: 8),
                      Text(_dummyPaymentMethods[_selectedPaymentMethodIndex].name),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Coupon code
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Enter coupon code',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          enabled: !_isPlacingOrder && _appliedCoupon == null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isPlacingOrder || _appliedCoupon != null
                            ? null
                            : () {
                                setState(() {
                                  _appliedCoupon = 'WELCOME10';
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Coupon applied: WELCOME10'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),

                  if (_appliedCoupon != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Coupon $_appliedCoupon applied',
                            style: const TextStyle(color: Colors.green),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _isPlacingOrder
                                ? null
                                : () {
                                    setState(() {
                                      _appliedCoupon = null;
                                    });
                                  },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(60, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Remove'),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Order summary
                  CheckoutSummaryCard(
                    subtotal: subtotal,
                    tax: tax,
                    shipping: shipping,
                    discount: discount,
                    total: total,
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isPlacingOrder ? null : _previousStep,
                          child: const Text('Back'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isPlacingOrder ? null : _placeOrder,
                          child: _isPlacingOrder
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Processing...'),
                                  ],
                                )
                              : Text('Place Order - \$${total.toStringAsFixed(2)}'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isActive: _currentStep >= 3,
              state: StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy models for preview
class DummyAddress {
  final String id;
  final String name;
  final String recipient;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String phoneNumber;
  final bool isDefault;

  DummyAddress({
    required this.id,
    required this.name,
    required this.recipient,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.phoneNumber,
    required this.isDefault,
  });
}

class DummyPaymentMethod {
  final String id;
  final String type;
  final String name;
  final IconData icon;
  final bool isDefault;

  DummyPaymentMethod({
    required this.id,
    required this.type,
    required this.name,
    required this.icon,
    required this.isDefault,
  });
}

class DummyShippingMethod {
  final String id;
  final String name;
  final double price;
  final String deliveryTime;

  DummyShippingMethod({
    required this.id,
    required this.name,
    required this.price,
    required this.deliveryTime,
  });
}

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
}
