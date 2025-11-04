import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/summary.dart';
import 'package:my_new_project/infrastructure/summary/summary_service.dart';

// ✅ STATE CLASS
class SummaryState {
  final Summary? summary;
  final bool isLoading;
  final String? error;

  SummaryState({
    this.summary,
    this.isLoading = false,
    this.error,
  });

  SummaryState copyWith({
    Summary? summary,
    bool? isLoading,
    String? error,
  }) {
    return SummaryState(
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// ✅ NOTIFIER CLASS
class SummaryNotifier extends StateNotifier<SummaryState> {
  final SummaryService _summaryService;

  SummaryNotifier(this._summaryService) : super(SummaryState());

  Future<void> fetchSummary() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final summary = await _summaryService.fetchSummary();
      state = state.copyWith(summary: summary, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// ✅ PROVIDER
final summaryProvider =
    StateNotifierProvider<SummaryNotifier, SummaryState>((ref) {
  final service = ref.watch(summaryServiceProvider);
  return SummaryNotifier(service);
});
