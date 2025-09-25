import 'package:my_new_project/core/models/attendance.dart';

class AttendanceState {
  final List<Attendance> attendances;
  final bool isLoading;
  final String? error;
  final Attendance? selectedAttendance;

  AttendanceState({
    required this.attendances,
    this.isLoading = false,
    this.error,
    this.selectedAttendance,
  });

  AttendanceState copyWith({
    List<Attendance>? attendances,
    bool? isLoading,
    String? error,
    Attendance? selectedAttendance,
    bool clearSelected = false,
  }) {
    return AttendanceState(
      attendances: attendances ?? this.attendances,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedAttendance: clearSelected ? null : (selectedAttendance ?? this.selectedAttendance),
    );
  }
}
