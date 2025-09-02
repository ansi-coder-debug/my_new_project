import 'package:my_new_project/core/models/partnership.dart';

class PartnershipState {
  final List<Partnership> partnerships;
  final bool isLoading;
  final String? error;

  PartnershipState({
    required this.partnerships,
    this.isLoading = false,
    this.error,
  });

  PartnershipState copyWith({
    List<Partnership>? partnerships,
    bool? isLoading,
    String? error,
  }) {
    return PartnershipState(
      partnerships: partnerships ?? this.partnerships,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
