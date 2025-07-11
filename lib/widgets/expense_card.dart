import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  final String initials; // e.g., 'VT'

  final Color initialColor; // e.g., Colors.red

  final String title; // e.g., 'Vehicle Transportation'

  final String category; // e.g., 'Logistics'

  final String date; // e.g., 'July 8, 2024'

  final String amount; // e.g., '₹25,000'

  final String status; // e.g., 'Approved'

  final Color statusColor; // e.g., Colors.green

  final VoidCallback onTap; // tap action*/

  const ExpenseCard({
    super.key,
    required this.initials,
    required this.initialColor,
    required this.title,
    required this.category,
    required this.status,
    required this.statusColor,
    required this.amount,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,//connect call back
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: initialColor,
              child: Text(
                initials,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$category.$date',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$amount.$status',
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
      color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
