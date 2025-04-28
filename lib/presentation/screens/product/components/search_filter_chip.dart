import 'package:flutter/material.dart';

class SearchFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const SearchFilterChip({
    super.key,
    required this.label,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      deleteIcon: const Icon(
        Icons.close,
        size: 16,
      ),
      onDeleted: onDeleted,
      deleteIconColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
      ),
    );
  }
}
