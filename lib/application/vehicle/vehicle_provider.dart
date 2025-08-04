import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_new_project/application/vehicle/vehicle_state.dart';
import 'package:my_new_project/core/models/vehicle.dart';

// This provider gives us access to the Hive vehicle box
final vehicleBoxProvider = Provider<Box<Vehicle>>((ref) {
  return Hive.box<Vehicle>('vehicles');
  //Make sure this box is opened in main()
});

// This Notifier manages the list of vehicles using Riverpod's StateNotifier
class VehicleNotifier extends StateNotifier<VehicleState> {
  final Box<Vehicle> _vehicleBox;

  

  // Constructor gets the vehicleBox from Provider and loads all vehicles
  VehicleNotifier(this._vehicleBox) : super(VehicleState(vehicles: [])) {
    // Initialize state with existing Hive data
    _loadVehiclesFromHive();
  }
  void _loadVehiclesFromHive() {
    final vehicles = _vehicleBox.values.toList();
    // Instead of replacing the whole state, we update just the vehicles
    state = state.copyWith(vehicles: vehicles);
  }

  //show/hide add vehicle form
  void setShowAddForm(bool value) {
    state = state.copyWith(showAddForm: value);
  }

  // 🔘 Show/hide the Vehicle Details screen
  void setShowVehicleDetails(bool value) {
    state = state.copyWith(showVehicleDetails: value);
  }

  // 📍 Set which vehicle is selected to view details
  void setSelectedVehicle(Vehicle? vehicle) {
    state = state.copyWith(selectedVehicle: vehicle);
  }

  //  Set which vehicle is being edited
  void setVehicleToEdit(Vehicle? vehicle) {
    state = state.copyWith(vehicleToEdit: vehicle);
  }

  //  Update selected status filter (e.g., Sold, Available)
  void setSelectedStatus(String status) {
    state = state.copyWith(selectedStatus: status);
  }

  // ↕ Update selected sorting option
  void setSelectedSort(String sort) {
    state = state.copyWith(selectedSort: sort);
  }

  // Load all vehicles from Hive and set it to the current state

  Future<void> addVehicle(Vehicle vehicle) async {
    await _vehicleBox.put(vehicle.id, vehicle); //add
    _loadVehiclesFromHive();
    state = state.copyWith(showAddForm: false, vehicleToEdit: null);
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await _vehicleBox.put(vehicle.id, vehicle); // update
    _loadVehiclesFromHive();
    state = state.copyWith(showAddForm: false, vehicleToEdit: null);
  }

  Future<void> deleteVehicle(String id) async {
    await _vehicleBox.delete(id); //delete
    _loadVehiclesFromHive();
  }

  Vehicle? getVehicleById(String id) {
    return _vehicleBox.get(id);
  }

  // editing null everytime new opens
  void clearVehicleToEdit() {
    state = state.copyWith(
      vehicleToEdit: null,
      clearVehicleToEdit: true,
      showAddForm: false,
      selectedVehicle: null, // Clear any selection
      clearSelectedVehicle: true,
    );
     // Verify null
    
  }
}

// this is the main Riverpod Provider for vehicle states
final vehicleProvider = StateNotifierProvider<VehicleNotifier, VehicleState>((
  ref,
) {
  final box = ref.watch(vehicleBoxProvider);
  return VehicleNotifier(box);
});
