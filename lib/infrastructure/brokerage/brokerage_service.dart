import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/brokerage.dart';

final brokerageServiceProvider = Provider<BrokerageService>((ref) {
  final dio = Dio();
  return BrokerageService(dio, ref);
});

class BrokerageService {
  final Dio _dio;
  final Ref _ref;

  BrokerageService(this._dio, this._ref);

  Future<List<Brokerage>> getBrokerages() async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.get(
      '$HbaseUrl/brokerages',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data as List;
    return data.map((json) => Brokerage.fromJson(json)).toList();
  }

  Future<Brokerage> addBrokerage(Brokerage brokerage) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.post(
      '$HbaseUrl/brokerages',
      data: brokerage.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return Brokerage.fromJson(response.data);
  }

  Future<Brokerage> updateBrokerage(Brokerage brokerage) async {
    if (brokerage.id == null) {
      throw Exception('Brokerage ID is required for update');
    }
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.put(
      '$HbaseUrl/brokerages/${brokerage.id}',
      data: brokerage.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return Brokerage.fromJson(response.data);
  }

  Future<void> deleteBrokerage(int id) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    await _dio.delete(
      '$HbaseUrl/brokerages/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
