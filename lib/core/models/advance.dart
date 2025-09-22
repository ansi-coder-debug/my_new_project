class Advance {
  final int? id;         // Nullable - backend sets it
  final int? userId;     // Nullable - backend sets it
  final int ?vehicleId;
  final double amount;
  final DateTime date;
  final String? note;
  final String buyerName;
  final String? buyerPhone;
  final String? buyerAddress;

  Advance({
    this.id,               // Optional
    this.userId,           // Optional
     this.vehicleId,
    required this.amount,
    required this.date,
    this.note,
    required this.buyerName,
    this.buyerPhone,
    this.buyerAddress,
  });

  factory Advance.fromJson(Map<String, dynamic> json) {
    return Advance(
      id: json['id'],
      userId: json['user_id'],
      vehicleId: json['vehicle_id'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      note: json['note'],
      buyerName: json['buyer_name'],
      buyerPhone: json['buyer_phone'],
      buyerAddress: json['buyer_address'],
    );
  }

  /// ✅ Use this when sending data to the backend for create/update
  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
      'buyer_name': buyerName,
      'buyer_phone': buyerPhone,
      'buyer_address': buyerAddress,
    };
  }
}
