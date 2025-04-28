import 'package:flutter/material.dart';

class CartSummaryCard extends StatefulWidget {
  final double subtotal;
  final double tax;
  final double shippingFee;
  final double total;

  const CartSummaryCard({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.shippingFee,
    required this.total,
  });

  @override
  State<CartSummaryCard> createState() => _CartSummaryCardState();
}

class _CartSummaryCardState extends State<CartSummaryCard> {
  final TextEditingController _couponController = TextEditingController();
  String? _appliedCoupon;
  bool _isApplyingCoupon = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final coupon = _couponController.text.trim();
    if (coupon.isEmpty) return;

    setState(() {
      _isApplyingCoupon = true;
    });

    // Simulate coupon validation
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isApplyingCoupon = false;
        _appliedCoupon = coupon;
        _couponController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Coupon "$coupon" applied successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _removeCoupon() {
    setState(() {
      _appliedCoupon = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coupon removed'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coupon field
          if (_appliedCoupon == null)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    decoration: const InputDecoration(
                      hintText: 'Enter coupon code',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    enabled: !_isApplyingCoupon,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isApplyingCoupon ? null : _applyCoupon,
                  child: _isApplyingCoupon
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Apply'),
                ),
              ],
            )
          else
            Row(
              children: [
                const Icon(Icons.local_offer, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Coupon "$_appliedCoupon" applied',
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
                TextButton(
                  onPressed: _removeCoupon,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(40, 36),
                  ),
                  child: const Text('Remove'),
                ),
              ],
            ),

          const SizedBox(height: 16),

          // Order summary
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // Subtotal
          _buildSummaryRow(
            label: 'Subtotal',
            value: '\$${widget.subtotal.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 8),

          // Tax
          _buildSummaryRow(
            label: 'Tax (5%)',
            value: '\$${widget.tax.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 8),

          // Shipping
          _buildSummaryRow(
            label: 'Shipping Fee',
            value: widget.shippingFee > 0 ? '\$${widget.shippingFee.toStringAsFixed(2)}' : 'Free',
            valueColor: widget.shippingFee > 0 ? null : Colors.green,
          ),

          if (_appliedCoupon != null) ...[
            const SizedBox(height: 8),

            // Discount
            _buildSummaryRow(
              label: 'Discount',
              value: '-\$10.00', // Example discount
              valueColor: Colors.green,
            ),
          ],

          const Divider(height: 24),

          // Total
          _buildSummaryRow(
            label: 'Total',
            value: '\$${widget.total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
