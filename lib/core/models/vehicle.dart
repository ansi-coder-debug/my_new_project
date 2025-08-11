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
  final String registrationId;
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
    required this.registrationId,
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
  Vehicle copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? price,
    String? mileage,
    String? color,
    String? vin,
    String? task,
    String? status,
    String? year,
    String? description,
    String? purchaseDate,
    Partnership? partnership,
    String? salesId,
  }) {
    return Vehicle(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      registrationId: registrationId ?? this.registrationId,
      color: color ?? this.color,
      vin: vin ?? this.vin,
      task: task ?? this.task,
      status: status ?? this.status,
      year: year ?? this.year,
      description: description ?? this.description,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      partnership: partnership ?? this.partnership,
      salesId: salesId ?? this.salesId,
    );
  }
  factory Vehicle.fromJson(Map<String, dynamic> json) {
  return Vehicle(
    id: json['id'].toString(),
    title: '${json['make']} ${json['model']}', // Combine make + model
    imageUrl:  json['photo'] ?? '', // Use 'photo' field
    price: json['expected_price']?.toString() ?? '0', // Map to expected_price
    registrationId: json['res_no'] ?? '', // Map to res_no
    color:  json['color'] ?? '',
    vin: json['vin'] ?? '', // Add if backend has VIN
       task: json['task'] ?? 'No task', // Default value
    status: json['status'] ?? 'available',
    year: json['year'].toString(), // Convert int to String
    description: json['description'],
    purchaseDate: json['purchaseDate'].toString(),
    // Handle nested partnership if needed
    partnership: json['partnership'] != null 
        ? Partnership.fromJson(json['partnership']) 
        : null,
    salesId: json['salesId'],
  );
}
}
