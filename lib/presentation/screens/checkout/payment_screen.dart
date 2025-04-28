import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/core.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.totalAmount,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  int _selectedPaymentMethodIndex = 0;
  bool _isProcessing = false;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  // Dummy payment methods for demo purposes
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'type': 'Credit Card',
      'icon': Icons.credit_card,
      'requiresForm': true,
    },
    {
      'type': 'PayPal',
      'icon': Icons.paypal,
      'requiresForm': false,
    },
    {
      'type': 'Apple Pay',
      'icon': Icons.apple,
      'requiresForm': false,
    },
    {
      'type': 'Google Pay',
      'icon': Icons.g_mobiledata,
      'requiresForm': false,
    },
  ];

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  bool get _isCurrentMethodCreditCard => _paymentMethods[_selectedPaymentMethodIndex]['type'] == 'Credit Card';

  bool get _isFormValid {
    if (!_isCurrentMethodCreditCard) {
      return true;
    }

    return _cardNumberController.text.length >= 16 &&
        _cardHolderController.text.isNotEmpty &&
        _expiryDateController.text.length >= 5 &&
        _cvvController.text.length >= 3;
  }

  void _formatExpiryDate() {
    final text = _expiryDateController.text;
    if (text.length == 2 && !text.contains('/')) {
      _expiryDateController.text = '$text/';
      _expiryDateController.selection = TextSelection.fromPosition(
        TextPosition(offset: _expiryDateController.text.length),
      );
    }
  }

  Future<void> _processPayment() async {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all payment details correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
    });

    // Navigate to order confirmation screen
    AppRouter.go(context, AppConstants.ordersCollection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Column(
        children: [
          // Order Summary Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount:'),
                        Text(
                          '\$${widget.totalAmount.toStringAsFixed(2)}',
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
          ),

          // Payment Methods
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Method',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: List.generate(
                      _paymentMethods.length,
                      (index) => _buildPaymentMethodTile(index),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Credit Card Form
          if (_isCurrentMethodCreditCard)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Card Number
                    TextField(
                      controller: _cardNumberController,
                      decoration: InputDecoration(
                        labelText: 'Card Number',
                        hintText: 'XXXX XXXX XXXX XXXX',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.credit_card),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 19,
                    ),
                    const SizedBox(height: 16),

                    // Card Holder
                    TextField(
                      controller: _cardHolderController,
                      decoration: InputDecoration(
                        labelText: 'Card Holder Name',
                        hintText: 'John Doe',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),

                    // Expiry Date and CVV
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _expiryDateController,
                            decoration: InputDecoration(
                              labelText: 'Expiry Date',
                              hintText: 'MM/YY',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.date_range),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 5,
                            onChanged: (_) => _formatExpiryDate(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _cvvController,
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              hintText: 'XXX',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.security),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            obscureText: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _paymentMethods[_selectedPaymentMethodIndex]['icon'] as IconData,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'You will be redirected to ${_paymentMethods[_selectedPaymentMethodIndex]['type']} after confirming',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
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
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text('Pay \$${widget.totalAmount.toStringAsFixed(2)}'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile(int index) {
    final method = _paymentMethods[index];
    final isSelected = _selectedPaymentMethodIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethodIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
          border: index != _paymentMethods.length - 1
              ? Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              method['icon'] as IconData,
              color: isSelected ? Theme.of(context).primaryColor : null,
            ),
            const SizedBox(width: 16),
            Text(
              method['type'] as String,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Theme.of(context).primaryColor : null,
              ),
            ),
            const Spacer(),
            Radio<int>(
              value: index,
              groupValue: _selectedPaymentMethodIndex,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethodIndex = value!;
                });
              },
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
