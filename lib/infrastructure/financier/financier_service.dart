// lib/infrastructure/financiers/financier_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/financier.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';

final financierServiceProvider = Provider<FinancierService>((ref) {
  final dio = Dio();
  return FinancierService(dio, ref);
});

class FinancierService {
  final Dio _dio;
  final Ref _ref;

  FinancierService(this._dio, this._ref);

  static const _baseUrl = 'http://192.168.29.29:5000/api/financiers';

  Future<List<Financier>> getFinanciers() async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data as List;
    return data.map((json) => Financier.fromJson(json)).toList();
  }

  Future<Financier> addFinancier(Financier financier) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.post(
      _baseUrl,
      data: financier.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return Financier.fromJson(response.data);
  }

  Future<Financier> updateFinancier(Financier financier) async {
    if (financier.id == null) {
      throw Exception('Financier ID is required for update');
    }

    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.put(
      '$_baseUrl/${financier.id}',
      data: financier.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return Financier.fromJson(response.data);
  }

  Future<void> deleteFinancier(int id) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    await _dio.delete(
      '$_baseUrl/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
