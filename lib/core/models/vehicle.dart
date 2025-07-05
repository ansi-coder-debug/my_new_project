import 'package:hive_flutter/hive_flutter.dart';
part 'vehicle.g.dart';


@HiveType(typeId: 0)
class Vehicle  extends HiveObject{
  @HiveField(0) final String title;
  @HiveField(1) final String imageUrl; 
  @HiveField(2) final String price;
  @HiveField(3) final String mileage;
  @HiveField(4) final String color;
  @HiveField(5) final String vin;
  @HiveField(6) final String task;
  @HiveField(7) final String status;
  @HiveField(8) final String year;

  Vehicle({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.mileage,
    required this.color,
    required this.vin,
    required this.task,
    required this.status,
    required this.year
    

  });
}
