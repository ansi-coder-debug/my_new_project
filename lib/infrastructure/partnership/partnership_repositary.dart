import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/infrastructure/partnership/partnership_service.dart';

final partnershipRepositoryProvider = Provider<PartnershipRepository>((ref) {
  final service = ref.watch(partnershipServiceProvider);
  return PartnershipRepository(service);
});

class PartnershipRepository {
  final PartnershipService _service;

  PartnershipRepository(this._service);

  Future<List<Partnership>> getAllPartnerships() => _service.getAllPartnerships();

  Future<Partnership> addPartnership(Partnership partnership) =>
      _service.addPartnership(partnership);

  Future<Partnership> updatePartnership(Partnership partnership) {
    if (partnership.id == null || partnership.id!.isEmpty) {
      throw Exception('Partnership ID cannot be null for update');
    }
    return _service.updatePartnership(partnership);
  }

  Future<void> deletePartnership(String id) => _service.deletePartnership(id);
}
