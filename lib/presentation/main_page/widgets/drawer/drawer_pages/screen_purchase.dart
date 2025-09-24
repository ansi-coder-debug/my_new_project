import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // for formatting dates
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';

class ScreenPurchase extends ConsumerWidget {
  const ScreenPurchase ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 👉 Watch vehicles from the vehicleProvider
    final vehicleState = ref.watch(vehicleProvider);

    // 👉 Show loader while fetching
    if (vehicleState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 👉 Show error if fetching failed
    if (vehicleState.error != null) {
      return Center(child: Text("Error: ${vehicleState.error}"));
    }

    // 👉 Get vehicles list
    final vehicles = vehicleState.vehicles;

    // 👉 Filter only those with purchase info (every vehicle should have, but safe)
    final purchases = vehicles
        .where((v) => v.purchaseInfo != null)
        .toList();

    return Scaffold(
      body:SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title:'Purchase',
              onBack: () => Navigator.pop(context),
              onFilter: () {
                // TODO: Open filter
              },
              onRefresh: () {
                ref.read(vehicleProvider.notifier).loadVehicles();
              },
              onSearch: () {
                // TODO: Open search
              },
              showAdd: false, 
               ),
               KHeight,



      Expanded(
          child: purchases.isEmpty?
           const Center(child: Text("No sale information available."))
     :ListView.separated(
        itemCount: purchases.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final vehicle = purchases[index];
          final purchase = vehicle.purchaseInfo!; // safe because we filtered above

          // 👉 Format date (convert string/DateTime into 11/9/2025 like screenshot)
          final formattedDate = DateFormat("d/M/y").format(DateTime.parse(purchase.date.toIso8601String()));

          return ListTile(
            // 👉 Big title = Vehicle name (Make + Model)
            title: Text(
              "${vehicle.make.toUpperCase()} ${vehicle.model.toUpperCase()}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            // 👉 Below title: price and payment status
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${purchase.price}", // Purchase Price
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  purchase.paymentStatus, // paid / partial
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),

            // 👉 On the right side: purchase date
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                // 👉 Three dot menu (for actions like edit/delete)
                const Icon(Icons.more_vert, size: 20),
              ],
            ),
          );
        },
      ),
    ),
          ],
        ),
      ),
        );
  }
}
