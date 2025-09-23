import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/expensetype/expensetype_state.dart';
import 'package:my_new_project/core/models/expensetype.dart';
import 'package:my_new_project/infrastructure/expensetype/expensetype_repositary.dart';

final expenseTypeProvider = StateNotifierProvider<ExpenseTypeNotifier, ExpenseTypeState>((ref) {
  final repository = ref.watch(expenseTypeRepositoryProvider);
  return ExpenseTypeNotifier(repository);
});

class ExpenseTypeNotifier extends StateNotifier<ExpenseTypeState> {
  final ExpenseTypeRepository _repository;

  ExpenseTypeNotifier(this._repository) : super(ExpenseTypeState(expenseTypes: [])) {
    loadExpenseTypes();
  }

  Future<void> loadExpenseTypes() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final expenseTypes = await _repository.getExpenseTypes();
      state = state.copyWith(expenseTypes: expenseTypes, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addExpenseType(ExpenseType expenseType) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.addExpenseType(expenseType);
      await loadExpenseTypes();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateExpenseType(ExpenseType expenseType) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.updateExpenseType(expenseType);
      await loadExpenseTypes();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteExpenseType(int id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.deleteExpenseType(id);
      await loadExpenseTypes();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSelectedExpenseType(ExpenseType? expenseType) {
    state = state.copyWith(selectedExpenseType: expenseType);
  }

  void clearSelectedExpenseType() {
    state = state.copyWith(clearSelected: true);
  }
}
