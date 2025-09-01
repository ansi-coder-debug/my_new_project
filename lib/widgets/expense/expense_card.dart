import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';

class ExpenseCard extends StatelessWidget {
  final String id;

  final String amount;
  final String date;
  final String ?description;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback onDelete;

  const ExpenseCard({
    super.key,
    required this.id,
   

    required this.amount,
    required this.date,
     this.description,
    this.onView,
    this.onEdit,
    required this.onDelete, 
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Expense Type + Amount
            Row(
              children: [
                // Expanded(
                //   child: Text(
                //     expenseType,
                //     style: const TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 16,
                //       color: Colors.black87,
                //     ),
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ),
                Text(
                  '₹$amount',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Vehicle name below expense type
            // Text(
            //   vehicleName,
            //   style: const TextStyle(
            //     fontSize: 14,
            //     color: Colors.black54,
            //   ),
            //   overflow: TextOverflow.ellipsis,
            // ),
            const Divider(height: 20, thickness: 1),

            // Row for "no" and date
            Row(
              children: [
                 Text(
                  'Description:$description',
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(width: 16),
                Text(
                  'Date: $date',
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Buttons: View, Edit, Delete aligned right
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onView,
                  icon: const Icon(Icons.remove_red_eye),
                  tooltip: 'View',
                  color: Colors.blueGrey,
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit',
                  color: Colors.blueGrey,
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete',
                  color: Colors.redAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
