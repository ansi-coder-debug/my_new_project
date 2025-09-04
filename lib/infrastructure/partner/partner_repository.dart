import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/partner.dart';
import 'package:my_new_project/infrastructure/partner/partner_service.dart';

final partnerRepositoryProvider = Provider<PartnerRepository>((ref) {
  final service = ref.read(partnerServiceProvider);
  return PartnerRepository(service);
});

class PartnerRepository {
  final PartnerService _service;

  PartnerRepository(this._service);

  Future<List<Partner>> fetchPartners() => _service.getPartners();

  Future<Partner> addPartner(Partner partner) => _service.createPartner(partner);

  Future<Partner> updatePartner(String id, Map<String, dynamic> data) =>
      _service.updatePartner(id, data);

  Future<void> deletePartner(String id) => _service.deletePartner(id);
}
