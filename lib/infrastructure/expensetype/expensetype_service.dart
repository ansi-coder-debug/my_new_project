import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/expensetype.dart';

final expenseTypeServiceProvider = Provider<ExpenseTypeService>((ref) {
  final dio = Dio();
  return ExpenseTypeService(dio, ref);
});

class ExpenseTypeService {
  final Dio _dio;
  final Ref _ref;

  ExpenseTypeService(this._dio, this._ref);

  Future<List<ExpenseType>> getExpenseTypes() async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.get(
      '$HbaseUrl/expense-type',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data as List;
    return data.map((json) => ExpenseType.fromJson(json)).toList();
  }

  Future<ExpenseType> addExpenseType(ExpenseType expenseType) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.post(
      '$HbaseUrl/expense-type',
      data: expenseType.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return ExpenseType.fromJson(response.data);
  }

  Future<ExpenseType> updateExpenseType(ExpenseType expenseType) async {
    if (expenseType.id == null) {
      throw Exception('ExpenseType ID is required for update');
    }
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.put(
      '$HbaseUrl/expense-type/${expenseType.id}',
      data: expenseType.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return ExpenseType.fromJson(response.data);
  }

  Future<void> deleteExpenseType(int id) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    await _dio.delete(
      '$HbaseUrl/expense-type/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
