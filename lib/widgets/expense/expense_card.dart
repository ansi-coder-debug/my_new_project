import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';

class ExpenseCard extends StatelessWidget {
  final String id;
  final String title;
  final String category;
  final String amount;
  final String date;
  final String paymentMode;
  final String status;
  final VoidCallback? onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExpenseCard({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.paymentMode,
    required this.status,
    this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
  children: [
    // ✅ Status tag
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,  // ✅ Use the status here!
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    SizedBox(width: 8), // space between tag and title
    Expanded(
      child: Text(
        title,  // ✅ Your normal title
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ),
    IconButton(onPressed: onEdit, icon: Icon(Icons.edit_square)),
    KWidth12,
    IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
  ],
),

              // Row(
              //   children: [
              //     Container(
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 8,
              //         vertical: 4,
              //       ),
              //       decoration: BoxDecoration(
              //         color: Colors.black,
              //         borderRadius: BorderRadius.circular(4),
              //       ),
                    

              //       child: Text(
              //         title,
              //         style: TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.black,
              //         ),
              //       ),
              //     ),

              //     Spacer(),

              //     // Icon(Icons.edit_square),
              //     IconButton(onPressed: onEdit, icon: Icon(Icons.edit_square)),

              //     KWidth12,
              //     // Icon(Icons.delete),
              //     IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
              //   ],
              // ), //end of name row
              KHeight,
              // Spacer between name Row and salary
              Text(
                '\$$amount',
                style: TextStyle(fontSize: 20, color: Colors.blue),
                overflow: TextOverflow.ellipsis,
              ), //end of salary text

              KHeight,

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Category:$category',
                      style: TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 60),
                  Text(
                    'Date:$date',
                    style: TextStyle(color: Colors.black),
                    // overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Text(
                'PaymentMode:$paymentMode',
                style: TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
