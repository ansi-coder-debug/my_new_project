// lib/infrastructure/payroll/payroll_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/payroll.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';

final payrollServiceProvider = Provider<PayrollService>((ref) {
  final dio = Dio();
  return PayrollService(dio, ref);
});

class PayrollService {
  final Dio _dio;
  final Ref _ref;

  PayrollService(this._dio, this._ref);

  String get _baseUrl => 'http://192.168.29.29:5000/api/employee-payroll';

  Future<List<Payroll>> getPayrolls() async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data as List;
    return data.map((json) => Payroll.fromJson(json)).toList();
  }

  Future<Payroll> addPayroll(Payroll payroll) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.post(
      _baseUrl,
      data: payroll.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return Payroll.fromJson(response.data);
  }

  Future<Payroll> updatePayroll(Payroll payroll) async {
    if (payroll.id == null) throw Exception("Payroll ID is required for update");

    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.put(
      '$_baseUrl/${payroll.id}',
      data: payroll.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return Payroll.fromJson(response.data);
  }

  Future<void> deletePayroll(int id) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    await _dio.delete(
      '$_baseUrl/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
