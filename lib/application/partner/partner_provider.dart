import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/partner/partner_state.dart';
import 'package:my_new_project/core/models/partner.dart';
import 'package:my_new_project/infrastructure/partner/partner_repository.dart';

class PartnerNotifier extends StateNotifier<PartnerState> {
  final PartnerRepository _repository;

  PartnerNotifier(this._repository) : super(PartnerState());

  // Load all partners
  Future<void> loadPartners() async {
    state = state.copyWith(isLoading: true);
    try {
      final partners = await _repository.fetchPartners();
      state = state.copyWith(
        partners: partners,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // Add new partner
  Future<void> addPartner(Partner partner) async {
    try {
      print("Before add → partners count: ${state.partners.length}");
      final created = await _repository.addPartner(partner);

      print("Repository returned: $created (${created.runtimeType})");
      // state = state.copyWith(partners: [...state.partners, created]);
      await loadPartners();
      print("After add → partners count: ${state.partners.length}");
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      print("Error while adding partner: $e");
    }
  }

  // // Update partner
  // Future<void> updatePartner(String id, Map<String, dynamic> data) async {
  //   try {
  //     final updated = await _repository.updatePartner(id, data);
  //     final updatedList = state.partners.map((p) {
  //       return p.id == updated.id ? updated : p;
  //     }).toList();
  //     // state = state.copyWith(partners: updatedList);
  //     await loadPartners();
  //   } catch (e) {
  //     state = state.copyWith(errorMessage: e.toString());
  //   }
  // }

  // In PartnerNotifier
Future<void> updatePartner(Partner partner) async {
  try {
    final updated = await _repository.updatePartner(partner.id!, partner.toJson());
    final updatedList = state.partners.map((p) {
      return p.id == updated.id ? updated : p;
    }).toList();
    await loadPartners();
  } catch (e) {
    state = state.copyWith(errorMessage: e.toString());
  }
}


  // Delete partner
  Future<void> deletePartner(String id) async {
    try {
      await _repository.deletePartner(id);
      final filtered = state.partners.where((p) => p.id != id).toList();
      // state = state.copyWith(partners: filtered);
      await loadPartners();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

// ✅ Provider
final partnerProvider = StateNotifierProvider<PartnerNotifier, PartnerState>((
  ref,
) {
  final repository = ref.watch(partnerRepositoryProvider);
  return PartnerNotifier(repository);
});


// ✅ Holds the currently selected partner in forms
final selectedPartnerProvider = StateProvider<Partner?>((ref) => null);
