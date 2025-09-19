// lib/application/financiers/financier_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/financier/financier_state.dart';
import 'package:my_new_project/core/models/financier.dart';
import 'package:my_new_project/infrastructure/financier/financier_repositary.dart';


final financierProvider = StateNotifierProvider<FinancierNotifier, FinancierState>((ref) {
  final repository = ref.watch(financierRepositoryProvider);
  return FinancierNotifier(repository);
});

class FinancierNotifier extends StateNotifier<FinancierState> {
  final FinancierRepository _repository;

  FinancierNotifier(this._repository) : super(FinancierState(financiers: [])) {
    loadFinanciers();
  }

  Future<void> loadFinanciers() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final financiers = await _repository.getFinanciers();
      state = state.copyWith(financiers: financiers, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addFinancier(Financier financier) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.addFinancier(financier);
      await loadFinanciers();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateFinancier(Financier financier) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.updateFinancier(financier);
      await loadFinanciers();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteFinancier(int id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.deleteFinancier(id);
      await loadFinanciers();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSelectedFinancier(Financier? financier) {
    state = state.copyWith(selectedFinancier: financier);
  }

  void clearSelectedFinancier() {
    state = state.copyWith(clearSelected: true);
  }
}
