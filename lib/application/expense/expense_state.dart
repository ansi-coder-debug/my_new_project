import 'package:my_new_project/core/models/expense.dart';

class ExpenseState {
  final List<Expense> expenses;
  final bool isLoading;
  final String? error;

  ExpenseState({
    required this.expenses,
    this.isLoading = false,
    this.error,
  });

  ExpenseState copyWith({
    List<Expense>? expenses,
    bool? isLoading,
    String? error,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
