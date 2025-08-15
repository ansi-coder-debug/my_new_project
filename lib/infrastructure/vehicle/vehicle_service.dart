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
      final authState = _ref.read(authNotifierProvider);
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

        return vehiclesList.map((json) => Vehicle.fromJson(json)).toList();
      }
      throw Exception('Failed to load vehicles: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  //ADD VEHICLE CONECCTING TO BACKEND
  Future<void> addVehicle(Vehicle vehicle) async {
    // add function coming soon to backend
    try {
      final authState = _ref.read(authNotifierProvider);
      final token = authState.user?.accessToken;

      if (token == null) throw Exception('User not authenticated');

      // ✅ Add here
    print('Request Data: ${vehicle.toJson()}'); // Log full request

   final response = await _dio.post(
        'http://192.168.29.29:5000/api/vehicles',
        data: vehicle.toJson(), // Make sure this matches your backend format
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('🔍 Backend response: ${response.data}');
       print('🔍 Response status: ${response.statusCode}');
      
      // Check for successful creation (201 status code)
   
if (response.statusCode != 201 && response.statusCode != 200) {
  throw Exception('Failed to add vehicle: ${response.data}');
}
     print('✅ Successfully added vehicle: ${response.data}');

      
    } on DioException catch (e) {
       //Add here inside DioException block
    if (e.response != null) {
      print('Backend error: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
    }
      throw Exception('Failed to add vehicle:${e.response?.data ?? e.message}');
    }
  }















  //  UPDATE VEHICLE CONECCTING TO BACKEND
  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      final authstate = _ref.read(authNotifierProvider);
      final token = authstate.user?.accessToken;

      if (token == null) throw Exception('User not authenticated');
      if (vehicle.id.isEmpty)
        throw Exception('Vehicle ID is required for update');

       // ✅ Add here
    print('Request Data: ${vehicle.toJson()}'); // Log full request

    final response =   await _dio.put(
        'http://192.168.29.29:5000/api/vehicles/${vehicle.id}',
        data: vehicle.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('🔍 Response status: ${response.statusCode}');
      // Check for successful update (200 status code)
        
if (response.statusCode != 201 && response.statusCode != 200) {
  throw Exception('Failed to update vehicle: ${response.data}');
}
      print('✅ Successfully updated vehicle: ${response.data}');


    } on DioException catch (e) {
      // ✅ Add here inside DioException block
    if (e.response != null) {
      print('Backend error: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
    }
      throw Exception(
        'Failed to update vehicle: ${e.response?.data ?? e.message}',
      );
    }
    
  }










  //DELETE VEHICLE CONECCTING TO BACKEND
  Future<void> deleteVehicle(String id) async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final token = authState.user?.accessToken;

      if (token == null) throw Exception('User not authenticated');

      await _dio.delete(
        'http://192.168.29.29:5000/api/vehicles/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(
        'Failed to delete vehicle: ${e.response?.data ?? e.message}',
      );
    }
  }
}
// POST → Add new vehicle

// PUT/PATCH → Edit vehicle

// DELETE → Remove vehicle
