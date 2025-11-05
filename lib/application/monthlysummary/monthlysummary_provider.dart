import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/monthlysummary/monthlysummary_state.dart';

import 'package:my_new_project/core/models/monthlysummary.dart';

import 'package:my_new_project/infrastructure/monthlysummary/monthlysummary_repositary.dart';

final monthlySummaryProvider = StateNotifierProvider<MonthlySummaryNotifier, MonthlySummaryState>((ref) {
  final repository = ref.watch(monthlySummaryRepositoryProvider);
  return MonthlySummaryNotifier(repository);
});

class MonthlySummaryNotifier extends StateNotifier<MonthlySummaryState> {
  final MonthlySummaryRepository _repository;

  MonthlySummaryNotifier(this._repository) : super(MonthlySummaryState(summaries: [])) {
    // loadMonthlySummaries();
  }

  Future<void> loadMonthlySummaries() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final summaries = await _repository.getMonthlySummaries();

      state = state.copyWith(summaries: summaries, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

 

  void setSelectedMonthlySummary(MonthlySummary? summary) {
    state = state.copyWith(selectedSummary: summary);
  }

  void clearSelectedMonthlySummary() {
    state = state.copyWith(clearSelected: true);
  }
}
