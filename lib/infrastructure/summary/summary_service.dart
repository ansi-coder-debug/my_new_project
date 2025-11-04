import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/summary.dart';

final summaryServiceProvider = Provider<SummaryService>((ref) {
  final dio = Dio();
  return SummaryService(dio, ref);
});

class SummaryService {
  final Dio _dio;
  final Ref _ref;

  SummaryService(this._dio, this._ref);

  Future<Summary> fetchSummary() async {
    try {
      final authState = _ref.read(authNotifierProvider);
      final token = authState.user?.accessToken;

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.get(
        '$HbaseUrl/summary',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return Summary.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch summary: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
