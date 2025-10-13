import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';

class ReusableSectionCard extends StatelessWidget {
  final String title;
  final bool isAddEnabled;
  final VoidCallback ?onAddPressed;
  final bool isEmpty;
  final String emptyMessage;
  final List<Widget> children;

  const ReusableSectionCard({
    Key? key,
    required this.title,
     this.onAddPressed,
    this.isAddEnabled = true,
    this.isEmpty = false,
    this.emptyMessage = "No records found.",
    this.children = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Header with Title + Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                 
                ),
              ),
              IconButton(
                onPressed: isAddEnabled ? onAddPressed : null,
                icon: const Icon(Icons.add, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor:
                      isAddEnabled ? Colors.black87 : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
            height: 20,
          ),
          KHeight20,

          /// 🔹 Content area
          if (isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  emptyMessage,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            Column(children: children),
        ],
      ),
    );
  }
}
/*
*/