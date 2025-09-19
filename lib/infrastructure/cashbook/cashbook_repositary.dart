import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/cashbook.dart';
import 'package:my_new_project/infrastructure/cashbook/cashbook_service.dart';

final cashBookRepositoryProvider = Provider<CashBookRepository>((ref) {
  final service = ref.watch(cashBookServiceProvider);
  return CashBookRepository(service);
});

class CashBookRepository {
  final CashBookService _service;

  CashBookRepository(this._service);

  Future<List<CashBookEntry>> getAll() => _service.getAll();

  Future<CashBookEntry> create(CashBookEntry entry) => _service.create(entry);

  Future<CashBookEntry> update(CashBookEntry entry) => _service.update(entry);

  Future<void> delete(String id) => _service.delete(id);
}
