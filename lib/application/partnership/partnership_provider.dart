import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/partnership/partnership_state.dart';
import 'package:my_new_project/core/models/partnership.dart';

final partnershipProvider =
    StateNotifierProvider<PartnershipNotifier, PartnershipState>(
  (ref) => PartnershipNotifier(),
);

class PartnershipNotifier extends StateNotifier<PartnershipState> {
  PartnershipNotifier() : super(PartnershipState(partnerships: []));

  void addPartnership(Partnership p) {
    state = state.copyWith(
      partnerships: [...state.partnerships, p],
    );
  }

  void deletePartnership(String id) {
    state = state.copyWith(
      partnerships: state.partnerships.where((p) => p.id != id).toList(),
    );
  }

  List<Partnership> getAllPartnerships() => state.partnerships;
}
