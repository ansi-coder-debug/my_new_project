import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/summary.dart';
import 'package:my_new_project/infrastructure/summary/summary_service.dart';

final summaryRepositoryProvider = Provider<SummaryRepository>((ref) {
  final service = ref.watch(summaryServiceProvider);
  return SummaryRepository(service);
});

class SummaryRepository {
  final SummaryService _service;

  SummaryRepository(this._service);

  Future<Summary> fetchSummary() => _service.fetchSummary();
}
