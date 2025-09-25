class Attendance {
  final int? id;
  final int? userId;
  final int employeeId;
  final String attendanceStatus;
  final DateTime attendanceDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? employeeName;

  Attendance({
    this.id,
    this.userId,
    required this.employeeId,
    required this.attendanceStatus,
    required this.attendanceDate,
    this.createdAt,
    this.updatedAt,
    this.employeeName,
  });

  /// ✅ Factory to parse from backend JSON
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      userId: json['user_id'],
      employeeId: json['employee_id'],
      attendanceStatus: json['attendance_status'],
      attendanceDate: DateTime.parse(json['attendance_date']),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      employeeName: json['employee_name'],
    );
  }

  /// ✅ Converts only needed fields to JSON (for POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'attendance_date': attendanceDate.toIso8601String(),
      'attendance_status': attendanceStatus,
    };
  }
}
