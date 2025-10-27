// reusable_info_card.dart

import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/sales/sale_form.dart';

class ReusableInfoCard extends StatelessWidget {
  final String title;
  final List<MapEntry<String, String>> dataRows;
  final Widget? child;

  const ReusableInfoCard({
    Key? key,
    required this.title,
    required this.dataRows,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card title
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
         
        KHeight16,

    // ✅ Info rows only if not empty
    if (dataRows.isNotEmpty)
          // Info rows
          ...dataRows.map((entry) => _buildInfoRow(entry.key, entry.value)),

           // ✅ Add SaleForm or any widget here
    if (child != null) child!,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$label:",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // Kheight6,
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black
                  ),
              ),
            ],
            
          ),
          Kheight6,
        ],
      ),
    );
  }
}
