
import 'package:my_new_project/core/models/vehicle.dart';

class VehicleState {
  final List<Vehicle> vehicles;
  final bool isLoading;
  final String? error;
  final Vehicle? vehicleToEdit;
  final bool showAddForm;
  final bool showVehicleDetails;
  // sale
  final bool showSaleForm;
  final Vehicle? vehicleToSell;

  const VehicleState({
    this.vehicles = const [],
    this.isLoading = false,
    this.error,
    this.vehicleToEdit,
    this.showAddForm = false,
    this.showVehicleDetails = false,

    this.showSaleForm = false,
    this.vehicleToSell,
  });

  VehicleState copyWith({
    List<Vehicle>? vehicles,
    bool? isLoading,
    String? error,
    Vehicle? vehicleToEdit,
    bool? showAddForm,
    bool? showVehicleDetails,
    bool? showSaleForm,
    Vehicle? vehicleToSell,
  }) {
    return VehicleState(
      vehicles: vehicles ?? this.vehicles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      vehicleToEdit: vehicleToEdit ?? this.vehicleToEdit,
      showAddForm: showAddForm ?? this.showAddForm,
      showVehicleDetails: showVehicleDetails ?? this.showVehicleDetails,
      showSaleForm: showSaleForm ?? this.showSaleForm,
vehicleToSell: vehicleToSell ?? this.vehicleToSell,
    );
  }
}
