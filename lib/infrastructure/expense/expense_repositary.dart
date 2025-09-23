// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_new_project/core/models/expense.dart';
// import 'package:my_new_project/infrastructure/expense/expense_service.dart';

// final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
//   final service = ref.watch(expenseServiceProvider);
//   return ExpenseRepository(service);
// });

// class ExpenseRepository {
//   final ExpenseService _expenseService;

//   ExpenseRepository(this._expenseService);

//   Future<List<Expense>> getExpenses() async {
//     return await _expenseService.getExpenses();
//   }

//   Future<void> addExpense(Expense expense) async {
//     await _expenseService.addExpense(expense);
//   }

//   Future<void> deleteExpense(String id) async {
//     await _expenseService.deleteExpense(id);
//   }
// }


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/expense.dart';
import 'package:my_new_project/infrastructure/expense/expense_service.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final service = ref.watch(expenseServiceProvider);
  return ExpenseRepository(service);
});

class ExpenseRepository {
  final ExpenseService _service;

  ExpenseRepository(this._service);

  Future<List<Expense>> getExpenses() => _service.getExpenses();

  Future<Expense> addExpense(Expense expense) => _service.addExpense(expense);

  Future<Expense> updateExpense(Expense expense) {
    if (expense.id == null) {
      throw Exception('Expense ID cannot be null for update');
    }
    return _service.updateExpense(expense);
  }

  Future<void> deleteExpense(int id) => _service.deleteExpense(id);
}
