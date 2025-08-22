import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/purchase/purchase_state.dart';
import 'package:my_new_project/core/models/purchase.dart';
import 'package:my_new_project/infrastructure/purchase/purchase_repositary';


class PurchaseNotifier extends StateNotifier<PurchaseState> {
  final PurchaseRepository _purchaseRepository;

  PurchaseNotifier(this._purchaseRepository) : super(PurchaseState());

  // // ✅ Load all purchases
  // Future<void> loadPurchases() async {
  //   state = state.copyWith(isLoading: true, errorMessage: null);
  //   try {
  //     final purchases = await _purchaseRepository.getPurchases();
  //     state = state.copyWith(isLoading: false, purchases: purchases);
  //   } catch (e) {
  //     state = state.copyWith(isLoading: false, errorMessage: e.toString());
  //   }
  // }


    // In your purchase_provider.dart loadPurchases method
Future<void> loadPurchases() async {
  try {
    state = state.copyWith(isLoading: true);
    final purchases = await _purchaseRepository.getPurchases();
    print("🟢 PROVIDER: Loaded ${purchases.length} purchases");
    state = state.copyWith(
      purchases: purchases,
      isLoading: false,
      errorMessage: null,
    );
  } catch (e) {
    print("❌ PROVIDER ERROR: $e");
    state = state.copyWith(
      purchases: [],
      isLoading: false,
      errorMessage: e.toString(),
    );
  }
}//temporary code 




  // ✅ Update purchase
  Future<void> updatePurchase(String id, Map<String, dynamic> data) async {
    try {
      final updated = await _purchaseRepository.updatePurchase(id, data);
      final updatedList = state.purchases.map((p) {
        return p.id == updated.id ? updated : p;
      }).toList();
      state = state.copyWith(purchases: updatedList);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  // ✅ Delete purchase
  Future<void> deletePurchase(String id) async {
    try {
      await _purchaseRepository.deletePurchase(id);
      final filtered = state.purchases.where((p) => p.id != id).toList();
      state = state.copyWith(purchases: filtered);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

// ✅ Riverpod provider
final purchaseProvider =
    StateNotifierProvider<PurchaseNotifier, PurchaseState>((ref) {
  final repository = ref.watch(purchaseRepositoryProvider);
  return PurchaseNotifier(repository);
});
