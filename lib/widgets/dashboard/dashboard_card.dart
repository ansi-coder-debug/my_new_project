// widgets/dashboard_card.dart

import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';

class DashboardCard extends StatelessWidget {
  final String title;
   final int ?currentCount; // e.g., available
  final int? totalCount;   // e.g., total
  final Color backgroundColor;
  final VoidCallback onTap;
  
  

  const DashboardCard({
    Key? key,
    required this.title,
      this.currentCount,
     this.totalCount,
    required this.backgroundColor,
    required this.onTap,
  }) : super(key: key);
 @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
         color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
           KHeight,
            Text(
              "$currentCount / $totalCount",
               textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              
            ),
          ],
        ),
      ),
    );
  }
}