import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String amount;
  final String? subtitle;
  final Color backgroundColor;
  final IconData? icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.amount,
    this.subtitle,
    this.backgroundColor = Colors.white,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) Icon(icon, size: 30, color: Colors.white),
            Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
          ],
        ),
      ),
    );
  }
}
