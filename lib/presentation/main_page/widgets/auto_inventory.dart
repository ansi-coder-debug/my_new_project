import 'package:flutter/material.dart';

class AutoInventory extends StatelessWidget {
  const AutoInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AutoInventory',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Vehicle Management System',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}