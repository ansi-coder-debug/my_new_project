import 'package:my_new_project/core/models/monthlysummary.dart';

class MonthlySummaryState {
  final List<MonthlySummary> summaries;
  final bool isLoading;
  final String? error;
  final MonthlySummary? selectedSummary;

  MonthlySummaryState({
    required this.summaries,
    this.isLoading = false,
    this.error,
    this.selectedSummary,
  });

  MonthlySummaryState copyWith({
    List<MonthlySummary>? summaries,
    bool? isLoading,
    String? error,
    MonthlySummary? selectedSummary,
    bool clearSelected = false,
  }) {
    return MonthlySummaryState(
      summaries: summaries ?? this.summaries,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedSummary: clearSelected
          ? null
          : (selectedSummary ?? this.selectedSummary),
    );
  }
}
