import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final dynamic address;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onEdit;

  const AddressCard({
    super.key,
    required this.address,
    required this.isSelected,
    required this.onSelect,
    required this.onEdit,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Radio button for selection
              Radio<bool>(
                value: true,
                groupValue: isSelected ? true : false,
                onChanged: (_) => onSelect(),
                activeColor: Theme.of(context).primaryColor,
              ),

              const SizedBox(width: 8),

              // Address details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address name and default badge
                    Row(
                      children: [
                        Text(
                          address.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (address.isDefault)
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

                    const SizedBox(height: 8),

                    // Recipient name
                    Text(address.recipient),

                    // Address lines
                    Text(address.addressLine1),
                    if (address.addressLine2.isNotEmpty) Text(address.addressLine2),

                    // City, state, postal code
                    Text('${address.city}, ${address.state} ${address.postalCode}'),

                    // Country
                    Text(address.country),

                    // Phone number
                    Text(address.phoneNumber),
                  ],
                ),
              ),

              // Edit button
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: onEdit,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
