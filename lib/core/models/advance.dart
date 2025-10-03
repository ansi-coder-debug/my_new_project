import 'package:my_new_project/core/models/vehicle_summary.dart';

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

  // Add these two fields:
  final String? make;
  final String? model;
 final VehicleSummary? vehicle;


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
    this.make,
    this.model,
    this.vehicle
  });

 factory Advance.fromJson(Map<String, dynamic> json) {
  return Advance(
    id: json['id'],
    userId: json['user_id'],
    vehicleId: json['vehicle_id'],
    amount: json['amount'] is String
        ? double.parse(json['amount'])
        : (json['amount'] as num).toDouble(),
    date: DateTime.parse(json['date']),
    note: json['note'],
    buyerName: json['buyer_name'],
    buyerPhone: json['buyer_phone'],
    buyerAddress: json['buyer_address'],
       // Parse make and model from JSON
      make: json['make']?.toString(),
      model: json['model']?.toString(),

      // Leave vehicle as null, or parse if needed
      vehicle: null,
  );
}


  /// ✅ Use this when sending data to the backend for create/update
 Map<String, dynamic> toJson() {
  return {
    'vehicle_id': vehicleId,
    'user_id': userId, // 👈✅ This is required!
    'amount': amount,
    'date': date.toIso8601String().split('T')[0], // 👈 Format as 'YYYY-MM-DD'
    'note': note,
    'buyer_name': buyerName,
    'buyer_phone': buyerPhone,
    'buyer_address': buyerAddress,
  };
}
// Add a getter to display combined vehicle name:
  String get vehicleDisplayName {
    if (make != null && model != null) {
      return '$make $model';
    } else if (vehicle?.name != null) {
      return vehicle!.name!;
    } else {
      return 'No vehicle info';
    }
  }

}
