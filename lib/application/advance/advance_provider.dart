import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/advance.dart';
import 'package:my_new_project/application/advance/advance_state.dart';
import 'package:my_new_project/infrastructure/advance/advance_repositary.dart';


final advanceProvider = StateNotifierProvider<AdvanceNotifier, AdvanceState>((ref) {
  final repository = ref.watch(advanceRepositoryProvider);
  return AdvanceNotifier(repository);
});

class AdvanceNotifier extends StateNotifier<AdvanceState> {
  final AdvanceRepository _repository;

  AdvanceNotifier(this._repository) : super(AdvanceState(advances: [])) {
    loadAdvances();
  }

  Future<void> loadAdvances() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final advances = await _repository.getAdvances();
      state = state.copyWith(advances: advances, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addAdvance(Advance advance) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.addAdvance(advance);
      await loadAdvances();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateAdvance(Advance advance) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.updateAdvance(advance);
      await loadAdvances();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteAdvance(int id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.deleteAdvance(id);
      await loadAdvances();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSelectedAdvance(Advance? advance) {
    state = state.copyWith(selectedAdvance: advance);
  }

  void clearSelectedAdvance() {
    state = state.copyWith(clearSelected: true);
  }
}
