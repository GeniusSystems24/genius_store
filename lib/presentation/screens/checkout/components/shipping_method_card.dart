import 'package:flutter/material.dart';

class ShippingMethodCard extends StatelessWidget {
  final dynamic shippingMethod;
  final bool isSelected;
  final VoidCallback onSelect;

  const ShippingMethodCard({
    super.key,
    required this.shippingMethod,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Card(
        elevation: isSelected ? 2 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Radio button for selection
              Radio<bool>(
                value: true,
                groupValue: isSelected ? true : false,
                onChanged: (_) => onSelect(),
                activeColor: Theme.of(context).primaryColor,
              ),

              const SizedBox(width: 8),

              // Icon based on shipping speed
              Icon(
                _getIconForShippingMethod(shippingMethod.name),
                size: 28,
                color: Theme.of(context).primaryColor.withOpacity(0.8),
              ),

              const SizedBox(width: 16),

              // Shipping method details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shippingMethod.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shippingMethod.deliveryTime,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Price
              Text(
                '\$${shippingMethod.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForShippingMethod(String methodName) {
    if (methodName.toLowerCase().contains('express')) {
      return Icons.flash_on;
    } else if (methodName.toLowerCase().contains('same day')) {
      return Icons.directions_run;
    } else {
      return Icons.local_shipping;
    }
  }
}
