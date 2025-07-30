


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_new_project/core/models/vehicle.dart';

class VehicleState {
  //determing
  final List<Vehicle> vehicles;
  final String selectedStatus;
  final String selectedSort;
  final bool showAddForm;
  final bool showVehicleDetails;
  final Vehicle? vehicleToEdit;
  final Vehicle? selectedVehicle;

  // initialising

  VehicleState({
    required this.vehicles,
    this.selectedStatus = 'All Status', // default sttings
    this.selectedSort = 'Newest First',
    this.showAddForm = false,
    this.showVehicleDetails = false,
    this.vehicleToEdit,
    this.selectedVehicle,
  });

  // copyWith` lets us update just parts of the state,
  //     without overwriting everything
  VehicleState copyWith({
    List<Vehicle>? vehicles,
    String? selectedStatus,
    String? selectedSort,
    bool? showAddForm,
    bool? showVehicleDetails,
    Vehicle? vehicleToEdit,
    Vehicle? selectedVehicle,
  }) {
    return VehicleState(
      vehicles: vehicles ?? this.vehicles,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedSort: selectedSort ?? this.selectedSort,
      showAddForm: showAddForm ?? this.showAddForm,
      showVehicleDetails: showVehicleDetails ?? this.showVehicleDetails,
      vehicleToEdit: vehicleToEdit ?? this.vehicleToEdit,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
    );
  }
}

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
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await _vehicleBox.put(vehicle.id, vehicle); // update
    _loadVehiclesFromHive();
  }

  Future<void> deleteVehicle(String id) async {
    await _vehicleBox.delete(id); //delete
    _loadVehiclesFromHive();
  }

  Vehicle? getVehicleById(String id) {
    return _vehicleBox.get(id);
  }
}


// this is the main Riverpod Provider for vehicle states
final vehicleProvider = StateNotifierProvider<VehicleNotifier, VehicleState>(
  (ref) {
  final box = ref.watch(vehicleBoxProvider);
  return VehicleNotifier(box);
});



















