import 'package:my_new_project/core/models/partner.dart';

class PartnerState {
  final bool isLoading;
  final List<Partner> partners;
  final String? errorMessage;

  PartnerState({
    this.isLoading = false,
    this.partners = const [],
    this.errorMessage,
  });

  PartnerState copyWith({
    bool? isLoading,
    List<Partner>? partners,
    String? errorMessage,
  }) {
    return PartnerState(
      isLoading: isLoading ?? this.isLoading,
      partners: partners ?? this.partners,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
