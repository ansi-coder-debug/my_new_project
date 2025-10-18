import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/brokerage.dart';
import 'package:my_new_project/application/brokerage/brokerage_state.dart';
import 'package:my_new_project/infrastructure/brokerage/brokerage_repositary.dart';


final brokerageProvider =
    StateNotifierProvider<BrokerageNotifier, BrokerageState>((ref) {
  final repository = ref.watch(brokerageRepositoryProvider);
  return BrokerageNotifier(repository);
});

class BrokerageNotifier extends StateNotifier<BrokerageState> {
  final BrokerageRepository _repository;

  BrokerageNotifier(this._repository)
      : super(BrokerageState(brokerages: [])) {
    loadBrokerages();
  }

  Future<void> loadBrokerages() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final brokerages = await _repository.getBrokerages();
      state = state.copyWith(brokerages: brokerages, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addBrokerage(Brokerage brokerage) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.addBrokerage(brokerage);
      await loadBrokerages();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateBrokerage(Brokerage brokerage) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.updateBrokerage(brokerage);
      await loadBrokerages();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteBrokerage(int id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.deleteBrokerage(id);
      await loadBrokerages();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSelectedBrokerage(Brokerage? brokerage) {
    state = state.copyWith(selectedBrokerage: brokerage);
  }

  void clearSelectedBrokerage() {
    state = state.copyWith(clearSelected: true);
  }
}
