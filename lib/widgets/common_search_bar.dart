import 'package:flutter/material.dart';

class CommonSearchBar extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Function(String) onChanged;

  const CommonSearchBar({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(26),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
