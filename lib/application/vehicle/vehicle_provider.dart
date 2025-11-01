import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/vehicle/vehicle_state.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/infrastructure/vehicle/vehicle_repositary.dart';

final vehicleProvider = StateNotifierProvider<VehicleNotifier, VehicleState>((
  ref,
) {
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
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<Vehicle> addVehicle(Vehicle vehicle) async {
    // ✅ Change return type to Vehicle
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

  Future<void> markVehicleAsSold(
    String vehicleId,
    Map<String, dynamic> saleData,
  ) async {
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

  Future<Vehicle> updateVehicle(Vehicle updated) async {
    // ✅ Change return type to Vehicle
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedVehicle = await _repo.updateVehicle(
        updated,
      ); // ✅ Use returned vehicle
      final updatedList = state.vehicles
          .map(
            (v) => v.id == updatedVehicle.id ? updatedVehicle : v,
          ) // ✅ Use returned vehicle
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
      final updatedList = state.vehicles.where((v) => v.id != id).toList();
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
    state = state.copyWith(showSaleForm: true, vehicleToSell: vehicle);
  }

  void hideSaleForm() {
    state = state.copyWith(showSaleForm: false, vehicleToSell: null);
  }

  void addPartnershipToVehicle(
    String vehicleId,
    Partnership newPartnership,
  ) async {
    final currentVehicles = state.vehicles;
    final index = currentVehicles.indexWhere((v) => v.id == vehicleId);
    if (index == -1) return;

    final vehicle = currentVehicles[index];

    final updatedVehicle = vehicle.copyWith(
      partnerships: [...(vehicle.partnerships ?? []), newPartnership],
    );

    final updatedList = [...currentVehicles];
    updatedList[index] = updatedVehicle;

    state = state.copyWith(vehicles: updatedList);
  }
}
