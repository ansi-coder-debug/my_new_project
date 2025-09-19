import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/employee.dart';

import 'employee_service.dart';


final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  final service = ref.watch(employeeServiceProvider);
  return EmployeeRepository(service);
});

class EmployeeRepository {
  final EmployeeService _employeeService;

  EmployeeRepository(this._employeeService);

  Future<List<Employee>> getEmployees() async {
    return await _employeeService.getEmployees();
  }

  Future<void> addEmployee(Employee employee) async {
    await _employeeService.addEmployee(employee);
  }

  Future<void> deleteEmployee(int id) async {
    await _employeeService.deleteEmployee(id);
  }
}
