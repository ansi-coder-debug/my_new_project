import 'package:my_new_project/core/models/partnership.dart';

class PartnershipState {
  final List<Partnership> partnerships;
  final bool isLoading;
  final String? error;
  final Partnership? selectedPartnership;

  PartnershipState({
    required this.partnerships,
    this.isLoading = false,
    this.error,
    this.selectedPartnership,
  });

  PartnershipState copyWith({
    List<Partnership>? partnerships,
    bool? isLoading,
    String? error,
    Partnership? selectedPartnership,
    bool clearSelected = false,
  }) {
    return PartnershipState(
      partnerships: partnerships ?? this.partnerships,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedPartnership:
          clearSelected ? null : (selectedPartnership ?? this.selectedPartnership),
    );
  }
}
