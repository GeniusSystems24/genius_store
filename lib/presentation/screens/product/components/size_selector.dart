import 'package:flutter/material.dart';

class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final int selectedIndex;
  final Function(int) onSizeSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedIndex,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: sizes.asMap().entries.map((entry) {
        final index = entry.key;
        final size = entry.value;
        final isSelected = index == selectedIndex;

        return GestureDetector(
          onTap: () => onSizeSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.1),
              border: Border.all(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                size,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
