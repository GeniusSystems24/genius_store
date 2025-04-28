import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final Function(int) onQuantityChanged;
  final int minQuantity;
  final int maxQuantity;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.minQuantity = 1,
    this.maxQuantity = 999,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildQuantityButton(
          icon: Icons.remove,
          onPressed: quantity > minQuantity ? () => onQuantityChanged(quantity - 1) : null,
          context: context,
        ),
        Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.zero,
          ),
          child: Center(
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        _buildQuantityButton(
          icon: Icons.add,
          onPressed: quantity < maxQuantity ? () => onQuantityChanged(quantity + 1) : null,
          context: context,
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required BuildContext context,
  }) {
    return Material(
      color: onPressed == null ? Colors.grey.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.zero,
          ),
          child: Icon(
            icon,
            color: onPressed == null ? Colors.grey : Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}
