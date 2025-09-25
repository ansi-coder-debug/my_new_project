// lib/infrastructure/payroll/payroll_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/payroll.dart';
import 'package:my_new_project/infrastructure/payroll/payroll_service.dart';

final payrollRepositoryProvider = Provider<PayrollRepository>((ref) {
  final service = ref.watch(payrollServiceProvider);
  return PayrollRepository(service);
});

class PayrollRepository {
  final PayrollService _service;

  PayrollRepository(this._service);

  Future<List<Payroll>> getPayrolls() => _service.getPayrolls();

  Future<Payroll> addPayroll(Payroll payroll) => _service.addPayroll(payroll);

  Future<Payroll> updatePayroll(Payroll payroll) => _service.updatePayroll(payroll);

  Future<void> deletePayroll(int id) => _service.deletePayroll(id);
}
