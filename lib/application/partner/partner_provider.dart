import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/partner.dart';

final partnerProvider = StateNotifierProvider<PartnerNotifier, List<Partner>>((ref) {
  return PartnerNotifier();
});

class PartnerNotifier extends StateNotifier<List<Partner>> {
  PartnerNotifier() : super([]);

  void addPartner(Partner partner) {
    state = [...state, partner];
  }

  void deletePartner(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}
