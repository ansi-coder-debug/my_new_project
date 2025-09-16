// expense_state.dart
import 'package:my_new_project/core/models/expense.dart';

enum ExpenseStatus { initial, loading, success, error }

class ExpenseState {
  final List<Expense> expenses;
  final ExpenseStatus status;
  final String? error;

  ExpenseState({
    required this.expenses,
    required this.status,
    this.error,
  });

  factory ExpenseState.initial() {
    return ExpenseState(
      expenses: [],
      status: ExpenseStatus.initial,
      error: null,
    );
  }

  ExpenseState copyWith({
    List<Expense>? expenses,
    ExpenseStatus? status,
    String? error,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
