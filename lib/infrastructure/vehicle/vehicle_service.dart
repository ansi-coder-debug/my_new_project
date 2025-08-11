import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_new_project/application/auth/auth_notifier.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/core/models/vehicle.dart';

final vehicleServiceProvider = Provider<VehicleService>((ref) {
  final dio = Dio();
  return VehicleService(dio, ref);
});

class VehicleService {
  final Dio _dio;
  final Ref _ref;

  VehicleService(this._dio, this._ref);

  Future<List<Vehicle>> getVehicles() async {
    try {
      final authState = _ref.read(authNotifierProvider.notifier).state;
      final token = authState.user?.accessToken;

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.get(
        'http://192.168.29.29:5000/api/vehicles',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        // ✅ Extract the "data" array from the response
        final responseData = response.data as Map<String, dynamic>;
        final vehiclesList = responseData['data'] as List; // key is 'data'

        return vehiclesList
        .map((json) => Vehicle.fromJson(json))
        .toList();

        // return (response.data as List)
        //     .map((json) => Vehicle.fromJson(json))
        //     .toList();
      }
      throw Exception('Failed to load vehicles: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> addVehicle(Vehicle vehicle) async {}

  Future<void> updateVehicle(Vehicle vehicle) async {}

  Future<void> deleteVehicle(String id) async {}
}
