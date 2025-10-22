// new code
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/inventory/add_vehicle_form.dart';
import 'package:my_new_project/widgets/inventory/inventory_header.dart';
import 'package:my_new_project/widgets/inventory/inventory_vehicle_card.dart';
import 'package:my_new_project/widgets/inventory/screen_vehicle_details.dart';

import 'package:my_new_project/widgets/inventory/reusable_info_card.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';

class ScreenInventory extends ConsumerStatefulWidget {
  final String? initialStatus;
  final String? selectedStatus;
  const ScreenInventory({
    super.key, 
    this.initialStatus,
    this.selectedStatus
  });

  @override
  ConsumerState<ScreenInventory> createState() => _ScreenInventoryState();
}

class _ScreenInventoryState extends ConsumerState<ScreenInventory> {
  final GlobalKey<AddVehicleFormState> addFormKey =
      GlobalKey<AddVehicleFormState>();

  String? selectedStatus; // ✅ null means "no filter selected"

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vehicleProvider.notifier).loadVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vehicleProvider);
    final vehicles = selectedStatus == null
        ? state.vehicles
        : state.vehicles
              .where(
                (v) => v.status.toLowerCase() == selectedStatus!.toLowerCase(),
              )
              .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            InventoryHeader(
              title: "Vehicles",
              selectedStatus: selectedStatus,
              onStatusSelected: (status) {
                setState(() {
                  selectedStatus = status;
                });
              },
              // onBack: (){},
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (_) => AddVehicleForm(
                    onAddComplete: ref
                        .read(vehicleProvider.notifier)
                        .loadVehicles,
                  ),
                );
              },
              onFilter: () {
                // your filter logic
              },
              onRefresh: () {
                ref.read(vehicleProvider.notifier).loadVehicles();
              },
              onSearch: () {
                // your search logic
              },
            ),

            // CustomHeader(
            //   title: "Vehicles",
            //   onBack: () => Navigator.pop(context),

            //   onFilter: () {},
            //   onRefresh: () {
            //     ref.read(vehicleProvider.notifier).loadVehicles();
            //   },
            //   onSearch: () {},
            //   showAdd: true,
            //   onAdd: () {
            //     showDialog(
            //       context: context,
            //       builder: (_) => AddVehicleForm(
            //         onAddComplete:
            //             ref.read(vehicleProvider.notifier).loadVehicles,
            //       ),
            //     );
            //   },
            // ),

            // // 🔹 Filter Chips Row
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            //   child: Row(
            //     children: [
            //       _buildStatusChip(
            //         "Available",
            //         selectedStatus == 'Available'
            //             ? Colors.green.shade700
            //             : Colors.green.shade50,
            //         selectedStatus == 'Available'
            //             ? Colors.white
            //             : Colors.green.shade700,
            //         () => setState(() {
            //           selectedStatus =
            //               selectedStatus == "Available" ? null : "Available";
            //         }),
            //       ),
            //       const SizedBox(width: 8),
            //       _buildStatusChip(
            //         'Maintenance',
            //         selectedStatus == 'Maintenance'
            //             ? Colors.amber.shade700
            //             : Colors.amber.shade100,
            //         selectedStatus == 'Maintenance'
            //             ? Colors.black
            //             : Colors.brown.shade700,
            //         () => setState(() {
            //           selectedStatus =
            //               selectedStatus == "Maintenance" ? null : "Maintenance";
            //         }),
            //       ),
            //       const SizedBox(width: 8),
            //       _buildStatusChip(
            //         'Sold',
            //         selectedStatus == 'Sold'
            //             ? Colors.red.shade700
            //             : Colors.red.shade50,
            //         selectedStatus == 'Sold'
            //             ? Colors.black
            //             : Colors.red.shade700,
            //         () => setState(() {
            //           selectedStatus =
            //               selectedStatus == "Sold" ? null : "Sold";
            //         }),
            //       ),
            //     ],
            //   ),
            // ),
            Kheight6,

            // 🔹 Vehicle List
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : vehicles.isEmpty
                  ? const Center(child: Text("No vehicles found."))
                  : ListView.builder(
                      itemCount: vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = vehicles[index];
                        return InventoryVehicleCard(
                          vehicle: vehicle,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ScreenVehicleDetails(
                                  vehicleId: vehicle.id,
                                  onBack: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          },
                          onMenu: () {
                            // TODO: show options
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

  Widget _buildStatusChip(
    String label,
    Color bgColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
