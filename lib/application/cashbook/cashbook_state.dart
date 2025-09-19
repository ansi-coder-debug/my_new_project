
import 'package:my_new_project/core/models/cashbook.dart';

class CashBookState {
  final List<CashBookEntry> entries;
  final bool isLoading;
  final String? error;
  final CashBookEntry? selectedEntry;

  CashBookState({
    required this.entries,
    this.isLoading = false,
    this.error,
    this.selectedEntry,
  });

  CashBookState copyWith({
    List<CashBookEntry>? entries,
    bool? isLoading,
    String? error,
    CashBookEntry? selectedEntry,
    bool clearSelected = false,
  }) {
    return CashBookState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedEntry: clearSelected ? null : (selectedEntry ?? this.selectedEntry),
    );
  }
}
