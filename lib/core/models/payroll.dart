class Payroll {
  final int? id;
  final int? userId;
  final int employeeId;
  final double salary;
  final DateTime payDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? employeeName;

  // ✅ One constructor only
  Payroll({
    this.id,
    this.userId,
    required this.employeeId,
    required this.salary,
    required this.payDate,
    this.createdAt,
    this.updatedAt,
    this.employeeName,
  });

  // ✅ Parse backend response
 factory Payroll.fromJson(Map<String, dynamic> json) {
  return Payroll(
    id: json['id'],
    userId: json['user_id'],
    employeeId: json['employee_id'],
    salary: double.parse(json['salary'].toString()), // <-- Parse string to double safely
    payDate: DateTime.parse(json['pay_date']),
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    employeeName: json['employee_name'],
  );
}


  // ✅ Only include required fields for POST
  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'salary': salary,
      'pay_date': payDate.toIso8601String(),
    };
  }
}
