import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/attendance.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';

final attendanceServiceProvider = Provider<AttendanceService>((ref) {
  final dio = Dio();
  return AttendanceService(dio, ref);
});

class AttendanceService {
  final Dio _dio;
  final Ref _ref;

  AttendanceService(this._dio, this._ref);

  String get _baseUrl => 'http://192.168.29.29:5000/api/employee-attendance';

  Future<String?> get _token async =>
      _ref.read(authNotifierProvider).user?.accessToken;

  Future<List<Attendance>> getAttendances() async {
    final token = await _token;
    final response = await _dio.get(
      _baseUrl,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data as List;
    return data.map((json) => Attendance.fromJson(json)).toList();
  }

  Future<Attendance> addAttendance(Attendance attendance) async {
    final token = await _token;
    final response = await _dio.post(
      _baseUrl,
      data: attendance.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return Attendance.fromJson(response.data);
  }

  Future<Attendance> updateAttendance(Attendance attendance) async {
    if (attendance.id == null) {
      throw Exception('Attendance ID is required for update');
    }

    final token = await _token;
    final response = await _dio.put(
      '$_baseUrl/${attendance.id}',
      data: attendance.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return Attendance.fromJson(response.data);
  }

  Future<void> deleteAttendance(int id) async {
    final token = await _token;
    await _dio.delete(
      '$_baseUrl/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
