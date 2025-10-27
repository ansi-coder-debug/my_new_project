// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_new_project/application/vehicle/vehicle_state.dart';
// import 'package:my_new_project/core/models/partnership.dart';
// import 'package:my_new_project/core/models/vehicle.dart';
// import 'package:my_new_project/infrastructure/vehicle/vehicle_repositary.dart';
// // import 'package:my_new_project/infrastructure/vehicle/vehicle_repository.dart'; // Fixed import name

// final vehicleProvider = StateNotifierProvider<VehicleNotifier, VehicleState>((
//   ref,
// ) {
//   final repository = ref.watch(
//     vehicleRepositoryProvider,
//   ); // Fixed provider name
//   return VehicleNotifier(repository);
// });

// class VehicleNotifier extends StateNotifier<VehicleState> {
//   final VehicleRepository _vehicleRepositary; // Fixed type name

//   VehicleNotifier(this._vehicleRepositary) : super(VehicleState(vehicles: [])) {
//     loadVehicles(); // Fetch from backend immediately
//   }

//   Future<void> loadVehicles() async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//       final vehicles = await _vehicleRepositary.getVehicles();
//       state = state.copyWith(vehicles: vehicles, isLoading: false, error: null);
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: 'Failed to load vehicles: ${e.toString()}',
//       );
//       rethrow;
//     }
//   }

//   Future<void> addVehicle(Vehicle vehicle) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//       await _vehicleRepositary.addVehicle(vehicle);

//       // Refresh the list and reset form state
//       await loadVehicles();

//       state = state.copyWith(
//         isLoading: false,
//         showAddForm: false,
//         vehicleToEdit: null,
//         error: null,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: 'Failed to add vehicle: ${e.toString()}',
//       );
//       rethrow;
//     }
//   }

//   Future<void> updateVehicle(Vehicle vehicle) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//       await _vehicleRepositary.updateVehicle(vehicle);

//       // Refresh the list and reset form state
//       await loadVehicles();

//       state = state.copyWith(
//         isLoading: false,
//         showAddForm: false,
//         vehicleToEdit: null,
//         error: null,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: 'Failed to update vehicle: ${e.toString()}',
//       );
//       rethrow;
//     }
//   }

//   Future<void> markVehicleAsSold({
//     required String vehicleId,
//     required Map<String, dynamic> saleData,
//   }) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);

//       // Call the repository method to mark as sold with saleData
//       await _vehicleRepositary.markVehicleAsSold(vehicleId, saleData);

//       // Reload vehicles list to reflect changes
//       await loadVehicles();

//       state = state.copyWith(isLoading: false);
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: 'Failed to mark vehicle as sold: $e',
//       );
//       rethrow;
//     }
//   }

//   Future<void> deleteVehicle(String id) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);
//       await _vehicleRepositary.deleteVehicle(id);

//       // Refresh the list
//       await loadVehicles();
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: 'Failed to delete vehicle: ${e.toString()}',
//       );
//       rethrow;
//     }
//   }

//   // Show/hide add vehicle form
//   void setShowAddForm(bool value) {
//     state = state.copyWith(showAddForm: value);
//   }

//   // Show/hide the Vehicle Details screen
//   void setShowVehicleDetails(bool value) {
//     state = state.copyWith(showVehicleDetails: value);
//   }

//   // Set which vehicle is selected to view details
//   void setSelectedVehicle(Vehicle? vehicle) {
//     state = state.copyWith(selectedVehicle: vehicle);
//   }

//   // Set which vehicle is being edited
//   void setVehicleToEdit(Vehicle? vehicle) {
//     state = state.copyWith(vehicleToEdit: vehicle);
//   }

//   // Update selected status filter (e.g., Sold, Available)
//   void setSelectedStatus(String status) {
//     state = state.copyWith(selectedStatus: status);
//   }

//   // Update selected sorting option
//   void setSelectedSort(String sort) {
//     state = state.copyWith(selectedSort: sort);
//   }

//   // state = state.copyWith(vehicleToEdit: null);

