import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_new_project/core/models/dailysummary.dart';

import 'package:my_new_project/infrastructure/dailysummary/dailysummary_service.dart';

final dailySummaryRepositoryProvider = Provider<DailySummaryRepository>((ref) {
  final service = ref.watch(dailySummaryServiceProvider);
  return DailySummaryRepository(service);
});

class DailySummaryRepository {
  final DailySummaryService _service;

  DailySummaryRepository(this._service);

  Future<List<DailySummary>> getDailySummaries({Map<String, dynamic>? filters}) {
    return _service.getDailySummaries(filters: filters);
  }
}
