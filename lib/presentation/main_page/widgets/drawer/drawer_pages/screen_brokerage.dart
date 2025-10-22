import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/brokerage/brokerage_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/brokerage.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/infrastructure/broker/broker_repositary.dart';
import 'package:my_new_project/widgets/brokerage/brokerage_dialog.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class ScreenBrokerage extends ConsumerWidget {
  const ScreenBrokerage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleState = ref.watch(vehicleProvider);

    final List<Map<String, dynamic>> brokerageEntries = [];

    for (final vehicle in vehicleState.vehicles) {
      final brokerages = vehicle.brokerageInfo ?? [];
      for (final brokerage in brokerages) {
        brokerageEntries.add({'vehicle': vehicle, 'brokerage': brokerage});
      }
    }

    // if (brokerageEntries.isEmpty) {
    //   return const Center(child: Text('No brokerage records found.'));
    // }

    return Scaffold(
      // appBar: AppBar(title: const Text('Brokerage')),
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "Brokerage",
              // onBack: () {
              //   //last index wanna do at later
              // },
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
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: brokerageEntries.length,
                itemBuilder: (context, index) {
                  final vehicle = brokerageEntries[index]['vehicle'] as Vehicle;
                  final brokerage =
                      brokerageEntries[index]['brokerage'] as Brokerage;

                  final doubleAmount = double.tryParse(brokerage.amount) ?? 0.0;
                  final doublePaid =
                      double.tryParse(brokerage.brokeragePaid ?? '0') ?? 0.0;
                  final doubleBalance = doubleAmount - doublePaid;

                  String computedStatus;
                  if (doublePaid == 0) {
                    computedStatus = 'pending';
                  } else if (doublePaid < doubleAmount) {
                    computedStatus = 'partial';
                  } else {
                    computedStatus = 'paid';
                  }

                  return OutputCard(
                    title: brokerage.brokerName.toUpperCase(),
                    subtitle:
                        "${vehicle.make} ${vehicle.model}".trim().isNotEmpty
                        ? "${vehicle.make} ${vehicle.model}"
                        : "N/A",
                    amount: doubleAmount,
                    received: doublePaid,
                  balance: doubleBalance,

                    receivedLabel: "Paid",
                    receivedLabelColor: Colors.green,
                    status: computedStatus,
                    titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                    showMenu: true,
                   addTopSubtitleSpacing: false,  // disables that 4px space only here
                   showBalanceBelowPaid: true,
                   onView: () {
  showDialog(
    context: context,
    builder: (_) => BrokerageDialog(
      brokerage: brokerage,
      isViewOnly: true,
    ),
  );
},

onEdit: () {
  showDialog(
    context: context,
    builder: (_) => BrokerageDialog(
      brokerage: brokerage,
      isViewOnly: false,
    ),
  );
},

                 onDelete: () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Confirm Delete'),
      content: const Text('Are you sure you want to delete this brokerage record?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
      ],
    ),
  );

  if (confirm == true) {
    await ref.read(brokerageProvider.notifier).deleteBrokerage(brokerage.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Brokerage deleted')),
    );
  }
},

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


 // return Card(
          //   color: Colors.white,
          //   elevation: 3,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   margin: const EdgeInsets.only(bottom: 16),
          //   child: Padding(
          //     padding: const EdgeInsets.all(16),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         // Name + Amount + Menu
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Expanded(
          //               child: Text(
          //                 brokerage.brokerName.toUpperCase(),
          //                 style: const TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 16,
          //                   color: Colors.blue,
          //                 ),
          //               ),
          //             ),
          //             Row(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 Text(
          //                   "₹$formattedAmount",
          //                   style: const TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 16,
          //                     color: Colors.blue,
          //                   ),
          //                 ),
          //                 const SizedBox(width: 8),
          //                 PopupMenuButton<String>(
          //                   icon: const Icon(Icons.more_vert),
          //                   onSelected: (value) {
          //                     if (value == 'edit') {
          //                       // TODO: Handle edit
          //                     } else if (value == 'delete') {
          //                       // TODO: Handle delete
          //                     }
          //                   },
          //                   itemBuilder: (context) => const [
          //                     PopupMenuItem(
          //                       value: 'edit',
          //                       child: Text('Edit'),
          //                     ),
          //                     PopupMenuItem(
          //                       value: 'delete',
          //                       child: Text('Delete'),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //         const SizedBox(height: 8),
          //         Text(
          //           "${vehicle.make} ${vehicle.model}",
          //           style: const TextStyle(
          //             fontSize: 14,
          //             color: Colors.grey,
          //           ),
          //         ),
          //         const SizedBox(height: 6),
          //         Text(
          //           brokerage.remarks?.isNotEmpty == true
          //               ? brokerage.remarks!
          //               : "No remarks",
          //           style: const TextStyle(
          //             fontSize: 13,
          //             color: Colors.blue,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // );


          /*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/brokerage.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class ScreenBrokerage extends ConsumerWidget {
  const ScreenBrokerage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleState = ref.watch(vehicleProvider);

    final List<Map<String, dynamic>> brokerageEntries = [];

    for (final vehicle in vehicleState.vehicles) {
      final brokerages = vehicle.brokerageInfo ?? [];
      for (final brokerage in brokerages) {
        brokerageEntries.add({'vehicle': vehicle, 'brokerage': brokerage});
      }
    }

    // if (brokerageEntries.isEmpty) {
    //   return const Center(child: Text('No brokerage records found.'));
    // }

    return Scaffold(
      // appBar: AppBar(title: const Text('Brokerage')),
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "Brokerage",
              onBack: () {
                //last index wanna do at later
              },
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
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: brokerageEntries.length,
                itemBuilder: (context, index) {
                  final vehicle = brokerageEntries[index]['vehicle'] as Vehicle;
                  final brokerage =
                      brokerageEntries[index]['brokerage'] as Brokerage;

                  final doubleAmount = double.tryParse(brokerage.amount) ?? 0;

                  // final formattedAmount = NumberFormat('#,##0')
                  //     .format(int.tryParse(brokerage.amount) ?? 0);

                  String receivedLabel;
                  Color receivedLabelColor;

                  return OutputCard(
                    title: brokerage.brokerName.toUpperCase(),
                    subtitle:
                        "${vehicle.make} ${vehicle.model}".trim().isNotEmpty
                        ? "${vehicle.make} ${vehicle.model}"
                        : "N/A",
                    amount: doubleAmount,
                    received: doubleAmount,
                    receivedLabel: "Paid",
                    titleStyle: TextStyle(fontWeight: FontWeight.bold),

                    showMenu: true,
                    onView: () {
                      // Your onView code
                    },
                    onEdit: () {
                      // Your onEdit code
                    },
                    onDelete: () {
                      // Your onDelete code
                    },
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


 // return Card(
          //   color: Colors.white,
          //   elevation: 3,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   margin: const EdgeInsets.only(bottom: 16),
          //   child: Padding(
          //     padding: const EdgeInsets.all(16),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         // Name + Amount + Menu
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Expanded(
          //               child: Text(
          //                 brokerage.brokerName.toUpperCase(),
          //                 style: const TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 16,
          //                   color: Colors.blue,
          //                 ),
          //               ),
          //             ),
          //             Row(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 Text(
          //                   "₹$formattedAmount",
          //                   style: const TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 16,
          //                     color: Colors.blue,
          //                   ),
          //                 ),
          //                 const SizedBox(width: 8),
          //                 PopupMenuButton<String>(
          //                   icon: const Icon(Icons.more_vert),
          //                   onSelected: (value) {
          //                     if (value == 'edit') {
          //                       // TODO: Handle edit
          //                     } else if (value == 'delete') {
          //                       // TODO: Handle delete
          //                     }
          //                   },
          //                   itemBuilder: (context) => const [
          //                     PopupMenuItem(
          //                       value: 'edit',
          //                       child: Text('Edit'),
          //                     ),
          //                     PopupMenuItem(
          //                       value: 'delete',
          //                       child: Text('Delete'),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //         const SizedBox(height: 8),
          //         Text(
          //           "${vehicle.make} ${vehicle.model}",
          //           style: const TextStyle(
          //             fontSize: 14,
          //             color: Colors.grey,
          //           ),
          //         ),
          //         const SizedBox(height: 6),
          //         Text(
          //           brokerage.remarks?.isNotEmpty == true
          //               ? brokerage.remarks!
          //               : "No remarks",
          //           style: const TextStyle(
          //             fontSize: 13,
          //             color: Colors.blue,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // );
          */