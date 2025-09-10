

// new code 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/widgets/inventory/add_vehicle_form.dart';
import 'package:my_new_project/widgets/inventory/inventory_vehicle_card.dart';
import 'package:my_new_project/widgets/inventory/screen_vehicle_details.dart';

import 'package:my_new_project/widgets/inventory/inventory_filter_row.dart';

class ScreenInventory extends ConsumerStatefulWidget {
  const ScreenInventory({super.key});

  @override
  ConsumerState<ScreenInventory> createState() => _ScreenInventoryState();
}

class _ScreenInventoryState extends ConsumerState<ScreenInventory> {
  final GlobalKey<AddVehicleFormState> addFormKey =
      GlobalKey<AddVehicleFormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vehicleProvider.notifier).loadVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vehicleProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text('Error: ${state.error}'));
    }

    if (state.vehicles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No Vehicle Found'),
            ElevatedButton(
              onPressed: () => ref.read(vehicleProvider.notifier).loadVehicles(),
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    // Filter and sort vehicles
    var vehicles = [...state.vehicles];
    if (state.selectedStatus != 'All Status') {
      vehicles = vehicles.where((v) => v.status == state.selectedStatus).toList();
    }

    vehicles.sort((a, b) {
      switch (state.selectedSort) {
        case 'Newest First':
          return b.year.compareTo(a.year);
        case 'Oldest First':
          return a.year.compareTo(b.year);
        case 'Price High to Low':
          return int.parse(b.price.replaceAll(',', ''))
              .compareTo(int.parse(a.price.replaceAll(',', '')));
        case 'Price Low to High':
          return int.parse(a.price.replaceAll(',', ''))
              .compareTo(int.parse(b.price.replaceAll(',', '')));
        default:
          return 0;
      }
    });

    final showAddForm = state.showAddForm;
    final showVehicleDetails = state.showVehicleDetails;
    final selectedVehicle = state.selectedVehicle;

    return Scaffold(
      body: showAddForm
          ? AddVehicleForm(
              key: ValueKey(
                "${DateTime.now().millisecondsSinceEpoch}-${state.showAddForm}",
              ),
              formKey: addFormKey,
              vehicleToEdit: state.vehicleToEdit, // Always adding, not editing
              onCancel: () {
                addFormKey.currentState?.resetFormFields();
                
    ref.read(vehicleProvider.notifier).clearVehicleToEdit();
                ref.read(vehicleProvider.notifier).setShowAddForm(false);
              },
              onAddComplete: () {
                 ref.read(vehicleProvider.notifier).clearVehicleToEdit();
                ref.read(vehicleProvider.notifier).setShowAddForm(false);
              },
            )
          : showVehicleDetails && selectedVehicle != null
              ? ScreenVehicleDetails(

                  vehicleId: selectedVehicle!.id,
                  onBack: () {
                    ref.read(vehicleProvider.notifier).setShowVehicleDetails(false);
                    ref.read(vehicleProvider.notifier).setSelectedVehicle(null);
                  },

                  onEdit: () {
                       ref.read(vehicleProvider.notifier).setVehicleToEdit(selectedVehicle);
    ref.read(vehicleProvider.notifier).setShowVehicleDetails(false);
    ref.read(vehicleProvider.notifier).setShowAddForm(true);
                  },
                )
              : Column(
                  children: [
                    // CommonSearchBar(
                    //   labelText: 'Inventory vehicles',
                    //   hintText: 'Search Vehicles',
                    //   onChanged: (query) {},
                    // ),
                    InventoryFilterRow(
                      selectedStatus: state.selectedStatus,
                      selectedSort: state.selectedSort,
                      onStatusChanged: (value) {
                        ref.read(vehicleProvider.notifier).setSelectedStatus(value!);
                      },
                      onSortingChanged: (value) {
                        ref.read(vehicleProvider.notifier).setSelectedSort(value!);
                      },
                      onAddPressed: () async {
                        final notifier = ref.read(vehicleProvider.notifier);

                        // Clear any edit state (just in case)
                        notifier.clearVehicleToEdit();

                        await Future.delayed(Duration.zero);

                        // Show add form
                        notifier.setShowAddForm(true);
                      },
                    ),
                    Expanded(
                      child: vehicles.isEmpty
                          ? const Center(child: Text('No Vehicle Found'))
                          : ListView.builder(
                              itemCount: vehicles.length,
                              itemBuilder: (context, index) {
                                final vehicle = vehicles[index];
                                return InventoryVehicleCard(
                                  title: '${vehicle.make} ${vehicle.model}',
                                  imageUrl: vehicle.photos.isNotEmpty
                                      ? vehicle.photos.first
                                      : '',
                                  price: vehicle.price,
                                  registrationId: vehicle.registrationId,
                                  color: vehicle.color,
                                  fuel: vehicle.fuelType,
                                  mileage: vehicle.mileage.toString(),
                                  purchaseDate: vehicle.purchaseDate != null
                                      ? vehicle.purchaseDate.toString().split('T').first
                                      : '',
                                  status: vehicle.status,
                                  year: vehicle.year,
                                  onTap: () {
                                    ref.read(vehicleProvider.notifier).setSelectedVehicle(vehicle);
                                    ref.read(vehicleProvider.notifier).setShowVehicleDetails(true);
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
