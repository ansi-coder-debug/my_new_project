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
//     required this.type
//   });
// }

class Expense {
  final String id;
  final String amount;
  final String? description;
  final String date;
  final String vehicleId;
  final String type;

  Expense({
    required this.id,
    required this.amount,
    this.description,
    required this.date,
    required this.vehicleId,
    required this.type,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'].toString(),
      amount: json['amount'].toString(),
      description: json['description'],
      date: json['date'],
      vehicleId: json['vehicle_id'].toString(),
      type: json['expense_type'], // backend uses "expense_type"
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "description": description,
      "date": date,
      "vehicle_id": vehicleId,
      "expense_type": type,
    };
  }
}
