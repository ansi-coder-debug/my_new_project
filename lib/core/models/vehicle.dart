import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_new_project/core/models/partnership.dart';
part 'vehicle.g.dart';

@HiveType(typeId: 0)
class Vehicle extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final String price;
  @HiveField(4)
  final String mileage;
  @HiveField(5)
  final String color;
  @HiveField(6)
  final String vin;
  @HiveField(7)
  final String task;
  @HiveField(8)
  final String status;
  @HiveField(9)
  final String year;
  @HiveField(10)
  final String? description;
  @HiveField(11)
  final String? purchaseDate;

  @HiveField(12)
  final Partnership? partnership;

  @HiveField(13)
  final String? salesId;

  Vehicle({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.mileage,
    required this.color,
    required this.vin,
    required this.task,
    required this.status,
    required this.year,
    this.description,
    this.purchaseDate,
    this.partnership,
    this.salesId,
  });
}
