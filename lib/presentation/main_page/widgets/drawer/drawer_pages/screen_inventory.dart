import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/widgets/inventory/add_vehicle_form.dart';
import 'package:my_new_project/widgets/inventory/inventory_filter_row.dart';
import 'package:my_new_project/widgets/inventory/inventory_vehicle_card.dart';
import 'package:my_new_project/widgets/inventory/screen_vehicle_details.dart';

import 'package:my_new_project/widgets/common_search_bar.dart';

//  Text('Inventory'),
class ScreenInventory extends StatefulWidget {
  const ScreenInventory({super.key});

  @override
  State<ScreenInventory> createState() => _ScreenInventoryState();
}

class _ScreenInventoryState extends State<ScreenInventory> {
  String selectedStatus = 'All Status';
  String selectedSort = 'Newest First';
  bool showAddForm = false;
  Vehicle? vehicleToEdit;

  bool showVehicleDetails = false;
  Vehicle? selectedVehicle;

  final Box<Vehicle> vehicleBox = Hive.box<Vehicle>('vehicles');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.amber,
      //   title: Text(showAddForm ? 'Add New Vehicle' : '' ), // 'inventory' add in add new vehicle
      // ),
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
          : ValueListenableBuilder(
              valueListenable: Hive.box<Vehicle>('vehicles').listenable(),
              builder: (context, box, _) {
                //getting all vehicles
                List<Vehicle> vehicles = box.values.toList();

                // List<dynamic> Keys = box.keys .toList();

                //calling delete from the hive and refresh ui

                //apply filter by status
                if (selectedStatus != 'All Status') {
                  vehicles = vehicles
                      .where((v) => v.status == selectedStatus)
                      .toList();
                }

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
                return Column(
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
                                final Vehicle = vehicles[index];

                                return InventoryVehicleCard(
                                  title: Vehicle.title,
                                  imageUrl: Vehicle.imageUrl,
                                  price: Vehicle.price,
                                  mileage: Vehicle.mileage,
                                  color: Vehicle.color,
                                  vin: Vehicle.vin,
                                  task: Vehicle.task,
                                  status: Vehicle.status,
                                  year: Vehicle.year,
                                  onDelete: () async {
                                    final vehicle = vehicles[index];
                                    //get the vehicle
                                    final vehicleKey = box.keyAt(index);
                                    //safer way to get the key

                                    final partnershipBox =
                                        Hive.box<Partnership>('partnerships');
                                    final partnershipId =
                                        vehicle.partnership?.id;

                                    // 1. Delete partnership if it exists
                                    if (partnershipId != null &&
                                        partnershipBox.containsKey(
                                          partnershipId,
                                        )) {
                                      await partnershipBox.delete(
                                        partnershipId,
                                      );
                                    }
                                    // 2. Delete vehicle
                                    await vehicleBox.delete(vehicleKey);

                                    setState(() {
                                      //refresh ui
                                    });
                                  },

                                  onEdit: () {
                                    setState(() {
                                      vehicleToEdit = vehicles[index];
                                      showAddForm = true;
                                    });
                                  },
                                  onTap: () {
                                    setState(() {
                                      selectedVehicle = Vehicle;
                                      showVehicleDetails = true;
                                    });
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
