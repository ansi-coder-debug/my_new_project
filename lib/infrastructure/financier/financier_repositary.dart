// lib/infrastructure/financiers/financier_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/financier.dart';
import 'package:my_new_project/infrastructure/financier/financier_service.dart';


final financierRepositoryProvider = Provider<FinancierRepository>((ref) {
  final service = ref.watch(financierServiceProvider);
  return FinancierRepository(service);
});

class FinancierRepository {
  final FinancierService _service;

  FinancierRepository(this._service);

  Future<List<Financier>> getFinanciers() => _service.getFinanciers();

  Future<Financier> addFinancier(Financier financier) => _service.addFinancier(financier);

  Future<Financier> updateFinancier(Financier financier) {
    if (financier.id == null) {
      throw Exception('Financier ID cannot be null for update');
    }
    return _service.updateFinancier(financier);
  }

  Future<void> deleteFinancier(int id) => _service.deleteFinancier(id);
}
