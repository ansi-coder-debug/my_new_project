import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/expense.dart';
import 'package:my_new_project/core/models/vehicle.dart';

class ProfitSummaryCard extends StatelessWidget {
  final Vehicle vehicle;
  final List<Expense> expenses;

  const ProfitSummaryCard({
    Key? key,
    required this.vehicle,
    required this.expenses,
  }) : super(key: key);

  // Helper method to parse string to double safely
  double _parseAmount(String? value) {
    if (value == null) return 0.0;
    return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    // Get purchase price directly from the vehicle model
    final purchasePrice = vehicle.purchaseInfo.price;
    // Get sale price from saleInfo
    final salePrice = _parseAmount(vehicle.saleInfo?.price);


final totalExpenses = expenses.fold<double>(
  0.0,
  (sum, e) => sum + (e.amount ?? 0.0),
);


    // Total cost = purchase price + all expenses
    final double totalCost = purchasePrice + totalExpenses;

    // Gross profit = sale price - total cost
    final double grossProfit = salePrice - totalCost;

    // Calculate total partner share percentage
    final double totalPartnerPercentage =
        vehicle.partnerships?.fold<double>(
          0.0,
          (sum, p) => sum + (double.tryParse(p.sharePercentage ?? '0') ?? 0.0),
        ) ??
        0.0;

    // Owner's profit = gross profit * (100 - partner %) / 100
    final double ownerProfit =
        grossProfit * ((100.0 - totalPartnerPercentage) / 100.0);

    // Partner payout = total profit - owner share
    final double partnerPayout = grossProfit - ownerProfit;

    // Color profit amount green if positive, red if negative, black if 0
    final Color profitColor = grossProfit > 0
        ? Colors.green
        : grossProfit < 0
        ? Colors.red
        : Colors.black;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            "Profit / Loss Summary",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          KHeight,
          const Divider(color: Colors.grey, thickness: 0.5),
          KHeight,

          // Data rows
          _buildRow("Sale Price", _formatINR(salePrice)),
          _buildRow("Total Cost", _formatINR(totalCost)),
          _buildRow(
            "Gross Profit",
            _formatINR(grossProfit),
            valueColor: profitColor,
          ),
          Kheight6,
          _buildRow("Owners Profit", _formatINR(ownerProfit)),
          _buildRow("Partners Payout", _formatINR(partnerPayout)),
        ],
      ),
    );
  }

  // Helper to build one line row: Label on left, Value on right
  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
           style:
            TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold
            )),

          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Helper to format numbers like ₹1,50,000.00
  String _formatINR(double amount) {
    return "₹${amount.toStringAsFixed(2)}";
  }
}
