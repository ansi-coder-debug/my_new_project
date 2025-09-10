import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/sales.dart';
import 'package:my_new_project/infrastructure/sale/sale_service.dart';

// ✅ Riverpod provider
final saleRepositoryProvider = Provider<SaleRepository>((ref) {
  final saleService = ref.watch(saleServiceProvider);
  return SaleRepository(saleService);
});

class SaleRepository {
  final SaleService _saleService;

  SaleRepository(this._saleService);

  // ✅ Get all sales
  Future<List<SaleInfo>> getSales() async {
    return await _saleService.getSales();
  }

  // ✅ Get sale by ID
  Future<SaleInfo> getSaleById(String id) async {
    return await _saleService.getSaleById(id);
  }

  // ✅ Create sale for vehicle
  Future<SaleInfo> createSale(String vehicleId, SaleInfo saleInfo) async {
    return await _saleService.createSale(vehicleId, saleInfo.toJson());
  }

  // ✅ Update sale
  Future<SaleInfo> updateSale(String id, Map<String, dynamic> data) async {
    return await _saleService.updateSale(id, data);
  }

  // ✅ Delete sale
  Future<void> deleteSale(String id) async {
    return await _saleService.deleteSale(id);
  }
}
