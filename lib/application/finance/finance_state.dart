import 'package:my_new_project/core/models/finance.dart';

class FinanceState {
  final List<Finance> finances;
  final bool isLoading;
  final String? error;
  final Finance? selectedFinance;

  FinanceState({
    required this.finances,
    this.isLoading = false,
    this.error,
    this.selectedFinance,
  });

  FinanceState copyWith({
    List<Finance>? finances,
    bool? isLoading,
    String? error,
    Finance? selectedFinance,
    bool clearSelected = false,
  }) {
    return FinanceState(
      finances: finances ?? this.finances,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedFinance: clearSelected ? null : (selectedFinance ?? this.selectedFinance),
    );
  }
}
