
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
    bool clearVehicleToEdit = false,
    bool clearSelectedVehicle = false
  }) {
    return VehicleState(
      vehicles: vehicles ?? this.vehicles,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedSort: selectedSort ?? this.selectedSort,
      showAddForm: showAddForm ?? this.showAddForm,
      showVehicleDetails: showVehicleDetails ??
       this.showVehicleDetails,


      vehicleToEdit:clearVehicleToEdit ? null :
      (vehicleToEdit ?? this.vehicleToEdit),
      //  vehicleToEdit ?? this.vehicleToEdit,



      selectedVehicle: clearSelectedVehicle ? null :
      (selectedVehicle ?? this.selectedVehicle)
      // selectedVehicle ?? this.selectedVehicle,
    );
  }
}