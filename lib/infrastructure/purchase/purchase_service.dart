import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/core/models/purchase.dart';


// ✅ Riverpod provider
final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  return PurchaseService(ref);
});



class PurchaseService {
  final Ref _ref;
  final Dio _dio = Dio();

  PurchaseService(this._ref);

  
        Future<List<Purchase>> getPurchases() async {
  try {
    final authState = _ref.read(authNotifierProvider);
    final token = authState.user?.accessToken;

    if (token == null) throw Exception("User not authenticated");

    final response = await _dio.get(
     'http://192.168.29.29:5000/api/purchases',
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode == 200) {
      print("🟢 FULL API RESPONSE: ${response.data}");
      
      final dataList = response.data['data'] as List;
      print("🟢 DATA LIST LENGTH: ${dataList.length}");
      
      if (dataList.isNotEmpty) {
        print("🟢 FIRST ITEM RAW: ${dataList[0]}");
      }
      
      // Try parsing each item individually to catch errors
      List<Purchase> purchases = [];
      for (int i = 0; i < dataList.length; i++) {
        try {
          print("🟡 PARSING ITEM $i: ${dataList[i]}");
          Purchase purchase = Purchase.fromJson(dataList[i]);
          purchases.add(purchase);
          print("✅ SUCCESSFULLY PARSED ITEM $i");
        } catch (e) {
          print("❌ ERROR PARSING ITEM $i: $e");
          print("❌ PROBLEMATIC DATA: ${dataList[i]}");
        }
      }
      
      print("🟢 TOTAL SUCCESSFULLY PARSED: ${purchases.length}");
      return purchases;
      
    } else {
      throw Exception("Failed to fetch purchases");
    }
  } catch (e) {
    print("❌ SERVICE ERROR: $e");
    throw Exception("Error fetching purchases: $e");
  }
}//new code temporary




  // ✅ Get single purchase by ID
  Future<Purchase> getPurchaseById(String id) async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final token = authState.user?.accessToken;

      if (token == null) throw Exception("User not authenticated");

      final response = await _dio.get(
        "http://192.168.29.29:5000/api/purchases/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        return Purchase.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch purchase $id");
      }
    } catch (e) {
      throw Exception("Error fetching purchase: $e");
    }
  }

  // ✅ Update purchase
  Future<Purchase> updatePurchase(String id, Map<String, dynamic> data) async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final token = authState.user?.accessToken;

      if (token == null) throw Exception("User not authenticated");

      final response = await _dio.put(
        "http://192.168.29.29:5000/api/purchases/$id",
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        return Purchase.fromJson(response.data);
      } else {
        throw Exception("Failed to update purchase");
      }
    } catch (e) {
      throw Exception("Error updating purchase: $e");
    }
  }

  // ✅ Delete purchase
  Future<void> deletePurchase(String id) async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final token = authState.user?.accessToken;

      if (token == null) throw Exception("User not authenticated");

      final response = await _dio.delete(
        "http://192.168.29.29:5000/api/purchases/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to delete purchase");
      }
    } catch (e) {
      throw Exception("Error deleting purchase: $e");
    }
  }
}
