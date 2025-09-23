import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/expensetype.dart';
import 'package:my_new_project/infrastructure/expensetype/expensetype_service.dart';

final expenseTypeRepositoryProvider = Provider<ExpenseTypeRepository>((ref) {
  final service = ref.watch(expenseTypeServiceProvider);
  return ExpenseTypeRepository(service);
});

class ExpenseTypeRepository {
  final ExpenseTypeService _service;

  ExpenseTypeRepository(this._service);

  Future<List<ExpenseType>> getExpenseTypes() => _service.getExpenseTypes();

  Future<ExpenseType> addExpenseType(ExpenseType expenseType) => _service.addExpenseType(expenseType);

  Future<ExpenseType> updateExpenseType(ExpenseType expenseType) {
    if (expenseType.id == null) {
      throw Exception('ExpenseType ID cannot be null for update');
    }
    return _service.updateExpenseType(expenseType);
  }

  Future<void> deleteExpenseType(int id) => _service.deleteExpenseType(id);
}