//   void clearVehicleToEdit() {
//     state = state.copyWith(
//       vehicleToEdit: null,
//       clearVehicleToEdit: true,
//       showAddForm: false,
//       selectedVehicle: null,
//       // Add flags to ensure clearing
//       clearSelectedVehicle: true,
//     );
//   }

//   //partnership
//   Future<void> addPartnership(String vehicleId, Partnership partnership) async {
//     try {
//       // Find the target vehicle
//       final vehicle = state.vehicles.firstWhere((v) => v.id == vehicleId);

//       // Create an updated vehicle with the new partnership
//       final updatedVehicle = vehicle.copyWith(
//         partnerships: [...(vehicle.partnerships ?? []), partnership],
//       );

//       // Update in backend
//       await _vehicleRepositary.updateVehicle(updatedVehicle);

//       // Refresh local state
//       await loadVehicles();
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: 'Failed to add partnership: ${e.toString()}',
//       );
//       rethrow;
//     }
//   }
// }




















// vehicle_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/vehicle/vehicle_state.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/infrastructure/vehicle/vehicle_repositary.dart';

final vehicleProvider =
    StateNotifierProvider<VehicleNotifier, VehicleState>((ref) {
  final repo = ref.watch(vehicleRepositoryProvider);
  return VehicleNotifier(repo);
});

class VehicleNotifier extends StateNotifier<VehicleState> {
  final VehicleRepository _repo;

  VehicleNotifier(this._repo) : super(const VehicleState()) {
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final vehicles = await _repo.getVehicles();
      state = state.copyWith(vehicles: vehicles, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Vehicle> addVehicle(Vehicle vehicle) async {  // ✅ Change return type to Vehicle
  state = state.copyWith(isLoading: true, error: null);
  try {
    final newVehicle = await _repo.addVehicle(vehicle);
    // Add immediately for instant UI update
    final updatedList = [...state.vehicles, newVehicle];
    state = state.copyWith(vehicles: updatedList, isLoading: false);
    return newVehicle; // ✅ Return the created vehicle
  } catch (e) {
    state = state.copyWith(isLoading: false, error: e.toString());
    rethrow;
  }
}



  Future<void> markVehicleAsSold(String vehicleId, Map<String, dynamic> saleData) async {
  state = state.copyWith(isLoading: true, error: null);
  try {
    final updatedVehicle = await _repo.markVehicleAsSold(vehicleId, saleData);
    final updatedList = state.vehicles.map((v) {
      return v.id == updatedVehicle.id ? updatedVehicle : v;
    }).toList();
    state = state.copyWith(vehicles: updatedList, isLoading: false);
  } catch (e) {
    state = state.copyWith(isLoading: false, error: e.toString());
  }
}

  Future<Vehicle> updateVehicle(Vehicle updated) async {  // ✅ Change return type to Vehicle
  state = state.copyWith(isLoading: true, error: null);
  try {
    final updatedVehicle = await _repo.updateVehicle(updated);  // ✅ Use returned vehicle
    final updatedList = state.vehicles
        .map((v) => v.id == updatedVehicle.id ? updatedVehicle : v)  // ✅ Use returned vehicle
        .toList();
    state = state.copyWith(vehicles: updatedList, isLoading: false);
    return updatedVehicle; // ✅ Return the updated vehicle
  } catch (e) {
    state = state.copyWith(isLoading: false, error: e.toString());
    rethrow;
  }
}

  Future<void> deleteVehicle(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.deleteVehicle(id);
      final updatedList =
          state.vehicles.where((v) => v.id != id).toList();
      state = state.copyWith(vehicles: updatedList, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // --- UI helpers ---
  void setVehicleToEdit(Vehicle? vehicle) {
    state = state.copyWith(vehicleToEdit: vehicle);
  }

  void toggleAddForm(bool show) {
    state = state.copyWith(showAddForm: show);
  }

  void toggleVehicleDetails(bool show) {
    state = state.copyWith(showVehicleDetails: show);
  }


  // sale form 
  void showSaleForm(Vehicle vehicle) {
  state = state.copyWith(
    showSaleForm: true,
    vehicleToSell: vehicle,
  );
}

void hideSaleForm() {
  state = state.copyWith(
    showSaleForm: false,
    vehicleToSell: null,
  );
}

}
