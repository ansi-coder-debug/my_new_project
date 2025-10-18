import 'package:my_new_project/core/models/brokerage.dart';

class BrokerageState {
  final List<Brokerage> brokerages;
  final bool isLoading;
  final String? error;
  final Brokerage? selectedBrokerage;

  BrokerageState({
    required this.brokerages,
    this.isLoading = false,
    this.error,
    this.selectedBrokerage,
  });

  BrokerageState copyWith({
    List<Brokerage>? brokerages,
    bool? isLoading,
    String? error,
    Brokerage? selectedBrokerage,
    bool clearSelected = false,
  }) {
    return BrokerageState(
      brokerages: brokerages ?? this.brokerages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedBrokerage:
          clearSelected ? null : (selectedBrokerage ?? this.selectedBrokerage),
    );
  }
}
