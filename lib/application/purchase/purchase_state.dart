import 'package:my_new_project/core/models/purchase.dart';

class PurchaseState {
  final bool isLoading;
  final List<Purchase> purchases;
  final String? errorMessage;

  PurchaseState({
    this.isLoading = false,
    this.purchases = const [],
    this.errorMessage,
  });

  PurchaseState copyWith({
    bool? isLoading,
    List<Purchase>? purchases,
    String? errorMessage,
  }) {
    return PurchaseState(
      isLoading: isLoading ?? this.isLoading,
      purchases: purchases ?? this.purchases,
      errorMessage: errorMessage,
    );
  }
}
