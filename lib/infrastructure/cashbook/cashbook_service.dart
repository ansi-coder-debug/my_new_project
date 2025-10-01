import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/core/models/cashbook.dart';

final cashBookServiceProvider = Provider<CashBookService>((ref) {
  final dio = Dio();
  return CashBookService(dio, ref);
});

class CashBookService {
  final Dio _dio;
  final Ref _ref;
  

  CashBookService(this._dio, this._ref);

  String get _baseUrl => 'http://192.168.29.29:5000/api/cash-Book';

  Future<List<CashBookEntry>> getAll() async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;

    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data as List;
    return data.map((e) => CashBookEntry.fromJson(e)).toList();
  }

  Future<CashBookEntry> create(CashBookEntry entry) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;

    final response = await _dio.post(
      _baseUrl,
      data: entry.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    
  print("🔍 Raw cashbook list JSON response: ${response.data}");

  

    return CashBookEntry.fromJson(response.data);
  }

  Future<CashBookEntry> update(CashBookEntry entry) async {
    if (entry.id == null) {
      throw Exception('ID is required to update a cashbook entry');
    }

    final token = _ref.read(authNotifierProvider).user?.accessToken;

    final response = await _dio.put(
      '$_baseUrl/${entry.id}',
      data: entry.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return CashBookEntry.fromJson(response.data);
  }

  Future<void> delete(String id) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;

    await _dio.delete(
      '$_baseUrl/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
