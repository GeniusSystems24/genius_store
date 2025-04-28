import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final List<String> colors;
  final int selectedIndex;
  final Function(int) onColorSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedIndex,
    required this.onColorSelected,
  });

  // Convert hex color string to Color
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    try {
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return Colors.grey; // Default color on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: colors.asMap().entries.map((entry) {
        final index = entry.key;
        final hexColor = entry.value;
        final color = _hexToColor(hexColor);
        final isSelected = index == selectedIndex;

        // Determine border and check icon color for contrast
        final isDark = ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
        final checkColor = isDark ? Colors.white : Colors.black;

        return GestureDetector(
          onTap: () => onColorSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
            child: isSelected
                ? Center(
                    child: Icon(
                      Icons.check,
                      color: checkColor,
                      size: 20,
                    ),
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}
