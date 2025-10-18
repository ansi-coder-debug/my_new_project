import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/brokerage.dart';
import 'package:my_new_project/infrastructure/brokerage/brokerage_service.dart';

final brokerageRepositoryProvider = Provider<BrokerageRepository>((ref) {
  final service = ref.watch(brokerageServiceProvider);
  return BrokerageRepository(service);
});

class BrokerageRepository {
  final BrokerageService _service;

  BrokerageRepository(this._service);

  Future<List<Brokerage>> getBrokerages() => _service.getBrokerages();

  Future<Brokerage> addBrokerage(Brokerage brokerage) =>
      _service.addBrokerage(brokerage);

  Future<Brokerage> updateBrokerage(Brokerage brokerage) {
    if (brokerage.id == null) {
      throw Exception('Brokerage ID cannot be null for update');
    }
    return _service.updateBrokerage(brokerage);
  }

  Future<void> deleteBrokerage(int id) => _service.deleteBrokerage(id);
}
