



class Expense {
  final String id;
  final String amount;
  final String? description;
  final String date;
  final String vehicleId;

  Expense({
    required this.id,
    required this.amount,
    this.description,
    required this.date,
    required this.vehicleId,
  });
}
 