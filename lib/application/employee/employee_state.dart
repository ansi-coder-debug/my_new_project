import 'package:my_new_project/core/models/employee.dart';

enum EmployeeStatus { initial, loading, success, error }

class EmployeeState {
  final List<Employee> employees;
  final EmployeeStatus status;
  final String? error;

  EmployeeState({
    required this.employees,
    required this.status,
    this.error,
  });

  factory EmployeeState.initial() {
    return EmployeeState(
      employees: [],
      status: EmployeeStatus.initial,
      error: null,
    );
  }

  EmployeeState copyWith({
    List<Employee>? employees,
    EmployeeStatus? status,
    String? error,
  }) {
    return EmployeeState(
      employees: employees ?? this.employees,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
