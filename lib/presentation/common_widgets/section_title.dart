import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllPressed;
  final TextStyle? titleStyle;
  final String seeAllText;

  const SectionTitle({
    Key? key,
    required this.title,
    this.onSeeAllPressed,
    this.titleStyle,
    this.seeAllText = 'عرض الكل',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: titleStyle ?? Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.right,
          ),
        ),
        if (onSeeAllPressed != null) ...[
          TextButton(
            onPressed: onSeeAllPressed,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(40, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft,
            ),
            child: Text(seeAllText),
          ),
        ],
      ],
    );
  }
}
