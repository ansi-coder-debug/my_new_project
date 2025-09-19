// lib/application/financiers/financier_state.dart

import 'package:my_new_project/core/models/financier.dart';

class FinancierState {
  final List<Financier> financiers;
  final bool isLoading;
  final String? error;
  final Financier? selectedFinancier;

  FinancierState({
    required this.financiers,
    this.isLoading = false,
    this.error,
    this.selectedFinancier,
  });

  FinancierState copyWith({
    List<Financier>? financiers,
    bool? isLoading,
    String? error,
    Financier? selectedFinancier,
    bool clearSelected = false,
  }) {
    return FinancierState(
      financiers: financiers ?? this.financiers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedFinancier: clearSelected ? null : (selectedFinancier ?? this.selectedFinancier),
    );
  }
}
