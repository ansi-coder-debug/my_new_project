import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/broker/broker_state.dart';
import 'package:my_new_project/core/models/broker.dart';
import 'package:my_new_project/infrastructure/broker/broker_repositary.dart';


class BrokerNotifier extends StateNotifier<BrokerState> {
  final BrokerRepository _repository;

  BrokerNotifier(this._repository) : super(BrokerState());

  Future<void> loadBrokers() async {
    state = state.copyWith(isLoading: true);
    try {
      final brokers = await _repository.fetchBrokers();
      state = state.copyWith(brokers: brokers, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addBroker(Broker broker) async {
    try {
      await _repository.addBroker(broker);
      await loadBrokers();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> updateBroker(int id, Map<String, dynamic> data) async {
    try {
      await _repository.updateBroker(id, data);
      await loadBrokers();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> deleteBroker(int id) async {
    try {
      await _repository.deleteBroker(id);
      await loadBrokers();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

// ✅ Riverpod Provider
final brokerProvider = StateNotifierProvider<BrokerNotifier, BrokerState>((ref) {
  final repo = ref.read(brokerRepositoryProvider);
  return BrokerNotifier(repo);
});
