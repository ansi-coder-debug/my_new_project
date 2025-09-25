// lib/application/payroll/payroll_state.dart

import 'package:my_new_project/core/models/payroll.dart';

class PayrollState {
  final List<Payroll> payrolls;
  final bool isLoading;
  final String? error;
  final Payroll? selectedPayroll;

  PayrollState({
    required this.payrolls,
    this.isLoading = false,
    this.error,
    this.selectedPayroll,
  });

  PayrollState copyWith({
    List<Payroll>? payrolls,
    bool? isLoading,
    String? error,
    Payroll? selectedPayroll,
    bool clearSelected = false,
  }) {
    return PayrollState(
      payrolls: payrolls ?? this.payrolls,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedPayroll: clearSelected ? null : (selectedPayroll ?? this.selectedPayroll),
    );
  }
}
