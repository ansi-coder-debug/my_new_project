import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/core/models/partnership.dart';

class ScreenPartnerships extends ConsumerWidget {
  const ScreenPartnerships({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vehicleProvider);

    // Flatten all partnerships from all vehicles
    final List<Map<String, dynamic>> allPartnerships = [];

    for (final vehicle in state.vehicles) {
      if (vehicle.partnerships != null && vehicle.partnerships!.isNotEmpty) {
        for (final partnership in vehicle.partnerships!) {
          allPartnerships.add({
            'vehicle': vehicle,
            'partnership': partnership,
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Partnerships'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : allPartnerships.isEmpty
              ? const Center(child: Text('No partnerships found.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: allPartnerships.length,
                  itemBuilder: (context, index) {
                    final item = allPartnerships[index];
                    final Vehicle vehicle = item['vehicle'];
                    final Partnership partnership = item['partnership'];

                    final partnerName =
                        partnership.partnerName ?? partnership.partner?.name ?? 'Unknown';
                    final vehicleName = '${vehicle.make} ${vehicle.model}';
                    final contribution = double.tryParse(partnership.contribution ?? '0') ?? 0.0;
                    final paymentMode = partnership.paymentMode ?? 'N/A';
                    final contributionStatus = partnership.contributionStatus ?? 'pending';

                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Partner name + menu
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    partnerName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF1B1B3A),
                                    ),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    // Handle edit/delete if needed
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Vehicle make & model
                            Text(
                              vehicleName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Payment mode
                            Text(
                              'Paid via: $paymentMode',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Paid amount
                            Text(
                              'Paid: ₹${contribution.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Status
                            Text(
                              'Status: $contributionStatus',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
