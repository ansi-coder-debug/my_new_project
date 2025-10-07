import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/monthlysummary.dart';

final monthlySummaryServiceProvider = Provider<MonthlySummaryService>((ref) {
  final dio = Dio();
  return MonthlySummaryService(dio, ref);
});

class MonthlySummaryService {
  final Dio _dio;
  final Ref _ref;
  
  MonthlySummaryService(this._dio, this._ref);
Future<List<MonthlySummary>> getMonthlySummaries() async {
  final token = _ref.read(authNotifierProvider).user?.accessToken;

  final response = await _dio.get(
    '$HbaseUrl/monthly-summary',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );

  final dataList = response.data['data'] as List;

  return dataList.map((json) => MonthlySummary.fromJson(json)).toList();
}

}
