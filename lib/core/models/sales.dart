import 'package:hive_flutter/adapters.dart';
part 'sales.g.dart';

@HiveType(typeId: 5)
class Sales extends HiveObject {
  @HiveField(0)
  final String id; // ✅ Unique ID for each sale

  @HiveField(1)
  final String vehicleId;

  @HiveField(2)
  final String buyerName;

  @HiveField(3)
  final String buyerPhone;

  @HiveField(4) 
  final String buyerAddress;

  @HiveField(5)
  final String modeOfPayment;

  @HiveField(6)
  final String date;

  Sales({
    required this.id,
    required this.vehicleId,
    required this.buyerName,
    required this.buyerPhone,
    required this.buyerAddress,
    required this.modeOfPayment,
    required this.date,
  });
}
