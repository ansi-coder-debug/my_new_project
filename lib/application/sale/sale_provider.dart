// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_new_project/application/sale/sale_state.dart';
// import 'package:my_new_project/core/models/sales.dart';

// import 'package:my_new_project/infrastructure/sale/sale_repository.dart';

// class SaleNotifier extends StateNotifier<SaleState> {
//   final SaleRepository _saleRepository;

//   SaleNotifier(this._saleRepository) : super(SaleState());

//   // ✅ Load all sales
//   Future<void> loadSales() async {
//     try {
//       state = state.copyWith(isLoading: true);
//       final sales = await _saleRepository.getSales();
//       state = state.copyWith(
//         sales: sales,
//         isLoading: false,
//         errorMessage: null,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         sales: [],
//         isLoading: false,
//         errorMessage: e.toString(),
//       );
//     }
//   }

//   // ✅ Create a new sale for a vehicle
//   Future<void> createSale(String vehicleId, SaleInfo saleInfo) async {
//     try {
//       final newSale = await _saleRepository.createSale(vehicleId, saleInfo);
//       state = state.copyWith(sales: [...state.sales, newSale]);
//     } catch (e) {
//       state = state.copyWith(errorMessage: e.toString());
//     }
//   }

//   // ✅ Update sale
//   Future<void> updateSale(String id, Map<String, dynamic> data) async {
//     try {
//       final updated = await _saleRepository.updateSale(id, data);
//       final updatedList = state.sales.map((s) {
//         return s.id == updated.id ? updated : s;
//       }).toList();
//       state = state.copyWith(sales: updatedList);
//     } catch (e) {
//       state = state.copyWith(errorMessage: e.toString());
//     }
//   }

//   // ✅ Delete sale
//   Future<void> deleteSale(String id) async {
//     try {
//       await _saleRepository.deleteSale(id);
//       final filtered = state.sales.where((s) => s.id != id).toList();
//       state = state.copyWith(sales: filtered);
//     } catch (e) {
//       state = state.copyWith(errorMessage: e.toString());
//     }
//   }
// }

// // ✅ Riverpod provider
// final saleProvider = StateNotifierProvider<SaleNotifier, SaleState>((ref) {
//   final repository = ref.watch(saleRepositoryProvider);
//   return SaleNotifier(repository);
// });
