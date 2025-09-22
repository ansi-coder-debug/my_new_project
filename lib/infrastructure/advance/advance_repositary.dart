import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/advance.dart';
import 'package:my_new_project/infrastructure/advance/advance_service.dart';

final advanceRepositoryProvider = Provider<AdvanceRepository>((ref) {
  final service = ref.watch(advanceServiceProvider);
  return AdvanceRepository(service);
});

class AdvanceRepository {
  final AdvanceService _service;

  AdvanceRepository(this._service);

  Future<List<Advance>> getAdvances() => _service.getAdvances();

  Future<Advance> addAdvance(Advance advance) => _service.addAdvance(advance);

  Future<Advance> updateAdvance(Advance advance) => _service.updateAdvance(advance);

  Future<void> deleteAdvance(int id) => _service.deleteAdvance(id);
}
