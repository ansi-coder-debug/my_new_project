// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_new_project/application/expense/expense_state.dart';
// import 'package:my_new_project/core/models/expense.dart';
// import 'package:my_new_project/infrastructure/expense/expense_repositary.dart';
// import 'package:uuid/uuid.dart';

// // Provide ExpenseNotifier with ExpenseRepository injected
// final expenseProvider = StateNotifierProvider<ExpenseNotifier, ExpenseState>(
//   (ref) {
//     final repository = ref.watch(expenseRepositoryProvider);
//     return ExpenseNotifier(repository);
//   },
// );

// class ExpenseNotifier extends StateNotifier<ExpenseState> {
//   final ExpenseRepository _repository;

//   ExpenseNotifier(this._repository) : super(ExpenseState.initial());

//   // Fetch expenses from backend and load into state
//   Future<void> fetchExpenses() async {
//     try {
//       state = state.copyWith(status: ExpenseStatus.loading, error: null);
//       final expenses = await _repository.getExpenses();
//       loadExpenses(expenses);
//     } catch (e) {
//       state = state.copyWith(status: ExpenseStatus.error, error: e.toString());
//     }
//   }

//     Future<void> addExpense({
//   required String amount,
//   String? description,
//   required String date,
//   required String vehicleId,
//   required String type,
// }) async {
//   final newExpense = Expense(
//     id: const Uuid().v4(),
//     amount: amount,
//     description: description,
//     date: date,
//     vehicleId: vehicleId,
//     type: type,
//   );

//   print('🟡 Trying to add expense: ${newExpense.toJson()}');

//   try {
//     await _repository.addExpense(newExpense);
//     print('🟢 Successfully sent to backend');

//     await fetchExpenses();
//   } catch (e) {
//     print('🔴 Error while adding expense: $e');
//     state = state.copyWith(status: ExpenseStatus.error, error: e.toString());
//   }
// }

//   // Load expenses into state
//   void loadExpenses(List<Expense> expenses) {
//     state = state.copyWith(
//       expenses: expenses,
//       status: ExpenseStatus.success,
//       error: null,
//     );
//   }

//   // Update expense
//   void updateExpense(Expense updatedExpense) {
//     final index = state.expenses.indexWhere((e) => e.id == updatedExpense.id);
//     if (index == -1) {
//       state = state.copyWith(status: ExpenseStatus.error, error: 'Expense not found');
//       return;
//     }
//     final updatedList = [...state.expenses];
//     updatedList[index] = updatedExpense;

//     state = state.copyWith(
//       expenses: updatedList,
//       status: ExpenseStatus.success,
//       error: null,
//     );
//   }

//   // Filter expenses by vehicle id
//   List<Expense> getExpensesForVehicle(String vehicleId) {
//     return state.expenses.where((e) => e.vehicleId == vehicleId).toList();
//   }

//   // Get all expenses
//   List<Expense> getAllExpenses() => state.expenses;

//   // Delete expense locally
//   void deleteExpense(String id) {
//     final exists = state.expenses.any((e) => e.id == id);
//     if (!exists) {
//       state = state.copyWith(status: ExpenseStatus.error, error: 'Expense not found');
//       return;
//     }
//     state = state.copyWith(
//       expenses: state.expenses.where((e) => e.id != id).toList(),
//       status: ExpenseStatus.success,
//       error: null,
//     );
//   }

//   // Clear all expenses
//   void clearExpenses() {
//     state = state.copyWith(expenses: [], status: ExpenseStatus.success, error: null);
//   }

//   // Refresh can call fetchExpenses or simulate loading
//   Future<void> refresh() async {
//     await fetchExpenses();
//   }
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/expense/expense_state.dart';
import 'package:my_new_project/core/models/expense.dart';
import 'package:my_new_project/infrastructure/expense/expense_repositary.dart';

final expenseProvider = StateNotifierProvider<ExpenseNotifier, ExpenseState>((
  ref,
) {
  final repository = ref.watch(expenseRepositoryProvider);
  return ExpenseNotifier(repository);
});

class ExpenseNotifier extends StateNotifier<ExpenseState> {
  final ExpenseRepository _repository;

  ExpenseNotifier(this._repository) : super(ExpenseState(expenses: [])) {
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final expenses = await _repository.getExpenses();
      state = state.copyWith(expenses: expenses, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.addExpense(expense);
      await loadExpenses();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.updateExpense(expense);
      await loadExpenses();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.deleteExpense(id);
      await loadExpenses();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSelectedExpense(Expense? expense) {
    state = state.copyWith(selectedExpense: expense);
  }

  void clearSelectedExpense() {
    state = state.copyWith(clearSelected: true);
  }
}
