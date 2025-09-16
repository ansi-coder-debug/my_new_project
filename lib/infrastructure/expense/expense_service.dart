import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/expense.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';

final expenseServiceProvider = Provider<ExpenseService>((ref) {
  final dio = Dio();
  return ExpenseService(dio, ref);
});

class ExpenseService {
  final Dio _dio;
  final Ref _ref;

  ExpenseService(this._dio, this._ref);

  Future<List<Expense>> getExpenses() async {
    try {
      final token = _ref.read(authNotifierProvider).user?.accessToken;

      if (token == null) throw Exception('User not authenticated');

      final response = await _dio.get(
        'http://192.168.29.29:5000/api/expenses',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data;

      if (data is List) {
        return data.map((json) => Expense.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format: $data');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch expenses: ${e.response?.data ?? e.message}');
    }
  }

  // Future<void> addExpense(Expense expense) async {
  //   try {
  //     final token = _ref.read(authNotifierProvider).user?.accessToken;
  //     if (token == null) throw Exception('User not authenticated');

  //      print('Sending expense to backend: ${expense.toJson()}');

  //     final response = await _dio.post(
  //       'http://192.168.29.29:5000/api/expenses',
  //       data: expense.toJson(),
  //       options: Options(headers: {'Authorization': 'Bearer $token'}),
  //     );

      
  //   print('Backend response: ${response.statusCode} ${response.data}');

  //     if (response.statusCode != 201) {
  //       throw Exception('Failed to create expense');
  //     }
  //   } on DioException catch (e) {
  //     throw Exception('Failed to create expense: ${e.response?.data ?? e.message}');
  //   }
  // }

  Future<void> addExpense(Expense expense) async {
  try {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    print('🟠 Token used: $token');

    if (token == null) throw Exception('User not authenticated');

    print('🔵 Sending POST to backend with: ${expense.toJson()}');

    final response = await _dio.post(
      'http://192.168.29.29:5000/api/expenses',
      data: expense.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    print('🟢 Backend response: ${response.statusCode} - ${response.data}');

    if (response.statusCode != 201) {
      throw Exception('Backend failed to create expense');
    }
  } on DioException catch (e) {
    print('🔴 Dio error: ${e.response?.data ?? e.message}');
    throw Exception('Failed to create expense: ${e.response?.data ?? e.message}');
  }
}


  Future<void> deleteExpense(String id) async {
    try {
      final token = _ref.read(authNotifierProvider).user?.accessToken;
      if (token == null) throw Exception('User not authenticated');

      final response = await _dio.delete(
        'http://192.168.29.29:5000/api/expenses/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete expense');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete expense: ${e.response?.data ?? e.message}');
    }
  }
}
