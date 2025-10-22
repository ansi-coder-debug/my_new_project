import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/partnership/partnership_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/widgets/partnerships/partnership_dialog.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

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
          allPartnerships.add({'vehicle': vehicle, 'partnership': partnership});
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "Partnerships",
              // onBack: (){},
              onFilter: () {
                // TODO: Open filter dialog
              },
              onRefresh: () {
                // provider
              },
              onSearch: () {
                // TODO: Implement search
              },
              showAdd: false,
            ),
            KHeight,

            Expanded(
              child: state.isLoading
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
                            partnership.partnerName ??
                            partnership.partner?.name ??
                            'Unknown';
                        final vehicleName = '${vehicle.make} ${vehicle.model}';
                        final contribution =
                            double.tryParse(partnership.contribution ?? '0') ??
                            0.0;
                        final paymentMode = partnership.paymentMode ?? 'N/A';

                        // ✅ NEW STATUS LOGIC:
                        final total =
                            double.tryParse(partnership.contribution ?? '0') ??
                            0.0;
                        final received =
                            contribution; // using the same value for now

                        String contributionStatus;
                        if (received >= total && total > 0) {
                          contributionStatus = 'paid';
                        } else if (received > 0 && received < total) {
                          contributionStatus = 'partial';
                        } else {
                          contributionStatus = 'pending';
                        }

                        return OutputCard(
                          title: partnerName,
                          subtitle: vehicleName,
                          amount: contribution,
                          received: contribution,
                          receivedLabel:
                              contributionStatus[0].toUpperCase() +
                              contributionStatus.substring(1),

                          // paymentMode: paymentMode,
                          status: contributionStatus,
                          showMenu: true,

                          onView: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AddPartnershipDialog(
                                partnership:
                                    partnership, // the current partnership object
                                isViewOnly: true, // ✅ makes fields read-only
                              ),
                            );
                          },
                          onEdit: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AddPartnershipDialog(
                                partnership:
                                    partnership, // pass the object to edit
                                isViewOnly: false, // ✅ allows editing
                              ),
                            );
                          },
                          onDelete: () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Delete Partnership"),
      content: const Text("Are you sure you want to delete this partnership?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text("Delete"),
        ),
      ],
    ),
  );

  if (confirm == true) {
    ref.read(partnershipProvider.notifier).deletePartnership(partnership.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Partnership deleted")),
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

/* return Card(
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
                    */
