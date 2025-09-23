// // expense_state.dart
// import 'package:my_new_project/core/models/expense.dart';

// enum ExpenseStatus { initial, loading, success, error }

// class ExpenseState {
//   final List<Expense> expenses;
//   final ExpenseStatus status;
//   final String? error;

//   ExpenseState({
//     required this.expenses,
//     required this.status,
//     this.error,
//   });

//   factory ExpenseState.initial() {
//     return ExpenseState(
//       expenses: [],
//       status: ExpenseStatus.initial,
//       error: null,
//     );
//   }

//   ExpenseState copyWith({
//     List<Expense>? expenses,
//     ExpenseStatus? status,
//     String? error,
//   }) {
//     return ExpenseState(
//       expenses: expenses ?? this.expenses,
//       status: status ?? this.status,
//       error: error ?? this.error,
//     );
//   }
// }

import 'package:my_new_project/core/models/expense.dart';

class ExpenseState {
  final List<Expense> expenses;
  final bool isLoading;
  final String? error;
  final Expense? selectedExpense;

  ExpenseState({
    required this.expenses,
    this.isLoading = false,
    this.error,
    this.selectedExpense,
  });

  ExpenseState copyWith({
    List<Expense>? expenses,
    bool? isLoading,
    String? error,
    Expense? selectedExpense,
    bool clearSelected = false,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedExpense: clearSelected ? null : (selectedExpense ?? this.selectedExpense),
    );
  }
}
