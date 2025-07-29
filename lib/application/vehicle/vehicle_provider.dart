import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_new_project/core/models/vehicle.dart';

// This provider gives us access to the Hive vehicle box
final vehicleBoxProvider = Provider<Box<Vehicle>>((ref) {
  return Hive.box<Vehicle>('vehicles');
  //Make sure this box is opened in main()
});

// This Notifier manages the list of vehicles using Riverpod's StateNotifier
class VehicleNotifier extends StateNotifier<List<Vehicle>> {
  final Box<Vehicle> _vehicleBox;

  // Constructor gets the vehicleBox from Provider and loads all vehicles
  VehicleNotifier(this._vehicleBox) : super([]) {
    // Initialize state with existing Hive data
    _loadVehiclesFromHive();
  }

  // Load all vehicles from Hive and set it to the current state
  void _loadVehiclesFromHive() {
    state = _vehicleBox.values
        .toList(); // ui automatically updates current data
  }

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

final vehicleProvider = StateNotifierProvider<VehicleNotifier, List<Vehicle>>((ref) {
  final box = ref.watch(vehicleBoxProvider);
  return VehicleNotifier(box);
});
