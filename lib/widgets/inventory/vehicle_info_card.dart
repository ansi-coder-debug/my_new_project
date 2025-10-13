// vehicle_info_card.dart

import 'package:flutter/material.dart';
import 'package:my_new_project/core/models/vehicle.dart';

class VehicleInfoCard extends StatelessWidget {
  final Vehicle vehicle;
  final String selectedStatus;
  final Function(String) onStatusChanged;

  const VehicleInfoCard({
    Key? key,
    required this.vehicle,
    required this.selectedStatus,
    required this.onStatusChanged,
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
          const Text(
            "Vehicle Information",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Divider(color: Colors.grey),
          const SizedBox(height: 8),

          // Info rows
          _buildInfoRow("Color", vehicle.color),
          _buildInfoRow("Mileage", "${vehicle.mileage} km"),
          _buildInfoRow("Fuel Type", vehicle.fuelType),
          _buildInfoRow(
            "Purchase Date",
            vehicle.purchaseInfo.date.toString().split("T").first,
          ),
          _buildInfoRow(
            "Notes",
  (vehicle.description?.trim().isEmpty ?? true)
      ? "No additional notes."
      : vehicle.description!,
          ),

          const SizedBox(height: 12),
          const Divider(color: Colors.grey),
          const SizedBox(height: 12),

          // Status section
          Row(
            children: [
              const Text(
                "Status:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
            Expanded(
  child: Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 6,
      vertical: 2,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButton<String>(
      isExpanded: true,
      value: selectedStatus,
      underline: const SizedBox(),
      borderRadius: BorderRadius.circular(8),
      items: const [
        DropdownMenuItem(
          value: "available",
          child: Text("Available"),
        ),
        DropdownMenuItem(
          value: "maintenance",
          child: Text("Maintenance"),
        ),
        DropdownMenuItem(
          value: "sold",
          child: Text("Sold"),
        ),
      ],
      // 👇 Disable dropdown if status is already 'sold'
      onChanged: selectedStatus.toLowerCase() == "sold"
          ? null
          : (value) {
              if (value != null) {
                onStatusChanged(value);
              }
            },
    ),
  ),
),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
