import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/cashbook/cashbook_state.dart';

import 'package:my_new_project/core/models/cashbook.dart';
import 'package:my_new_project/infrastructure/cashbook/cashbook_repositary.dart';


final cashBookProvider = StateNotifierProvider<CashBookNotifier, CashBookState>((ref) {
  final repository = ref.watch(cashBookRepositoryProvider);
  return CashBookNotifier(repository);
});

class CashBookNotifier extends StateNotifier<CashBookState> {
  final CashBookRepository _repository;

  CashBookNotifier(this._repository) : super(CashBookState(entries: [])) {
    loadCashBookEntries();
  }

  Future<void> loadCashBookEntries() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final entries = await _repository.getAll();
      state = state.copyWith(entries: entries, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addEntry(CashBookEntry entry) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.create(entry);
      await loadCashBookEntries();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateEntry(CashBookEntry entry) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.update(entry);
      await loadCashBookEntries();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteEntry(String id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.delete(id);
      await loadCashBookEntries();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSelectedEntry(CashBookEntry? entry) {
    state = state.copyWith(selectedEntry: entry);
  }

  void clearSelectedEntry() {
    state = state.copyWith(clearSelected: true);
  }
}
