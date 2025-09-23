import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';

import 'package:my_new_project/core/models/dailysummary.dart';

final dailySummaryServiceProvider = Provider<DailySummaryService>((ref) {
  final dio = Dio();
  return DailySummaryService(dio, ref);
});

class DailySummaryService {
  final Dio _dio;
  final Ref _ref;

  DailySummaryService(this._dio, this._ref);

  Future<List<DailySummary>> getDailySummaries({Map<String, dynamic>? filters}) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;

    final response = await _dio.get(
      'http://192.168.29.29:5000/api/daily-summary',
      queryParameters: filters,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final dataList = response.data['data'] as List;

    return dataList.map((json) => DailySummary.fromJson(json)).toList();
  }
}

