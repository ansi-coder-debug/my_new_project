import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/core/constants/constant.dart'; // For formatting currency

class SalesVsPurchasePieChart extends StatelessWidget {
  final double totalSalesReceived;
  final double totalPurchasePaid;

  const SalesVsPurchasePieChart({
    Key? key,
    required this.totalSalesReceived,
    required this.totalPurchasePaid,
  }) : super(key: key);

  String formatCurrency(double amount) {
    return '₹${NumberFormat.currency(locale: 'en_IN', symbol: '').format(amount.round())}'; // Format as ₹X,XXX
  }

  @override
  Widget build(BuildContext context) {
    // Define your colors
    const Color salesReceivedColor = Colors.blue;
    const Color purchasePaidColor = Colors.green;
    const Color textColor = Colors.black87; // For labels and title

    // Calculate total for percentage calculation
    final double total = totalSalesReceived + totalPurchasePaid;

    List<PieChartSectionData> showingSections() {
      if (total == 0) {
        return [
          PieChartSectionData(
            color: Colors.grey.shade300,
            value: 100,
            title: 'No Data',
            radius: 70,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            titlePositionPercentageOffset: 0.55,
          ),
        ];
      }

      return [
        PieChartSectionData(
          color: purchasePaidColor,
          value: totalPurchasePaid,
          title: totalPurchasePaid > 0
              ? formatCurrency(totalPurchasePaid)
              : '', // Show value only if greater than 0
          radius: 80, // Radius of the section
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titlePositionPercentageOffset: totalPurchasePaid > 0.001 ? 0.55 : 0, // Adjust offset for label visibility
        ),
        PieChartSectionData(
          color: salesReceivedColor,
          value: totalSalesReceived,
          title: totalSalesReceived > 0
              ? formatCurrency(totalSalesReceived)
              : '', // Show value only if greater than 0
          radius: 80, // Radius of the section
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titlePositionPercentageOffset: totalSalesReceived > 0.001 ? 0.55: 0, // Adjust offset for label visibility
        ),
      ];
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Sales vs Purchase Paid',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          KHeight30,
          SizedBox(
            height: 220, // Fixed height for the pie chart area
            child: PieChart(
              PieChartData(
                sections: showingSections(),
                centerSpaceRadius: 40, // Adjust for inner circle size
                sectionsSpace: 2, // Space between sections
                borderData: FlBorderData(show: false), // No border around the chart
                // You can add touch interactivity here if needed
                // pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) { ... }),
              ),
            ),
          ),
          KHeight20,
          // Legend
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildLegendItem(purchasePaidColor, 'Purchase Paid'),
                const SizedBox(width: 20),
                _buildLegendItem(salesReceivedColor, 'Sales Received'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: <Widget>[
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}