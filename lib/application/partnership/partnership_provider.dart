import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/infrastructure/partnership/partnership_repositary.dart';
import 'package:my_new_project/application/partnership/partnership_state.dart';

final partnershipProvider =
    StateNotifierProvider<PartnershipNotifier, PartnershipState>((ref) {
  final repository = ref.watch(partnershipRepositoryProvider);
  return PartnershipNotifier(repository);
});

class PartnershipNotifier extends StateNotifier<PartnershipState> {
  final PartnershipRepository _repository;

  PartnershipNotifier(this._repository)
      : super(PartnershipState(partnerships: [])) {
    loadPartnerships();
  }

  Future<void> loadPartnerships() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final partnerships = await _repository.getAllPartnerships();
      state = state.copyWith(partnerships: partnerships, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addPartnership(Partnership partnership) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.addPartnership(partnership);
      await loadPartnerships();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updatePartnership(Partnership partnership) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.updatePartnership(partnership);
      await loadPartnerships();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deletePartnership(String id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.deletePartnership(id);
      await loadPartnerships();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSelectedPartnership(Partnership? partnership) {
    state = state.copyWith(selectedPartnership: partnership);
  }

  void clearSelectedPartnership() {
    state = state.copyWith(clearSelected: true);
  }
}
