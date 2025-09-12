import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/broker.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';

final brokerServiceProvider = Provider<BrokerService>((ref) {
  final dio = Dio();
  return BrokerService(dio, ref);
});

class BrokerService {
  final Dio _dio;
  final Ref _ref;

  BrokerService(this._dio, this._ref);

  String? _getToken() {
    final auth = _ref.read(authNotifierProvider);
    return auth.user?.accessToken;
  }

  Future<List<Broker>> getBrokers() async {
    final token = _getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await _dio.get(
      'http://192.168.29.29:5000/api/brokers',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((e) => Broker.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch brokers');
    }
  }

  Future<Broker> createBroker(Broker broker) async {
    final token = _getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await _dio.post(
      'http://192.168.29.29:5000/api/brokers',
      data: broker.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Broker.fromJson(response.data);
    } else {
      throw Exception('Failed to create broker');
    }
  }

  Future<void> deleteBroker(int id) async {
    final token = _getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await _dio.delete(
      'http://192.168.29.29:5000/api/brokers/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete broker');
    }
  }

  Future<Broker> updateBroker(int id, Map<String, dynamic> data) async {
    final token = _getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await _dio.put(
      'http://192.168.29.29:5000/api/brokers/$id',
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return Broker.fromJson(response.data);
    } else {
      throw Exception('Failed to update broker');
    }
  }
}
