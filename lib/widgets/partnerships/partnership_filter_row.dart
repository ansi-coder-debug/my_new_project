import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PartnershipFilterRow extends StatelessWidget {
  final VoidCallback onAddPressed;

  const PartnershipFilterRow({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              _buildSummaryCard('Total Partnership', '1'),
              _buildSummaryCard('Unique Vehicles ', '1'),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryCard('Total Share %', '6'),
              _buildSummaryCard('Todays Partnerships', '0'),
            ],
          ),

          // when data increases use wrap

          // Wrap(
          //   spacing: 12,
          //   runSpacing: 12,
          //   children: [
          //     _buildSummaryCard('Total Partnerships', '$total'),
          //     _buildSummaryCard('Unique Vehicles', '$vehicles'),
          //     _buildSummaryCard('Total Share %', '$share'),
          //     _buildSummaryCard('Today\'s Partnerships', '$today'),
          //     // You can add more cards dynamically later
          //   ],
          // )
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: Icon(Icons.add),
              onPressed: onAddPressed,
              label: Text('Add Partnership'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
