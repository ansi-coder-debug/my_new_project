

import 'dart:ui';

import 'package:flutter/material.dart';

class InventoryVehicleCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String price;
  final String registrationId;
  final String color;
  final String fuel;
  final String mileage;
  final String purchaseDate;
  final String status;
  final String year;
  final VoidCallback? onTap;

  const InventoryVehicleCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.registrationId,
    required this.color,
    required this.fuel,
    required this.mileage,
    required this.purchaseDate,
    required this.status,
    required this.year,
    this.onTap,
  });

  Widget _buildVehicleImage() {
    if (imageUrl.isEmpty) {
      return const Placeholder(fallbackHeight: 200, fallbackWidth: double.infinity);
    }
    return Image.network(imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildVehicleImage(),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: status.toLowerCase() == "sold" ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Year + RegNo
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("$year • $registrationId", style: TextStyle(color: Colors.grey[700])),

                  const SizedBox(height: 8),

                  // Color & Fuel
                  Row(
                    children: [
                      Expanded(child: Text("Color: $color")),
                      Expanded(child: Text("Fuel: $fuel")),
                    ],
                  ),

                  // Mileage & Purchase Date
                  Row(
                    children: [
                      Expanded(child: Text("Mileage: $mileage km")),
                      Expanded(child: Text("Purchase: $purchaseDate")),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Price
                  Text(
                    "₹$price",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),

                  // Optional expense breakdown
                  Text("₹$price (Purchase) + Expenses", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
