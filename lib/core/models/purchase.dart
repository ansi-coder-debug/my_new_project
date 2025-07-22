import 'package:hive_flutter/hive_flutter.dart';
part 'purchase.g.dart';


@HiveType(typeId: 4)
class Purchase extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String vehicleId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String address;

  @HiveField(5)
  final String date;

  @HiveField(6)
  final String price;

  @HiveField(7)
  final String modeOfPayment;

  Purchase({
    required this.id,
    required this.vehicleId,
    required this.name,
    required this.phone,
    required this.address,
    required this.date,
    required this.price,
    required this.modeOfPayment,
  });
}
