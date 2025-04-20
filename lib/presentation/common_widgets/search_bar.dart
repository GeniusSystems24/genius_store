import 'package:flutter/material.dart';

class AppSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final String hintText;

  const AppSearchBar({
    Key? key,
    required this.onSearch,
    this.hintText = 'ابحث عن منتجات...',
  }) : super(key: key);

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintTextDirection: TextDirection.rtl,
        filled: true,
        fillColor: Colors.grey[100],
        prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onSubmitted: widget.onSearch,
      onChanged: (value) {
        // يمكن تنفيذ بحث أثناء الكتابة هنا
      },
    );
  }
}
