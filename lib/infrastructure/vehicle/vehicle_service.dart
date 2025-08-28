import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:my_new_project/application/auth/auth_notifier.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:http_parser/http_parser.dart';

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
        'http://192.168.29.29:5000/api/vehicles/paginated',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // if (response.statusCode == 200) {
      //   // ✅ Extract the "data" array from the response
      //   final responseData = response.data as Map<String, dynamic>;
      //   final vehiclesList = responseData['data'] as List; // key is 'data'

      //   return vehiclesList.map((json) => Vehicle.fromJson(json)).toList();
      // }
      if (response.statusCode == 200) {
      final data = response.data;

      if (data is List) {
        // ✅ Backend returned a raw list
        return data.map((json) => Vehicle.fromJson(json)).toList();
      } else if (data is Map<String, dynamic> && data.containsKey('data')) {
        // ✅ Backend returned { "data": [...] }
        final vehiclesList = data['data'] as List;
        return vehiclesList.map((json) => Vehicle.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected response format: $data');
      }
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
    try {
      final authState = _ref.read(authNotifierProvider);
      final token = authState.user?.accessToken;

      if (token == null) throw Exception('User not authenticated');

      // Create FormData
      FormData formData = FormData();

      // Add all regular fields
      formData.fields.addAll([
        MapEntry('make', vehicle.make),
        MapEntry('model', vehicle.model),
        MapEntry('year', vehicle.year),
        MapEntry('reg_no', vehicle.registrationId),
        MapEntry('color', vehicle.color),
        MapEntry('mileage', vehicle.mileage.toString()),
        MapEntry('expected_price', vehicle.price.replaceAll(',', '')),
        MapEntry('status', vehicle.status),
        MapEntry('notes', vehicle.description ?? ''),
        MapEntry('fuel_type', vehicle.fuelType.toLowerCase()),
        MapEntry('purchase_name', vehicle.purchaseName ?? ''),
        MapEntry('purchase_phone', vehicle.purchasePhone ?? ''),
        MapEntry('purchase_address', vehicle.purchaseAddress ?? ''),
        MapEntry('purchase_date', vehicle.purchaseDate ?? ''),
        MapEntry(
          'purchase_price',
          vehicle.purchasePrice?.replaceAll(',', '') ?? '0',
        ),
        MapEntry('purchase_mode_of_payment', vehicle.purchaseMode ?? ''),
        MapEntry(
          'purchase_payment_status',
          vehicle.purchasePaymentStatus ?? 'pending',
        ),
        MapEntry(
          'is_partnership',
          vehicle.partnership != null ? 'true' : 'false',
        ),
      ]);

      // Add images as files - use a different approach
      List<MultipartFile> imageFiles = await _getMultipartFiles(vehicle.photos);
      for (int i = 0; i < imageFiles.length; i++) {
        formData.files.add(MapEntry('photos', imageFiles[i]));
      }

      // Add partnership data if it exists
      if (vehicle.partnership != null) {
        formData.fields.add(
          MapEntry(
            'partnerships',
            json.encode([vehicle.partnership!.toJson()]),
          ),
        );
      }

      print('🔍 Sending FormData with ${vehicle.photos.length} images');

      final response = await _dio.post(
        'http://192.168.29.29:5000/api/vehicles/detailed',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('✅ Vehicle created successfully: ${response.statusCode}');
      print('Response: ${response.data}');
    } on DioException catch (e) {
      print('❌ Failed to add vehicle: ${e.message}');
      if (e.response != null) {
        print('Backend error: ${e.response?.data}');
      }
      rethrow;
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

      // Create FormData
      FormData formData = FormData();

      // Add all regular fields
      formData.fields.addAll([
        MapEntry('make', vehicle.make),
        MapEntry('model', vehicle.model),
        MapEntry('year', vehicle.year),
        MapEntry('reg_no', vehicle.registrationId),
        MapEntry('color', vehicle.color),
        MapEntry('mileage', vehicle.mileage.toString()),
        MapEntry('expected_price', vehicle.price.replaceAll(',', '')),
        MapEntry('status', vehicle.status),
        MapEntry('notes', vehicle.description ?? ''),
        MapEntry('fuel_type', vehicle.fuelType),
        MapEntry('purchase_name', vehicle.purchaseName ?? ''),
        MapEntry('purchase_phone', vehicle.purchasePhone ?? ''),
        MapEntry('purchase_address', vehicle.purchaseAddress ?? ''),
        MapEntry('purchase_date', vehicle.purchaseDate ?? ''),
        MapEntry(
          'purchase_price',
          vehicle.purchasePrice?.replaceAll(',', '') ?? '0',
        ),
        MapEntry('purchase_mode_of_payment', vehicle.purchaseMode ?? ''),
        MapEntry(
          'purchase_payment_status',
          vehicle.purchasePaymentStatus ?? 'pending',
        ),
        MapEntry(
          'is_partnership',
          vehicle.partnership != null ? 'true' : 'false',
        ),
      ]);

      // Add images as files - use a different approach
      List<MultipartFile> imageFiles = await _getMultipartFiles(vehicle.photos);
      for (int i = 0; i < imageFiles.length; i++) {
        formData.files.add(MapEntry('photos', imageFiles[i]));
      }

      // 3. Add partnership data if exists
      if (vehicle.partnership != null) {
        formData.fields.add(
          MapEntry(
            'partnerships',
            json.encode([vehicle.partnership!.toJson()]),
          ),
        );
      }

      print('🔍 Sending FormData update with ${vehicle.photos.length} images');

      final response = await _dio.put(
      'http://192.168.29.29:5000/api/vehicles/detailed/${vehicle.id}',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('✅ Vehicle updated successfully: ${response.statusCode}');
      print('Response: ${response.data}');
    } on DioException catch (e) {
      print('❌ Failed to update  vehicle: ${e.message}');
      if (e.response != null) {
        print('Backend error: ${e.response?.data}');
      }
      rethrow;
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
 
 //updating status like sold maintance available 
  Future<void> updateVehicleStatus(String vehicleId, String status) async {
    await _dio.patch(
      '/vehicles/$vehicleId/status',
      data: {"status": status},
    );
  }




  // HELPER FUNCTION: Convert image paths to MultipartFile objects
  Future<List<MultipartFile>> _getMultipartFiles(
    List<String> photoPaths,
  ) async {
    List<MultipartFile> files = [];

    for (String path in photoPaths) {
      // Skip URLs (they're already uploaded images from server)
      if (path.startsWith('http')) {
        continue;
      }

      try {
        if (kIsWeb) {
          // For web: use XFile
          final file = XFile(path);
          final bytes = await file.readAsBytes();
          files.add(
            MultipartFile.fromBytes(
              bytes,
              filename: 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        } else {
          // For mobile: use File
          final file = File(path);
          if (await file.exists()) {
            files.add(
              await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
                contentType: MediaType('image', 'jpeg'),
              ),
            );
          }
        }
      } catch (e) {
        print('❌ Failed to process image $path: $e');
      }
    }
    // ✅ Add debug prints here
    print('🔍 Number of image files: ${files.length}');
    for (var file in files) {
      // MultipartFile.length is async, so we need to await
      int size = await file.length;
      print('🔍 File: ${file.filename}, size: $size bytes');
    }

    return files;
  }
}
