import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/models/brokerage.dart';
import 'package:my_new_project/core/models/vehicle.dart';

class ScreenBrokerage extends ConsumerWidget {
  const ScreenBrokerage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleState = ref.watch(vehicleProvider);

    final List<Map<String, dynamic>> brokerageEntries = [];

    for (final vehicle in vehicleState.vehicles) {
      final brokerages = vehicle.brokerageInfo ?? [];
      for (final brokerage in brokerages) {
        brokerageEntries.add({
          'vehicle': vehicle,
          'brokerage': brokerage,
        });
      }
    }

    if (brokerageEntries.isEmpty) {
      return const Center(child: Text('No brokerage records found.'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Brokerage')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: brokerageEntries.length,
        itemBuilder: (context, index) {
          final vehicle = brokerageEntries[index]['vehicle'] as Vehicle;
          final brokerage = brokerageEntries[index]['brokerage'] as Brokerage;

          final formattedAmount = NumberFormat('#,##0')
              .format(int.tryParse(brokerage.amount) ?? 0);

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
                  // Name + Amount + Menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          brokerage.brokerName.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "₹$formattedAmount",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              if (value == 'edit') {
                                // TODO: Handle edit
                              } else if (value == 'delete') {
                                // TODO: Handle delete
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${vehicle.make} ${vehicle.model}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    brokerage.remarks?.isNotEmpty == true
                        ? brokerage.remarks!
                        : "No remarks",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
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
