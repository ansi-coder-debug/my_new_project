import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/expense/expense_state.dart';
import 'package:my_new_project/core/models/expense.dart';
import 'package:uuid/uuid.dart';

final expenseProvider =
    StateNotifierProvider<ExpenseNotifier, ExpenseState>(
  (ref) => ExpenseNotifier(),
);

class ExpenseNotifier extends StateNotifier<ExpenseState> {
  ExpenseNotifier() : super(ExpenseState(expenses: []));

  void addExpense({
    required String amount,
    String? description,
    required String date,
    required String vehicleId,
  }) {
    final newExpense = Expense(
      id: const Uuid().v4(),
      amount: amount,
      description: description,
      date: date,
      vehicleId: vehicleId,
    );

    state = state.copyWith(expenses: [...state.expenses, newExpense]);
  }

  List<Expense> getExpensesForVehicle(String vehicleId) {
    return state.expenses.where((e) => e.vehicleId == vehicleId).toList();
  }

  List<Expense> getAllExpenses() => state.expenses;

  void deleteExpense(String id) {
  state = state.copyWith(
    expenses: state.expenses.where((e) => e.id != id).toList(),
  );
}
}
