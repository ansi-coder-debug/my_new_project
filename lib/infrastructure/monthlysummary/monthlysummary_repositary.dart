import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_new_project/core/models/monthlysummary.dart';

import 'package:my_new_project/infrastructure/monthlysummary/monthlysummary_service.dart';

final monthlySummaryRepositoryProvider = Provider<MonthlySummaryRepository>((ref) {
  final service = ref.watch(monthlySummaryServiceProvider);
  return MonthlySummaryRepository(service);
});
class MonthlySummaryRepository {
  final MonthlySummaryService _service;

  MonthlySummaryRepository(this._service);

  Future<List<MonthlySummary>> getMonthlySummaries() {
    return _service.getMonthlySummaries();
  }
}
