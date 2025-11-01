import 'package:flutter_riverpod/flutter_riverpod.dart';

final partnershipFormProvider =
    StateNotifierProvider<PartnershipFormNotifier, PartnershipFormState>(
  (ref) => PartnershipFormNotifier(),
);

class PartnershipFormNotifier extends StateNotifier<PartnershipFormState> {
  PartnershipFormNotifier() : super(const PartnershipFormState());

  void updatePartnerId(String? id) {
    state = state.copyWith(partnerId: id);
  }

  void updatePurchasePrice(double? value) {
    state = state.copyWith(purchasePrice: value);
     _validateLogic();

  }

  void updateContributionAmount(double? value) {
    state = state.copyWith(contributionAmount: value);
     _validateLogic();
  }

  void updateContributionPaid(double? value) {
    state = state.copyWith(contributionPaid: value);
     _validateLogic();
  }

  void updateProfitShare(String? value) {
    state = state.copyWith(profitShare: value);
  }

  void resetForm() {
    state = const PartnershipFormState();
  }

  void updateFromAccountName(String? name) {
  state = state.copyWith(fromAccountName: name);
}


 void _validateLogic() {
  final price = state.purchasePrice;
  final c = state.contributionAmount;
  final p = state.contributionPaid;

  String? error;

  if (p != null && (c == null || c == 0)) {
    error = 'Enter contribution before paid amount.';
  } else if (c != null && price != null && c > price) {
    error = 'Contribution cannot exceed vehicle purchase price.';
  } else if (p != null && c != null && p > c) {
    error = 'Paid amount cannot exceed contribution.';
  }

  // 👇 Add simple validation flags
  final priceValid = price != null && price > 0;
  final amountValid = priceValid && c != null && c > 0 && (price == null || c <= price);
  final paidValid = amountValid && p != null && p > 0 && (c == null || p <= c);

  state = state.copyWith(
    errorMessage: error,
    isPurchasePriceValid: priceValid,
    isContributionAmountValid: amountValid,
    isContributionPaidValid: paidValid,
  );
}


}

class PartnershipFormState {
  final String? partnerId;
  final double? purchasePrice;
  final double? contributionAmount;
  final double? contributionPaid;
  final String? profitShare;
    final String? errorMessage;
    final String? fromAccountName;

    // 👇 Add these for field enabling 
  final bool isPurchasePriceValid;
  final bool isContributionAmountValid;
  final bool isContributionPaidValid;



  const PartnershipFormState({
    this.partnerId,
    this.purchasePrice,
    this.contributionAmount,
    this.contributionPaid,
    this.profitShare,
    this.errorMessage,
    this.fromAccountName,
    this.isPurchasePriceValid = false,
    this.isContributionAmountValid = false,
    this.isContributionPaidValid = false,
  });

  PartnershipFormState copyWith({
    String? partnerId,
    double? purchasePrice,
    double? contributionAmount,
    double? contributionPaid,
    String? profitShare,
  String? errorMessage,
  bool clearError=false,
   final String? fromAccountName,

     bool? isPurchasePriceValid,
    bool? isContributionAmountValid,
    bool? isContributionPaidValid,
  }) {
    return PartnershipFormState(
      partnerId: partnerId ?? this.partnerId,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      contributionAmount: contributionAmount ?? this.contributionAmount,
      contributionPaid: contributionPaid ?? this.contributionPaid,
      profitShare: profitShare ?? this.profitShare,
       
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      fromAccountName: fromAccountName??this.fromAccountName,
       isPurchasePriceValid:
          isPurchasePriceValid ?? this.isPurchasePriceValid,
      isContributionAmountValid:
          isContributionAmountValid ?? this.isContributionAmountValid,
      isContributionPaidValid:
          isContributionPaidValid ?? this.isContributionPaidValid,
    );
  }

  
}
