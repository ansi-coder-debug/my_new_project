import 'package:my_new_project/core/models/broker.dart';

class BrokerState {
  final bool isLoading;
  final List<Broker> brokers;
  final String? errorMessage;

  BrokerState({
    this.isLoading = false,
    this.brokers = const [],
    this.errorMessage,
  });

  BrokerState copyWith({
    bool? isLoading,
    List<Broker>? brokers,
    String? errorMessage,
  }) {
    return BrokerState(
      isLoading: isLoading ?? this.isLoading,
      brokers: brokers ?? this.brokers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
