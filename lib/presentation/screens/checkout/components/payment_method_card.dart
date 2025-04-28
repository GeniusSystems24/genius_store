import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  final dynamic paymentMethod;
  final bool isSelected;
  final VoidCallback onSelect;

  const PaymentMethodCard({
    super.key,
    required this.paymentMethod,
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

              // Payment method icon
              Icon(
                paymentMethod.icon,
                size: 28,
                color: Theme.of(context).primaryColor.withOpacity(0.8),
              ),

              const SizedBox(width: 16),

              // Payment method details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment method type and default badge
                    Row(
                      children: [
                        Text(
                          paymentMethod.type,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (paymentMethod.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Default',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Payment method name/details
                    Text(
                      paymentMethod.name,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
