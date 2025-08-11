import 'package:hive_flutter/adapters.dart';
part 'partnership.g.dart';


@HiveType(typeId: 3)
class Partnership extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String partnerName;

  @HiveField(2)
  final String contactPerson;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String phone;

  @HiveField(5)
  final String sharePercentage;

  @HiveField(6)
  final String vehicleId;

  @HiveField(7)
  final String startDate;

  Partnership({
    required this.id,
    required this.partnerName,
    required this.contactPerson,
    required this.email,
    required this.phone,
    required this.sharePercentage,
    required this.vehicleId,
    required this.startDate

  });

  static fromJson(json) {}

}
