import 'dart:ui';

import 'package:flutter/material.dart';
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

  double _parseAmount(String? value) {
    if (value == null) return 0.0;
    return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
   final purchasePrice = vehicle.purchaseInfo.price;
    final salePrice = _parseAmount(vehicle.saleInfo?.price);
//     final totalExpenses = (expenses ?? []).fold<double>(
//   0.0,
//   (sum, e) => sum + (double.tryParse(e.amount.replaceAll(',', '')) ?? 0.0),
// );

final totalExpenses = (expenses ?? []).fold<double>(
  0.0,
  (sum, e) => sum + (e.amount ?? 0.0),
);


    final totalCost = purchasePrice + totalExpenses;
    final profit = salePrice - totalCost;

    final totalPartnerSharePercentage = vehicle.partnerships?.fold<double>(
          0.0,
          (sum, p) => sum + (double.tryParse(p.sharePercentage ?? '0') ?? 0),
        ) ??
        0.0;

    final ownerShare = profit * ((100 - totalPartnerSharePercentage) / 100);

    final cardColor = profit > 0
        ? Colors.green.shade50
        : profit < 0
            ? Colors.red.shade50
            : Colors.grey.shade200;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: profit > 0
              ? Colors.green
              : profit < 0
                  ? Colors.red
                  : Colors.grey,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profit Summary",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          const SizedBox(height: 16),

          _buildRow("Purchase Price", "₹${purchasePrice.toStringAsFixed(2)}"),
          _buildRow("Total Expenses", "₹${totalExpenses.toStringAsFixed(2)}"),
          _buildRow("Total Cost", "₹${totalCost.toStringAsFixed(2)}"),
          _buildRow("Sale Price", "₹${salePrice.toStringAsFixed(2)}"),
          const Divider(height: 24, color: Colors.black),
          _buildRow(
            "Total Profit",
            "₹${profit.toStringAsFixed(2)}",
            valueColor: profit > 0
                ? Colors.green
                : profit < 0
                    ? Colors.red
                    : Colors.black,
          ),
          _buildRow(
            "Owner's Share",
            "₹${ownerShare.toStringAsFixed(2)}",
            valueColor: Colors.blueGrey,
          ),

          const SizedBox(height: 12),

          if ((vehicle.partnerships?.isNotEmpty ?? false)) ...[
            const Divider(height: 24),
            Text(
              "Partner Shares",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            ...vehicle.partnerships!.map((p) {
              final sharePercent =
                  double.tryParse(p.sharePercentage ?? '0') ?? 0.0;
              final shareAmount = profit * (sharePercent / 100);
              return _buildRow(
                "${p.partnerName ?? 'Partner'} (${sharePercent.toStringAsFixed(0)}%)",
                "₹${shareAmount.toStringAsFixed(2)}",
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              )),
          Text(value,
              style: TextStyle(
                color: valueColor ?? Colors.black,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
