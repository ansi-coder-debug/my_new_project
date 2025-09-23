import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/finance.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';

final financeServiceProvider = Provider<FinanceService>((ref) {
  final dio = Dio();
  return FinanceService(dio, ref);
});

class FinanceService {
  final Dio _dio;
  final Ref _ref;

  FinanceService(this._dio, this._ref);

  Future<List<Finance>> getAllFinances() async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.get(
      'http://192.168.29.29:5000/api/finances',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print("📥 Raw backend response: ${response.data}");


    final data = response.data as List;
    
    return data.map((json) => Finance.fromJson(json)).toList();
    
  }

  Future<Finance> addFinance(Finance finance) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.post(
      'http://192.168.29.29:5000/api/finances',
      data: finance.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return Finance.fromJson(response.data);
  }

  Future<Finance> updateFinance(Finance finance) async {
    if (finance.id.isEmpty) {
      throw Exception('Finance ID is required for update');
    }
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.put(
      'http://192.168.29.29:5000/api/finances/${finance.id}',
      data: finance.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return Finance.fromJson(response.data);
  }

  Future<void> deleteFinance(String id) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    await _dio.delete(
      'http://192.168.29.29:5000/api/finances/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
