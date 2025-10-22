import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';

class GridMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const GridMenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        // 1. Remove elevation for a flatter look
        elevation: 0,
        // 2. Set the background color of the card
        color: Colors.white, // Light off-white background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          // 3. Add a subtle border
          side: BorderSide(
            color: Colors.grey.withOpacity(0.2), // Light grey border
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                // 4. Change icon color to a vibrant blue
                color: const Color(0xFF3366FF), // Vibrant blue as seen in the image
              ),
             KHeight,
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  // 5. Change text color to a darker shade for better contrast
                  color: Colors.black, // Dark grey for text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}