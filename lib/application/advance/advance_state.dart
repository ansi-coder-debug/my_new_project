import 'package:my_new_project/core/models/advance.dart';

class AdvanceState {
  final List<Advance> advances;
  final bool isLoading;
  final String? error;
  final Advance? selectedAdvance;

  AdvanceState({
    required this.advances,
    this.isLoading = false,
    this.error,
    this.selectedAdvance,
  });

  AdvanceState copyWith({
    List<Advance>? advances,
    bool? isLoading,
    String? error,
    Advance? selectedAdvance,
    bool clearSelected = false,
  }) {
    return AdvanceState(
      advances: advances ?? this.advances,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedAdvance: clearSelected ? null : (selectedAdvance ?? this.selectedAdvance),
    );
  }
}
