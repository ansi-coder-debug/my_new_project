import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/advance.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';

final advanceServiceProvider = Provider<AdvanceService>((ref) {
  final dio = Dio();
  return AdvanceService(dio, ref);
});

class AdvanceService {
  final Dio _dio;
  final Ref _ref;

  AdvanceService(this._dio, this._ref);

  Future<List<Advance>> getAdvances() async {
    
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.get(
      '$HbaseUrl/advances',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data as List;
    return data.map((json) => Advance.fromJson(json)).toList();
  }

  Future<Advance> addAdvance(Advance advance) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    final response = await _dio.post(
      '$HbaseUrl/advances',
      data: advance.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return Advance.fromJson(response.data);
  }

  Future<Advance> updateAdvance(Advance advance) async {
    if (advance.id == null) throw Exception('Advance ID is required for update');

    final token = _ref.read(authNotifierProvider).user?.accessToken;
    
    final response = await _dio.put(
      
      '$HbaseUrl/advances/${advance.id}',
      data: advance.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return Advance.fromJson(response.data);
  }

  Future<void> deleteAdvance(int id) async {
    final token = _ref.read(authNotifierProvider).user?.accessToken;
    await _dio.delete(
      '$HbaseUrl/advances/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}

