import 'package:flutter/material.dart';

class CustomDrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const CustomDrawerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: selected ? Colors.blue : Colors.white),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? Colors.blue : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: selected,
      selectedTileColor: Color(0xFF1F2235),
      onTap: onTap,
    );
  }
}
