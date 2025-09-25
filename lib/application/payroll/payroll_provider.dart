// lib/application/payroll/payroll_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/payroll.dart';
import 'package:my_new_project/application/payroll/payroll_state.dart';
import 'package:my_new_project/infrastructure/payroll/payroll_repositary.dart';


final payrollProvider = StateNotifierProvider<PayrollNotifier, PayrollState>((ref) {
  final repository = ref.watch(payrollRepositoryProvider);
  return PayrollNotifier(repository);
});

class PayrollNotifier extends StateNotifier<PayrollState> {
  final PayrollRepository _repository;

  PayrollNotifier(this._repository) : super(PayrollState(payrolls: [])) {
    loadPayrolls();
  }

  Future<void> loadPayrolls() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final payrolls = await _repository.getPayrolls();
      state = state.copyWith(payrolls: payrolls, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addPayroll(Payroll payroll) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.addPayroll(payroll);
      await loadPayrolls();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updatePayroll(Payroll payroll) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.updatePayroll(payroll);
      await loadPayrolls();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deletePayroll(int id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.deletePayroll(id);
      await loadPayrolls();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSelectedPayroll(Payroll? payroll) {
    state = state.copyWith(selectedPayroll: payroll);
  }

  void clearSelectedPayroll() {
    state = state.copyWith(clearSelected: true);
  }
}
