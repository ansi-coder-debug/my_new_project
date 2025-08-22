import 'package:hive_flutter/hive_flutter.dart';
part 'purchase.g.dart';

@HiveType(typeId: 4)
class Purchase extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String vehicleId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final String phone;

  @HiveField(5)
  final String address;

  @HiveField(6)
  final DateTime date;

  @HiveField(7)
  final double price;

  @HiveField(8)
  final String modeOfPayment;

  @HiveField(9)
  final String paymentStatus;

  Purchase({
    required this.id,
    required this.vehicleId,
    required this.userId,
    required this.name,
    required this.phone,
    required this.address,
    required this.date,
    required this.price,
    required this.modeOfPayment,
    required this.paymentStatus,
  });

  // ✅ JSON factory (to map with backend API)
  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'].toString(),
      vehicleId: json['vehicle_id'].toString(),
      userId: json['user_id'].toString(),
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      // date: DateTime.parse(json['date']),
      //temp date code 
      date:json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      modeOfPayment: json['mode_of_payment'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
    );
  }

  // ✅ Convert to JSON (for sending to backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_id': vehicleId,
      'user_id': userId,
      'name': name,
      'phone': phone,
      'address': address,
      'date': date.toIso8601String(),
      'price': price,
      'mode_of_payment': modeOfPayment,
      'payment_status': paymentStatus,
    };
  }
}
