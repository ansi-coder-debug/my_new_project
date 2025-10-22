import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/infrastructure/vehicle/vehicle_service.dart';

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final vehicleService = ref.watch(vehicleServiceProvider);
  return VehicleRepository(vehicleService);
});

class VehicleRepository {
  final VehicleService _vehicleService;

  VehicleRepository(this._vehicleService);

  Future<List<Vehicle>> getVehicles() async {
    return await _vehicleService.getVehicles();
  }

  // ✅ FIXED: Properly return the created vehicle
  Future<Vehicle> addVehicle(Vehicle vehicle) async {
    return await _vehicleService.addVehicle(vehicle);
  }

  // ✅ FIXED: Properly return the updated vehicle
  Future<Vehicle> updateVehicle(Vehicle vehicle) async {
    return await _vehicleService.updateVehicle(vehicle);
  }

  Future<Vehicle> markVehicleAsSold(String vehicleId, Map<String, dynamic> saleData) async {
    return await _vehicleService.markVehicleAsSold(vehicleId, saleData);
  }

  Future<void> deleteVehicle(String id) async {
    await _vehicleService.deleteVehicle(id);
  }

  Future<void> updateVehicleStatus(String vehicleId, String status) async {
    await _vehicleService.updateVehicleStatus(vehicleId, status);
  }
}