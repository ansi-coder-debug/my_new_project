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
// add these for update delete etcc 
 Future<void> addVehicle(Vehicle vehicle) async {
    await _vehicleService.addVehicle(vehicle);
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await _vehicleService.updateVehicle(vehicle);
  }

  Future<void> deleteVehicle(String id) async {
    await _vehicleService.deleteVehicle(id);
  }

}
