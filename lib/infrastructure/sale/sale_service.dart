import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/core/models/sales.dart';

// ✅ Riverpod provider
final saleServiceProvider = Provider<SaleService>((ref) {
  return SaleService(ref);
});

class SaleService {
  final Ref _ref;
  final Dio _dio = Dio();

  SaleService(this._ref);

  // ✅ Get all sales
  Future<List<SaleInfo>> getSales() async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final token = authState.user?.accessToken;
      if (token == null) throw Exception("User not authenticated");

      final response = await _dio.get(
        "http://192.168.29.29:5000/api/sales",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final dataList = response.data['data'] as List;
        return dataList.map((e) => SaleInfo.fromJson(e)).toList();
      } else {
        throw Exception("Failed to fetch sales");
      }
    } catch (e) {
      throw Exception("Error fetching sales: $e");
    }
  }

  // ✅ Get single sale by ID
  Future<SaleInfo> getSaleById(String id) async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final token = authState.user?.accessToken;
      if (token == null) throw Exception("User not authenticated");

      final response = await _dio.get(
        "http://192.168.29.29:5000/api/sales/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        return SaleInfo.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch sale $id");
      }
    } catch (e) {
      throw Exception("Error fetching sale: $e");
    }
  }

  // ✅ Create sale for a vehicle
  Future<SaleInfo> createSale(String vehicleId, Map<String, dynamic> data) async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final token = authState.user?.accessToken;
      if (token == null) throw Exception("User not authenticated");

      final response = await _dio.post(
        "http://192.168.29.29:5000/api/vehicles/$vehicleId/sale",
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return SaleInfo.fromJson(response.data);
      } else {
        throw Exception("Failed to create sale");
      }
    } catch (e) {
      throw Exception("Error creating sale: $e");
    }
  }

  // ✅ Update sale
  Future<SaleInfo> updateSale(String id, Map<String, dynamic> data) async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final token = authState.user?.accessToken;
      if (token == null) throw Exception("User not authenticated");

      final response = await _dio.put(
        "http://192.168.29.29:5000/api/sales/$id",
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        return SaleInfo.fromJson(response.data);
      } else {
        throw Exception("Failed to update sale");
      }
    } catch (e) {
      throw Exception("Error updating sale: $e");
    }
  }

  // ✅ Delete sale
  Future<void> deleteSale(String id) async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final token = authState.user?.accessToken;
      if (token == null) throw Exception("User not authenticated");

      final response = await _dio.delete(
        "http://192.168.29.29:5000/api/sales/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to delete sale");
      }
    } catch (e) {
      throw Exception("Error deleting sale: $e");
    }
  }
}
