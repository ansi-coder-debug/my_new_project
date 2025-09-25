import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/attendance/attendance_state.dart';
import 'package:my_new_project/core/models/attendance.dart';
import 'package:my_new_project/infrastructure/attendance/attendance_repositary.dart';


final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
  final repository = ref.watch(attendanceRepositoryProvider);
  return AttendanceNotifier(repository);
});

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  final AttendanceRepository _repository;

  AttendanceNotifier(this._repository)
      : super(AttendanceState(attendances: [])) {
    loadAttendances();
  }

  Future<void> loadAttendances() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final attendances = await _repository.getAttendances();
      state = state.copyWith(attendances: attendances, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addAttendance(Attendance attendance) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.addAttendance(attendance);
      await loadAttendances();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateAttendance(Attendance attendance) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.updateAttendance(attendance);
      await loadAttendances();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteAttendance(int id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.deleteAttendance(id);
      await loadAttendances();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSelectedAttendance(Attendance? attendance) {
    state = state.copyWith(selectedAttendance: attendance);
  }

  void clearSelectedAttendance() {
    state = state.copyWith(clearSelected: true);
  }
}
