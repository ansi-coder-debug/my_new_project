import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:my_new_project/application/auth/auth_notifier.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
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
        '$HbaseUrl/vehicles/paginated',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
          print('Raw response data: ${response.data}');
      
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
    print("Sending Payload: ${vehicle.toJson()}");

    print(
      '🔥 Partnership payload: ${json.encode(vehicle.partnerships!.map((p) => p.toJson()).toList())}',
    );

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
        MapEntry('purchase_name', vehicle.purchaseInfo.name ?? ''),
        MapEntry('purchase_phone', vehicle.purchaseInfo.phone ?? ''),
        MapEntry('purchase_address', vehicle.purchaseInfo.address ?? ''),
        MapEntry('purchase_date', vehicle.purchaseInfo.date.toIso8601String()),
        MapEntry(
          'purchase_price',
          vehicle.purchaseInfo.price.toString()
        ),
        MapEntry('purchase_mode_of_payment', vehicle.purchaseInfo.modeOfPayment ?? ''),
        MapEntry(
          'purchase_payment_status',
          vehicle.purchaseInfo.paymentStatus ?? 'pending',
        ),

        MapEntry(
          'is_partnership',
          (vehicle.partnerships?.isNotEmpty ?? false).toString(),
        ),
      ]);

      // Add images as files - use a different approach
      List<MultipartFile> imageFiles = await _getMultipartFiles(vehicle.photos);
      for (int i = 0; i < imageFiles.length; i++) {
        formData.files.add(MapEntry('photos', imageFiles[i]));
      }

     
      if (vehicle.partnerships != null && vehicle.partnerships!.isNotEmpty) {
        for (int i = 0; i < vehicle.partnerships!.length; i++) {
          final partner = vehicle.partnerships![i];

          // Safely extract partner ID and name
          final partnerId = partner.partner?.id ?? '0';
          final partnerName =
              partner.partnerName ?? partner.partner?.name ?? '';

          formData.fields.addAll([
            MapEntry('partnerships[$i][partner_id]', partnerId),
            MapEntry('partnerships[$i][partner_name]', partnerName),
            MapEntry(
              'partnerships[$i][contribution]',
              partner.contribution ?? '0',
            ),
            MapEntry(
              'partnerships[$i][mode_of_payment]',
              partner.paymentMode ?? 'cash',
            ),
            MapEntry(
              'partnerships[$i][contribution_payment_status]',
              partner.contributionStatus ?? 'pending',
            ),
            MapEntry(
              'partnerships[$i][profit_share]',
              partner.sharePercentage ?? '0',
            ),
            MapEntry(
              'partnerships[$i][profit_share_payment_status]',
              'pending',
            ),
          ]);

          if (vehicle.id.isNotEmpty) {
            formData.fields.add(
              MapEntry('partnerships[$i][vehicle_id]', vehicle.id),
            );
          }
        }
      }

      // ✅ ADD DEBUG LOGGING HERE
      print('🔍 All FormData fields being sent:');
      for (var field in formData.fields) {
        if (field.key == 'partnerships_info') {
          print('   ${field.key}: ${field.value}'); // This will show the JSON
        } else {
          print('   ${field.key}: ${field.value}');
        }
      }
      print('🔍 Number of files: ${formData.files.length}');

      print('🔍 Sending FormData with ${vehicle.photos.length} images');

      final response = await _dio.post(
        '$HbaseUrl/vehicles/detailed',
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
    print("Sending Payload: ${vehicle.toJson()}");

    print(
      '🔥 Partnership payload: ${json.encode(vehicle.partnerships!.map((p) => p.toJson()).toList())}',
    );

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
        MapEntry('purchase_name', vehicle.purchaseInfo.name ?? ''),
        MapEntry('purchase_phone', vehicle.purchaseInfo.phone ?? ''),
        MapEntry('purchase_address', vehicle.purchaseInfo.address ?? ''),
        MapEntry('purchase_date', vehicle.purchaseInfo.date.toIso8601String()),
        MapEntry(
          'purchase_price',
          vehicle.purchaseInfo.price.toString()
        ),
        MapEntry('purchase_mode_of_payment', vehicle.purchaseInfo.modeOfPayment ?? ''),
        MapEntry(
          'purchase_payment_status',
          vehicle.purchaseInfo.paymentStatus ?? 'pending',
        ),
        MapEntry(
          'is_partnership',
          // vehicle.partnerships != null ? 'true' : 'false',
          (vehicle.partnerships?.isNotEmpty ?? false).toString(),
        ),
      ]);

     
      if (vehicle.partnerships != null && vehicle.partnerships!.isNotEmpty) {
        for (int i = 0; i < vehicle.partnerships!.length; i++) {
          final partner = vehicle.partnerships![i];

          // Safely extract partner ID and name
          final partnerId = partner.partner?.id ?? '0';
          final partnerName =
              partner.partnerName ?? partner.partner?.name ?? '';

          formData.fields.addAll([
            MapEntry('partnerships[$i][partner_id]', partnerId),
            MapEntry('partnerships[$i][partner_name]', partnerName),
            MapEntry(
              'partnerships[$i][contribution]',
              partner.contribution ?? '0',
            ),
            MapEntry(
              'partnerships[$i][mode_of_payment]',
              partner.paymentMode ?? 'cash',
            ),
            MapEntry(
              'partnerships[$i][contribution_payment_status]',
              partner.contributionStatus ?? 'pending',
            ),
            MapEntry(
              'partnerships[$i][profit_share]',
              partner.sharePercentage ?? '0',
            ),
            MapEntry(
              'partnerships[$i][profit_share_payment_status]',
              'pending',
            ),
          ]);

          if (vehicle.id.isNotEmpty) {
            formData.fields.add(
              MapEntry('partnerships[$i][vehicle_id]', vehicle.id),
            );
          }
        }
      }

      // Add images as files - use a different approach
      List<MultipartFile> imageFiles = await _getMultipartFiles(vehicle.photos);
      for (int i = 0; i < imageFiles.length; i++) {
        formData.files.add(MapEntry('photos', imageFiles[i]));
      }

      // ✅ ADD DEBUG LOGGING HERE
      print('🔍 All FormData fields being sent:');
      for (var field in formData.fields) {
        if (field.key == 'partnerships_info') {
          print('   ${field.key}: ${field.value}'); // This will show the JSON
        } else {
          print('   ${field.key}: ${field.value}');
        }
      }
      print('🔍 Number of files: ${formData.files.length}');

      print('🔍 Sending FormData update with ${vehicle.photos.length} images');

      final response = await _dio.put(
        '$HbaseUrl/vehicles/detailed/${vehicle.id}',
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




Future<void> markVehicleAsSold(String vehicleId, Map<String, dynamic> saleData) async {
  try {
    final authState = _ref.read(authNotifierProvider);
    final token = authState.user?.accessToken;

    if (token == null) throw Exception('User not authenticated');
    if (vehicleId.isEmpty) throw Exception('Vehicle ID is required');

    final url = '$HbaseUrl/vehicles/detailed/$vehicleId';

    final response = await _dio.put(
      url,
      data: saleData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark vehicle as sold');
    }

    print('✅ Vehicle marked as sold successfully: ${response.data}');
  } on DioException catch (e) {
    print('❌ Failed to mark vehicle as sold: ${e.message}');
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
        '$HbaseUrl/vehicles/$id',
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
    await _dio.patch('/vehicles/$vehicleId/status', data: {"status": status});
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
