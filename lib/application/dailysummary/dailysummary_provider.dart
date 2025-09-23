import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_new_project/application/dailysummary/dailysummary_state.dart';

import 'package:my_new_project/core/models/dailysummary.dart';

import 'package:my_new_project/infrastructure/dailysummary/dailysummary_repositary.dart';

final dailySummaryProvider = StateNotifierProvider<DailySummaryNotifier, DailySummaryState>((ref) {
  final repository = ref.watch(dailySummaryRepositoryProvider);
  return DailySummaryNotifier(repository);
});

class DailySummaryNotifier extends StateNotifier<DailySummaryState> {
  final DailySummaryRepository _repository;

  DailySummaryNotifier(this._repository) : super(DailySummaryState(summaries: [])) {
    loadDailySummaries(); // auto-load on init
  }

  Future<void> loadDailySummaries({Map<String, dynamic>? filters}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final summaries = await _repository.getDailySummaries(filters: filters);
      state = state.copyWith(summaries: summaries, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSelectedDailySummary(DailySummary? summary) {
    state = state.copyWith(selectedSummary: summary);
  }

  void clearSelectedDailySummary() {
    state = state.copyWith(clearSelected: true);
  }
}
