import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/core/models/employee.dart';

final employeeServiceProvider = Provider<EmployeeService>((ref) {
  final dio = Dio();
  return EmployeeService(dio, ref);
});

class EmployeeService {
  final Dio _dio;
  final Ref _ref;

  EmployeeService(this._dio, this._ref);

  // // Fetch employees from the API
  // Future<List<Employee>> getEmployees() async {
  //   try {
  //     final token = _ref.read(authNotifierProvider).user?.accessToken;

  //     if (token == null) throw Exception('User not authenticated');

  //     final response = await _dio.get(
  //       'http://192.168.29.29:5000/api/employees', // Replace with your API URL
  //       options: Options(headers: {'Authorization': 'Bearer $token'}),
  //     );

  //     print('API RESPONSE 🔹 API response data: ${response.data} ');

  //     final data = response.data;

  //     if (data is List) {
  //       return data.map((json) => Employee.fromJson(json)).toList();
  //     } else {
  //       throw Exception('Invalid response format: $data');
  //     }
  //   } on DioException catch (e) {
  //     throw Exception(
  //       'Failed to fetch employees: ${e.response?.data ?? e.message}',
  //     );
  //   }
  // }


  Future<List<Employee>> getEmployees() async {
  try {
    final token = _ref.read(authNotifierProvider).user?.accessToken;

    if (token == null) throw Exception('User not authenticated');

    final response = await _dio.get(
      'http://192.168.29.29:5000/api/employees',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    print('API RESPONSE 🔹 API response data: ${response.data} ');

    final data = response.data;

    if (data is List) {
      final employees = <Employee>[];

      for (final json in data) {
        try {
          final employee = Employee.fromJson(json);
          employees.add(employee);
        } catch (e, st) {
          print('❌ Failed to parse employee: $json');
          print('📍 Error: $e');
          print('📍 Stack: $st');
        }
      }

      print('✅ Parsed ${employees.length} employees');
      return employees;
    } else {
      throw Exception('Invalid response format: $data');
    }
  } on DioException catch (e) {
    throw Exception(
      'Failed to fetch employees: ${e.response?.data ?? e.message}',
    );
  }
}




  // Add a new employee to the backend
  Future<void> addEmployee(Employee employee) async {
    try {
      final token = _ref.read(authNotifierProvider).user?.accessToken;

      if (token == null) throw Exception('User not authenticated');

      final response = await _dio.post(
        'http://192.168.29.29:5000/api/employees', // Replace with your API URL
        data: employee.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create employee');
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to create employee: ${e.response?.data ?? e.message}',
      );
    }
  }

  // Delete an employee by id
  Future<void> deleteEmployee(int id) async {
    try {
      final token = _ref.read(authNotifierProvider).user?.accessToken;

      if (token == null) throw Exception('User not authenticated');

      final response = await _dio.delete(
        'http://192.168.29.29:5000/api/employees/$id', // Replace with your API URL
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete employee');
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to delete employee: ${e.response?.data ?? e.message}',
      );
    }
  }
}
