import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/vehicle.dart';
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
  String selectedStatus = 'All Status';
  String selectedSort = 'Newest First';
  bool showAddForm = false;
  Vehicle? vehicleToEdit;

  bool showVehicleDetails = false;
  Vehicle? selectedVehicle;

  // final Box<Vehicle> vehicleBox = Hive.box<Vehicle>(
  //   'vehicles',
  // ); 

   //here need to change because it is hive we are changing to riverpod

  @override
  Widget build(BuildContext context) {
    // Listen to vehicleProvider instead of Hive directly
    final vehicleList = ref.watch(vehicleProvider);

    List<Vehicle> vehicles = [...vehicleList];

    //apply filter by status
    if (selectedStatus != 'All Status') {
      vehicles = vehicles.where((v) => v.status == selectedStatus).toList();
    }

    //apply sort

    vehicles.sort((a, b) {
      switch (selectedSort) {
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
                setState(() {
                  showAddForm = false;
                });
              },
              onAddComplete: () {
                setState(() {
                  showAddForm = false;
                });
              },
              vehicleToEdit: vehicleToEdit,
            )
          : showVehicleDetails && selectedVehicle != null
          ? ScreenVehicleDetails(
              vehicle: selectedVehicle!,
              onBack: () {
                setState(() {
                  showVehicleDetails = false;
                  selectedVehicle = null;
                });
              },
              onEdit: () {
                setState(() {
                  vehicleToEdit = selectedVehicle;
                  showVehicleDetails = false;
                  showAddForm = true;
                });
              },
            )
          : Column(
              children: [
                CommonSearchBar(
                  labelText: 'Inventory vehicles',
                  hintText: 'Search Vehicles',
                  onChanged: (query) {
                    setState(() {
                      // Optional: Add search functionality if you want
                    });
                  },
                ),

                InventoryFilterRow(
                  selectedStatus: selectedStatus,
                  selectedSort: selectedSort,

                  onStatusChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },

                  onSortingChanged: (value) {
                    setState(() {
                      selectedSort = value!;
                    });
                  },

                  onAddPressed: () {
                    setState(() {
                      vehicleToEdit = null;
                      showAddForm = true;
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
                              mileage: vehicle.mileage,
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
                                setState(() {
                                  vehicleToEdit = vehicles[index];
                                  showAddForm = true;
                                });
                              },
                              onTap: () {
                                setState(() {
                                  selectedVehicle = vehicle;
                                  showVehicleDetails = true;
                                });
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
