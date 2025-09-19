import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/employee/employee_state.dart';
import 'package:my_new_project/core/models/employee.dart';
import 'package:my_new_project/infrastructure/employee/employee_repositary.dart';

final employeeProvider = StateNotifierProvider<EmployeeNotifier, EmployeeState>(
  (ref) {
    final repository = ref.watch(employeeRepositoryProvider);
    return EmployeeNotifier(repository);
  },
);

class EmployeeNotifier extends StateNotifier<EmployeeState> {
  final EmployeeRepository _repository;

  EmployeeNotifier(this._repository) : super(EmployeeState.initial()) {
    fetchEmployees();
  }

  /// Fetch all employees from backend
  Future<void> fetchEmployees() async {
     print("🚀 fetch employees called");
    try {
      state = state.copyWith(status: EmployeeStatus.loading, error: null);
      final employees = await _repository.getEmployees();
      print('🧾 Employees fetched from repository: ${employees.length}');
      loadEmployees(employees);
    } catch (e) {
      state = state.copyWith(status: EmployeeStatus.error, error: e.toString());
    }
  }

  /// Add a new employee to backend
  Future<void> addEmployee(Employee employee) async {
    try {
       print('➕ Adding employee: ${employee.name}');
      await _repository.addEmployee(employee);

      print('✅ employee added, reloading employees');
      await fetchEmployees(); // Refresh list after adding
    } catch (e) {
      state = state.copyWith(status: EmployeeStatus.error, error: e.toString());
    }
  }

  /// Load employees into state directly
  void loadEmployees(List<Employee> employees) {
 print('✅ loadEmployees called with ${employees.length} employees');    state = state.copyWith(
      employees: employees,
      status: EmployeeStatus.success,
      error: null,
    );
      print('🔄 State updated with employees, current count: ${state.employees.length}');

  }

  /// Update a local employee (optimistic UI update)
  void updateEmployee(Employee updatedEmployee) {
    final index = state.employees.indexWhere((e) => e.id == updatedEmployee.id);
    if (index == -1) {
      state = state.copyWith(
        status: EmployeeStatus.error,
        error: 'Employee not found',
      );
      return;
    }

    final updatedList = [...state.employees];
    updatedList[index] = updatedEmployee;

    state = state.copyWith(
      employees: updatedList,
      status: EmployeeStatus.success,
      error: null,
    );
  }

  /// Delete employee from backend and refresh
  Future<void> deleteEmployee(int id) async {
    try {
      await _repository.deleteEmployee(id);
      await fetchEmployees();
    } catch (e) {
      state = state.copyWith(status: EmployeeStatus.error, error: e.toString());
    }
  }

  /// Clear all employees from local state
  void clearEmployees() {
    state = state.copyWith(
      employees: [],
      status: EmployeeStatus.success,
      error: null,
    );
  }

  /// Refresh from backend
  Future<void> refresh() async {
    await fetchEmployees();
  }

  /// Get all employees (shortcut)
  List<Employee> get allEmployees => state.employees;
}
