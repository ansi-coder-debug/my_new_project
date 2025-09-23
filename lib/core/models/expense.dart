// // class Expense {
// //   final String id;
// //   final String amount;
// //   final String? description;
// //   final String date;
// //   final String vehicleId;
// //   final String type;

// //   Expense({
// //     required this.id,
// //     required this.amount,
// //     this.description,
// //     required this.date,
// //     required this.vehicleId,
// //     required this.type
// //   });
// // }

// class Expense {
//   final String id;
//   final String amount;
//   final String? description;
//   final String date;
//   final String vehicleId;
//   final String type;

//   Expense({
//     required this.id,
//     required this.amount,
//     this.description,
//     required this.date,
//     required this.vehicleId,
//     required this.type,
//   });

//   factory Expense.fromJson(Map<String, dynamic> json) {
//     return Expense(
//       id: json['id'].toString(),
//       amount: json['amount'].toString(),
//       description: json['description'],
//       date: json['date'],
//       vehicleId: json['vehicle_id'].toString(),
//       type: json['expense_type'], // backend uses "expense_type"
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "amount": amount,
//       "description": description,
//       "date": date,
//       "vehicle_id": vehicleId,
//       "expense_type": type,
//     };
//   }
// }

class Expense {
  final int? id;
  final int userId;
  final int? vehicleId;
  final int? employeeId;
  final int fromAccount;
  final double amount;
  final String? description;
  final int expenseTypeId;
  final String paymentStatus; // 'paid', 'partial', 'pending'
  final double expensePaid;
  final DateTime date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Also including some joined fields from SQL like account_name and expense_type_name if you want
  final String? accountName;
  final String? expenseTypeName;

  Expense({
    this.id,
    required this.userId,
    this.vehicleId,
    this.employeeId,
    required this.fromAccount,
    required this.amount,
    this.description,
    required this.expenseTypeId,
    required this.paymentStatus,
    required this.expensePaid,
    required this.date,
    this.createdAt,
    this.updatedAt,
    this.accountName,
    this.expenseTypeName,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  return Expense(
    id: json['id'],
    userId: json['user_id'],
    vehicleId: json['vehicle_id'],
    employeeId: json['employee_id'],
    fromAccount: json['from_account'],
    amount: _parseDouble(json['amount']),
    description: json['description'],
    expenseTypeId: json['expense_type_id'],
    paymentStatus: json['payment_status'],
    expensePaid: _parseDouble(json['expense_paid']),
    date: DateTime.parse(json['date']),
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    accountName: json['account_name'],
    expenseTypeName: json['expense_type_name'],
  );
}


  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'vehicle_id': vehicleId,
      'employee_id': employeeId,
      'from_account': fromAccount,
      'amount': amount,
      'description': description,
      'expense_type_id': expenseTypeId,
      'payment_status': paymentStatus,
      'expense_paid': expensePaid,
      'date': date.toIso8601String(),
      // usually createdAt and updatedAt are not sent in create/update requests
    };
  }
}

