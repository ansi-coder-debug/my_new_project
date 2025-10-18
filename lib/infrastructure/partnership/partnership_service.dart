import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';

final partnershipServiceProvider = Provider<PartnershipService>((ref) {
  final dio = Dio();
  return PartnershipService(dio, ref);
});

class PartnershipService {
  final Dio _dio;
  final Ref _ref;

  PartnershipService(this._dio, this._ref);

  Future<List<Partnership>> getAllPartnerships() async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.get(
      '$HbaseUrl/partnerships',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data as List;
    return data.map((json) => Partnership.fromJson(json)).toList();
  }

  Future<Partnership> addPartnership(Partnership partnership) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.post(
      '$HbaseUrl/partnerships',
      data: partnership.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return Partnership.fromJson(response.data);
  }

  Future<Partnership> updatePartnership(Partnership partnership) async {
    if (partnership.id == null || partnership.id!.isEmpty) {
      throw Exception('Partnership ID is required for update');
    }
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.put(
      '$HbaseUrl/partnerships/${partnership.id}',
      data: partnership.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return Partnership.fromJson(response.data);
  }

  Future<void> deletePartnership(String id) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    await _dio.delete(
      '$HbaseUrl/partnerships/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
