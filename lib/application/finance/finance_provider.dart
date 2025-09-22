import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/finance/finance_state.dart';
import 'package:my_new_project/core/models/finance.dart';
import 'package:my_new_project/infrastructure/finance/finance_repositary.dart';


final financeProvider = StateNotifierProvider<FinanceNotifier, FinanceState>((ref) {
  final repository = ref.watch(financeRepositoryProvider);
  return FinanceNotifier(repository);
});

class FinanceNotifier extends StateNotifier<FinanceState> {
  final FinanceRepository _repository;

  FinanceNotifier(this._repository) : super(FinanceState(finances: [])) {
    loadFinances();
  }

  Future<void> loadFinances() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final finances = await _repository.getAllFinances();
      state = state.copyWith(finances: finances, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addFinance(Finance finance) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.addFinance(finance);
      await loadFinances();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateFinance(Finance finance) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.updateFinance(finance);
      await loadFinances();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteFinance(String id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.deleteFinance(id);
      await loadFinances();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSelectedFinance(Finance? finance) {
    state = state.copyWith(selectedFinance: finance);
  }

  void clearSelectedFinance() {
    state = state.copyWith(clearSelected: true);
  }
}
