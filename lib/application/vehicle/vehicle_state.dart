// import 'package:my_new_project/core/models/vehicle.dart';

// class VehicleState {
//   final List<Vehicle> vehicles;
//   final bool isLoading;
//   final String? error;
//   final String selectedStatus;
//   final String selectedSort;
//   final bool showAddForm;
//   final bool showVehicleDetails;
//   final Vehicle? vehicleToEdit;
//   final Vehicle? selectedVehicle;

//   VehicleState({
//     required this.vehicles,
//     this.isLoading = false,
//     this.error,
//     this.selectedStatus = 'All Status',
//     this.selectedSort = 'Newest First',
//     this.showAddForm = false,
//     this.showVehicleDetails = false,
//     this.vehicleToEdit,
//     this.selectedVehicle,
//   });

//   VehicleState copyWith({
//     List<Vehicle>? vehicles,
//     bool? isLoading,
//     String? error,
//     String? selectedStatus,
//     String? selectedSort,
//     bool? showAddForm,
//     bool? showVehicleDetails,
//     Vehicle? vehicleToEdit,
//     Vehicle? selectedVehicle,
//     bool clearVehicleToEdit = false,
//     bool clearSelectedVehicle = false,
//   }) {
//     return VehicleState(
//       vehicles: vehicles ?? this.vehicles,
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//       selectedStatus: selectedStatus ?? this.selectedStatus,
//       selectedSort: selectedSort ?? this.selectedSort,
//       showAddForm: showAddForm ?? this.showAddForm,
//       showVehicleDetails: showVehicleDetails ?? this.showVehicleDetails,
//       vehicleToEdit: clearVehicleToEdit
//           ? null
//           : (vehicleToEdit ?? this.vehicleToEdit),
//       selectedVehicle: clearSelectedVehicle
//           ? null
//           : (selectedVehicle ?? this.selectedVehicle),
//     );
//   }
// }

// vehicle_state.dart
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
