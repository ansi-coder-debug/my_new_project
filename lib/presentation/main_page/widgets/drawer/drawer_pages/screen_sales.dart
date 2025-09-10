import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';

class ScreenSales extends ConsumerWidget {
  const ScreenSales({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleState = ref.watch(vehicleProvider);

    // Filter only sold vehicles (those with saleInfo)
    final soldVehicles = vehicleState.vehicles
        .where((vehicle) => vehicle.saleInfo != null)
        .toList();

    if (soldVehicles.isEmpty) {
      return const Center(child: Text("No sale information available."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: soldVehicles.length,
      itemBuilder: (context, index) {
        final vehicle = soldVehicles[index];
        final saleInfo = vehicle.saleInfo!;

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer name and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      saleInfo.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "₹${saleInfo.price}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  "${vehicle.make} ${vehicle.model} (${vehicle.year})",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 12),

                Text("Phone: ${saleInfo.phone}"),
                Text("Address: ${saleInfo.address}"),
                Text("Date: ${saleInfo.date}"),
                Text("Payment: ${saleInfo.paymentStatus} (${saleInfo.modeOfPayment})"),
                Text("Received: ₹${saleInfo.receivedPrice}"),
              ],
            ),
          ),
        );
      },
    );
  }
}
