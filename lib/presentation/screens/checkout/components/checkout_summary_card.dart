import 'package:flutter/material.dart';

class CheckoutSummaryCard extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double shipping;
  final double discount;
  final double total;

  const CheckoutSummaryCard({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.discount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Subtotal
            _buildSummaryRow(
              label: 'Subtotal',
              value: '\$${subtotal.toStringAsFixed(2)}',
            ),

            const SizedBox(height: 8),

            // Shipping
            _buildSummaryRow(
              label: 'Shipping',
              value: shipping > 0 ? '\$${shipping.toStringAsFixed(2)}' : 'Free',
              valueColor: shipping > 0 ? null : Colors.green,
            ),

            const SizedBox(height: 8),

            // Tax
            _buildSummaryRow(
              label: 'Tax',
              value: '\$${tax.toStringAsFixed(2)}',
            ),

            // Discount (if applicable)
            if (discount > 0) ...[
              const SizedBox(height: 8),
              _buildSummaryRow(
                label: 'Discount',
                value: '-\$${discount.toStringAsFixed(2)}',
                valueColor: Colors.green,
              ),
            ],

            const Divider(height: 24),

            // Total
            _buildSummaryRow(
              label: 'Total',
              value: '\$${total.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
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
