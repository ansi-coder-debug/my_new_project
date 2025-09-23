
import 'package:my_new_project/core/models/expensetype.dart';

class ExpenseTypeState {
  final List<ExpenseType> expenseTypes;
  final bool isLoading;
  final String? error;
  final ExpenseType? selectedExpenseType;

  ExpenseTypeState({
    required this.expenseTypes,
    this.isLoading = false,
    this.error,
    this.selectedExpenseType,
  });

  ExpenseTypeState copyWith({
    List<ExpenseType>? expenseTypes,
    bool? isLoading,
    String? error,
    ExpenseType? selectedExpenseType,
    bool clearSelected = false,
  }) {
    return ExpenseTypeState(
      expenseTypes: expenseTypes ?? this.expenseTypes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedExpenseType: clearSelected ? null : (selectedExpenseType ?? this.selectedExpenseType),
    );
  }
}
