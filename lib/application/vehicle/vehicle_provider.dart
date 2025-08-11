// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:my_new_project/application/vehicle/vehicle_state.dart';
// import 'package:my_new_project/core/models/vehicle.dart';

// // This provider gives us access to the Hive vehicle box
// final vehicleBoxProvider = Provider<Box<Vehicle>>((ref) {
//   return Hive.box<Vehicle>('vehicles');
//   //Make sure this box is opened in main()
// });

// // This Notifier manages the list of vehicles using Riverpod's StateNotifier
// class VehicleNotifier extends StateNotifier<VehicleState> {
//   final Box<Vehicle> _vehicleBox;

  

//   // Constructor gets the vehicleBox from Provider and loads all vehicles
//   VehicleNotifier(this._vehicleBox) : super(VehicleState(vehicles: [])) {
//     // Initialize state with existing Hive data
//     _loadVehiclesFromHive();
//   }
//   void _loadVehiclesFromHive() {
//     final vehicles = _vehicleBox.values.toList();
//     // Instead of replacing the whole state, we update just the vehicles
//     state = state.copyWith(vehicles: vehicles);
//   }

//   //show/hide add vehicle form
//   void setShowAddForm(bool value) {
//     state = state.copyWith(showAddForm: value);
//   }

//   // 🔘 Show/hide the Vehicle Details screen
//   void setShowVehicleDetails(bool value) {
//     state = state.copyWith(showVehicleDetails: value);
//   }

//   // 📍 Set which vehicle is selected to view details
//   void setSelectedVehicle(Vehicle? vehicle) {
//     state = state.copyWith(selectedVehicle: vehicle);
//   }

//   //  Set which vehicle is being edited
//   void setVehicleToEdit(Vehicle? vehicle) {
//     state = state.copyWith(vehicleToEdit: vehicle);
//   }

//   //  Update selected status filter (e.g., Sold, Available)
//   void setSelectedStatus(String status) {
//     state = state.copyWith(selectedStatus: status);
//   }

//   // ↕ Update selected sorting option
//   void setSelectedSort(String sort) {
//     state = state.copyWith(selectedSort: sort);
//   }

//   // Load all vehicles from Hive and set it to the current state

//   Future<void> addVehicle(Vehicle vehicle) async {
//     await _vehicleBox.put(vehicle.id, vehicle); //add
//     _loadVehiclesFromHive();
//     state = state.copyWith(showAddForm: false, vehicleToEdit: null);
//   }

//   Future<void> updateVehicle(Vehicle vehicle) async {
//     await _vehicleBox.put(vehicle.id, vehicle); // update
//     _loadVehiclesFromHive();
//     state = state.copyWith(showAddForm: false, vehicleToEdit: null);
//   }

//   Future<void> deleteVehicle(String id) async {
//     await _vehicleBox.delete(id); //delete
//     _loadVehiclesFromHive();
//   }

//   Vehicle? getVehicleById(String id) {
//     return _vehicleBox.get(id);
//   }

//   // editing null everytime new opens
//   void clearVehicleToEdit() {
//     state = state.copyWith(
//       vehicleToEdit: null,
//       clearVehicleToEdit: true,
//       showAddForm: false,
//       selectedVehicle: null, // Clear any selection
//       clearSelectedVehicle: true,
//     );
//      // Verify null
    
//   }
// }

// // this is the main Riverpod Provider for vehicle states
// final vehicleProvider = StateNotifierProvider<VehicleNotifier, VehicleState>((
//   ref,
// ) {
//   final box = ref.watch(vehicleBoxProvider);
//   return VehicleNotifier(box);
// });


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/vehicle/vehicle_state.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/infrastructure/vehicle/vehicle_repositary.dart';
// import 'package:my_new_project/infrastructure/vehicle/vehicle_repository.dart'; // Fixed import name

final vehicleProvider = StateNotifierProvider<VehicleNotifier, VehicleState>((ref) {
  final repository = ref.watch(vehicleRepositoryProvider); // Fixed provider name
  return VehicleNotifier(repository);
});

class VehicleNotifier extends StateNotifier<VehicleState> {
  final VehicleRepository _vehicleRepositary; // Fixed type name

  VehicleNotifier(this._vehicleRepositary) : super(VehicleState(vehicles: [])) {
    loadVehicles(); // Fetch from backend immediately
  }

  Future<void> loadVehicles() async {
    state = state.copyWith(isLoading: true);
    try {
      final vehicles = await _vehicleRepositary.getVehicles();
      print('✅ Successfully fetched ${vehicles.length} vehicles'); // Debug log
      state = state.copyWith(vehicles: vehicles, isLoading: false, error: null);
    } catch (e) {
      print('❌ Error loading vehicles: $e',); // Debug log
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Show/hide add vehicle form
  void setShowAddForm(bool value) {
    state = state.copyWith(showAddForm: value);
  }

  // Show/hide the Vehicle Details screen
  void setShowVehicleDetails(bool value) {
    state = state.copyWith(showVehicleDetails: value);
  }

  // Set which vehicle is selected to view details
  void setSelectedVehicle(Vehicle? vehicle) {
    state = state.copyWith(selectedVehicle: vehicle);
  }

  // Set which vehicle is being edited
  void setVehicleToEdit(Vehicle? vehicle) {
    state = state.copyWith(vehicleToEdit: vehicle);
  }

  // Update selected status filter (e.g., Sold, Available)
  void setSelectedStatus(String status) {
    state = state.copyWith(selectedStatus: status);
  }

  // Update selected sorting option
  void setSelectedSort(String sort) {
    state = state.copyWith(selectedSort: sort);
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    state = state.copyWith(isLoading: true);
    try {
      await _vehicleRepositary.addVehicle(vehicle);
      await loadVehicles(); // Refresh list after adding
      state = state.copyWith(showAddForm: false, vehicleToEdit: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    state = state.copyWith(isLoading: true);
    try {
      await _vehicleRepositary.updateVehicle(vehicle);
      await loadVehicles(); // Refresh list after updating
      state = state.copyWith(showAddForm: false, vehicleToEdit: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteVehicle(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _vehicleRepositary.deleteVehicle(id);
      await loadVehicles(); // Refresh list after deleting
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Vehicle? getVehicleById(String id) {
    // Find vehicle in current state list
    return state.vehicles.firstWhere(
      (vehicle) => vehicle.id == id,
      // orElse: ()=>null,
    );
  }

  void clearVehicleToEdit() {
    state = state.copyWith(
      vehicleToEdit: null,
      clearVehicleToEdit: true,
      showAddForm: false,
      selectedVehicle: null,
      // Add flags to ensure clearing
      clearSelectedVehicle: true,
      
    );
  }
}