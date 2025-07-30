import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/models/partnership.dart';
// import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/widgets/inventory/add_vehicle_form.dart';
import 'package:my_new_project/widgets/inventory/inventory_filter_row.dart';
import 'package:my_new_project/widgets/inventory/inventory_vehicle_card.dart';
import 'package:my_new_project/widgets/inventory/screen_vehicle_details.dart';

import 'package:my_new_project/widgets/common_search_bar.dart';

//  Text('Inventory'),
class ScreenInventory extends ConsumerStatefulWidget {
  const ScreenInventory({super.key});

  @override
  ConsumerState<ScreenInventory> createState() => _ScreenInventoryState();
}

class _ScreenInventoryState extends ConsumerState<ScreenInventory> {
  //here need to change because it is hive we are changing to riverpod

  @override
  Widget build(BuildContext context) {
    // Watch the vehicle state from Riverpod
    final state = ref.watch(vehicleProvider);
    // List<Vehicle> vehicles = [...vehicleList];

    //acessing everything
    var vehicles = [...state.vehicles];
    final showAddForm = state.showAddForm;
    final showVehicleDetails = state.showVehicleDetails;
    final selectedVehicle = state.selectedVehicle;

    //apply filter by status
    if (state.selectedStatus != 'All Status') {
      vehicles = vehicles
          .where((v) => v.status == state.selectedStatus)
          .toList();
    }

    //apply sort

    vehicles.sort((a, b) {
      switch (state.selectedSort) {
        case 'Newest First': //high means b
          return b.year.compareTo(a.year); // low means a

        case 'Oldest First':
          return a.year.compareTo(b.year);

        case 'Price High to Low':
          return int.parse(
            b.price.replaceAll(',', ''),
          ).compareTo(int.parse(a.price.replaceAll(',', '')));

        case 'Price Low to High':
          return int.parse(
            a.price.replaceAll(',', ''),
          ).compareTo(int.parse(b.price.replaceAll(',', '')));
        default:
          return 0;
      }
    });

    return Scaffold(
      body: showAddForm
          ? AddVehicleForm(
              onCancel: () {
                // showAddForm = false;
                ref.read(vehicleProvider.notifier).setShowAddForm(false);
              },
              onAddComplete: () {
                // showAddForm = false;
                ref.read(vehicleProvider.notifier).setShowAddForm(false);
              },
              vehicleToEdit: state.vehicleToEdit,
            )
          : showVehicleDetails && selectedVehicle != null
          ? ScreenVehicleDetails(
              vehicle: selectedVehicle!,
              onBack: () {
                // showVehicleDetails = false;
                ref.read(vehicleProvider.notifier).setShowVehicleDetails(false);
                // selectedVehicle = null;
                ref.read(vehicleProvider.notifier).setSelectedVehicle(null);
              },
              onEdit: () {
                // vehicleToEdit = selectedVehicle;
                ref
                    .read(vehicleProvider.notifier)
                    .setVehicleToEdit(selectedVehicle);

                // showVehicleDetails = false;
                ref.read(vehicleProvider.notifier).setShowVehicleDetails(false);
                // showAddForm = true;
                ref.read(vehicleProvider.notifier).setShowAddForm(true);
              },
            )
          : Column(
              children: [
                CommonSearchBar(
                  labelText: 'Inventory vehicles',
                  hintText: 'Search Vehicles',
                  onChanged: (query) {
                    // setState(() {
                    //   // Optional: Add search functionality if you want
                    // });
                  },
                ),

                InventoryFilterRow(
                  selectedStatus: state.selectedStatus,
                  selectedSort: state.selectedSort,

                  onStatusChanged: (value) {
                    // selectedStatus = value!;
                    ref
                        .read(vehicleProvider.notifier)
                        .setSelectedStatus(value!);
                  },

                  onSortingChanged: (value) {
                    // selectedSort = value!;
                    ref.read(vehicleProvider.notifier).setSelectedSort(value!);
                  },

                  onAddPressed: () {
                    // vehicleToEdit = null;
                    ref.read(vehicleProvider.notifier).setVehicleToEdit(null);
                    // showAddForm = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref.read(vehicleProvider.notifier).setShowAddForm(true);
                    });
                  },
                ),

                Expanded(
                  child: vehicles.isEmpty
                      ? Center(child: Text('No Vehicle Found'))
                      : ListView.builder(
                          itemCount: vehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = vehicles[index];

                            return InventoryVehicleCard(
                              title: vehicle.title,
                              imageUrl: vehicle.imageUrl,
                              price: vehicle.price,
                             registrationId : vehicle.registrationId,
                              color: vehicle.color,
                              vin: vehicle.vin,
                              task: vehicle.task,
                              status: vehicle.status,
                              year: vehicle.year,

                              // Delete logic calls provider, not Hive directly
                              onDelete: () async {
                                final partnershipBox = Hive.box<Partnership>(
                                  'partnerships',
                                );
                                final partnershipId = vehicle.partnership?.id;

                                // 1. Delete partnership if it exists

                                if (partnershipId != null &&
                                    partnershipBox.containsKey(partnershipId)) {
                                  await partnershipBox.delete(partnershipId);
                                }

                                // using vehicleprovider to delete
                                await ref
                                    .read(
                                      vehicleProvider.notifier,
                                    ) //read triggering action ,//watch changing state
                                    .deleteVehicle(vehicle.id);
                              },

                              onEdit: () {
                                // vehicleToEdit = vehicles[index];
                                ref
                                    .read(vehicleProvider.notifier)
                                    .setVehicleToEdit(vehicles[index]);
                                // showAddForm = true;
                                ref
                                    .read(vehicleProvider.notifier)
                                    .setShowAddForm(true);
                              },
                              onTap: () {
                                // selectedVehicle = vehicle;
                                ref
                                    .read(vehicleProvider.notifier)
                                    .setSelectedVehicle(vehicle);
                                // showVehicleDetails = true;
                                ref
                                    .read(vehicleProvider.notifier)
                                    .setShowVehicleDetails(true);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

// | Widget            | Use `ref.watch()` in build? | Why?                                 |
// | ----------------- | --------------------------- | ------------------------------------ |
// | `ScreenInventory` | ✅ Yes                       | UI depends on vehicle list updates   |
// | `AddVehicleForm`  | ❌ No                        | Form does not rebuild on data change |
