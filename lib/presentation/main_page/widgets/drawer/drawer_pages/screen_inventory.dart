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
  //Global Key
  final GlobalKey<AddVehicleFormState> addFormKey =
      GlobalKey<AddVehicleFormState>();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vehicleProvider.notifier).loadVehicles();
    });
  }

  @override
  // here need to change because it is hive we are changing to riverpod
  Widget build(BuildContext context) {
    // Watch the vehicle state from Riverpod
    final state = ref.watch(vehicleProvider);
    

    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(child: Text('Error:${state.error}'));
    }

      // Show empty state if no vehicles
    if (state.vehicles.isEmpty) {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No Vehicle Found '),
          ElevatedButton(onPressed: ()=>ref.read(vehicleProvider.notifier).loadVehicles(),
           child: Text('Refresh'))
        ],
      ));
    }

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
          ? Builder(
              builder: (context) {
                final vehicleToEdit = ref.watch(vehicleProvider).vehicleToEdit;
                debugPrint("📤 vehicleToEdit inside Builder: $vehicleToEdit");
               
                print(
                  "📤 vehicleToEdit BEFORE building AddVehicleForm: ${state.vehicleToEdit}",
                );

                return AddVehicleForm(
                  // key: ValueKey(state.vehicleToEdit?.id ?? 'new'),
                  key: ValueKey(
                    "${state.vehicleToEdit?.id}-${state.showAddForm}-${DateTime.now().millisecondsSinceEpoch}",
                  ),
                  formKey: addFormKey,
                  vehicleToEdit: state.vehicleToEdit,
                  onCancel: () {
                    addFormKey.currentState
                        ?.resetFormFields(); //clear form first
                    // showAddForm = false;
                    ref.read(vehicleProvider.notifier).clearVehicleToEdit();
                    ref.read(vehicleProvider.notifier).setShowAddForm(false);
                  },
                  onAddComplete: () {
                    // showAddForm = false;
                    // ref.read(vehicleProvider.notifier).clearVehicleToEdit();
                    // ref.read(vehicleProvider.notifier).setShowAddForm(false);
                  },
                );
              },
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

                  onAddPressed: () async {
                    print('➕ Add New pressed');
                    final notifier = ref.read(vehicleProvider.notifier);

                    // 1. Clear edit state
                    notifier.clearVehicleToEdit();

                    // 2. WAIT for state propagation
                    await Future.delayed(Duration.zero);

                    // 3. Verify state is clear
                    debugPrint(
                      '✅ Current state: ${ref.read(vehicleProvider).vehicleToEdit}',
                    );

                    // 4. Now open form
                    notifier.setShowAddForm(true);
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
                              title: '${vehicle.make}${vehicle.model}',
                              // imageUrl: vehicle.photos.isNotEmpty?vehicle.photos[0]:'',
                            
                    imageUrl: vehicle.photos.isNotEmpty?vehicle.photos[0]:'',
    
                              price: vehicle.price,
                              registrationId: vehicle.registrationId,
                              color: vehicle.color,
                              vin: '',
                              task: '',
                              status: vehicle.status,
                              year: vehicle.year,

                              // Delete logic calls provider, not Hive directly
                              onDelete: () async {
                                // final partnershipBox = Hive.box<Partnership>(
                                //   'partnerships',
                                // );
                                // final partnershipId = vehicle.partnership?.id;

                                // // 1. Delete partnership if it exists

                                // if (partnershipId != null &&
                                //     partnershipBox.containsKey(partnershipId)) {
                                //   await partnershipBox.delete(partnershipId);
                                // }

                                //keeping only the Api call 
                                await ref.read(vehicleProvider.notifier).deleteVehicle(vehicle.id);//read triggering action ,//watch changing state
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









