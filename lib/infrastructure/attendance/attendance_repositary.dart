import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/attendance.dart';
import 'package:my_new_project/infrastructure/attendance/attendance_service.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final service = ref.watch(attendanceServiceProvider);
  return AttendanceRepository(service);
});

class AttendanceRepository {
  final AttendanceService _service;

  AttendanceRepository(this._service);

  Future<List<Attendance>> getAttendances() => _service.getAttendances();

  Future<Attendance> addAttendance(Attendance attendance) =>
      _service.addAttendance(attendance);

  Future<Attendance> updateAttendance(Attendance attendance) {
    if (attendance.id == null) {
      throw Exception('Attendance ID cannot be null for update');
    }
    return _service.updateAttendance(attendance);
  }

  Future<void> deleteAttendance(int id) =>
      _service.deleteAttendance(id);
}
