import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';

class HighlightCard extends StatelessWidget {
  final String title;
  final String amount;
  final String breakdown;
  final Color backgroundColor;
  final Color textColor;

  // Separate text colors
  final Color? titleColor;
  final Color? amountColor;
  final Color? breakdownColor;

  const HighlightCard({
    required this.title,
    required this.amount,
    required this.breakdown,
    required this.backgroundColor,
    this.textColor = Colors.white,

    this.titleColor,
    this.amountColor,
    this.breakdownColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor,


         // Optional: Add border/shadow to make light cards visible
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),

      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
             textAlign: TextAlign.center,
              style: TextStyle(
                color: titleColor, 
                fontSize: 16,
                 fontWeight: FontWeight.w500
                 )),
         KHeight,
          Text(
            amount,
             textAlign: TextAlign.center,
              style: TextStyle(
                color: amountColor,
                 fontSize: 24,
                  fontWeight: FontWeight.bold
                  )),
         KHeight,
          Text(
            breakdown,
             textAlign: TextAlign.center,
              style: TextStyle(
                color: breakdownColor,
                 fontSize: 12
                 )),
        ],
      ),
    );
  }
}
