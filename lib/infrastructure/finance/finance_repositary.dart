import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/finance.dart';
import 'package:my_new_project/infrastructure/finance/finance_service.dart';

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  final service = ref.watch(financeServiceProvider);
  return FinanceRepository(service);
});

class FinanceRepository {
  final FinanceService _service;

  FinanceRepository(this._service);

  Future<List<Finance>> getAllFinances() => _service.getAllFinances();

  Future<Finance> addFinance(Finance finance) => _service.addFinance(finance);

  Future<Finance> updateFinance(Finance finance) {
    if (finance.id.isEmpty) {
      throw Exception('Finance ID cannot be null or empty for update');
    }
    return _service.updateFinance(finance);
  }

  Future<void> deleteFinance(String id) => _service.deleteFinance(id);
}
