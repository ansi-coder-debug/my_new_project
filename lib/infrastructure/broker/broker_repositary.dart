import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/broker.dart';
import 'package:my_new_project/infrastructure/broker/broker_service.dart';

final brokerRepositoryProvider = Provider<BrokerRepository>((ref) {
  final service = ref.read(brokerServiceProvider);
  return BrokerRepository(service);
});

class BrokerRepository {
  final BrokerService _service;

  BrokerRepository(this._service);

  Future<List<Broker>> fetchBrokers() => _service.getBrokers();

  Future<Broker> addBroker(Broker broker) => _service.createBroker(broker);

  Future<void> deleteBroker(int id) => _service.deleteBroker(id);

  Future<Broker> updateBroker(int id, Map<String, dynamic> data) =>
      _service.updateBroker(id, data);
}
