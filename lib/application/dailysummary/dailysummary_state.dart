import 'package:my_new_project/core/models/dailysummary.dart';

class DailySummaryState {
  final List<DailySummary> summaries;
  final bool isLoading;
  final String? error;
  final DailySummary? selectedSummary;

  DailySummaryState({
    required this.summaries,
    this.isLoading = false,
    this.error,
    this.selectedSummary,
  });

  DailySummaryState copyWith({
    List<DailySummary>? summaries,
    bool? isLoading,
    String? error,
    DailySummary? selectedSummary,
    bool clearSelected = false,
  }) {
    return DailySummaryState(
      summaries: summaries ?? this.summaries,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedSummary: clearSelected
          ? null
          : (selectedSummary ?? this.selectedSummary),
    );
  }
}
