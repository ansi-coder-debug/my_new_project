import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_new_project/core/models/partnership.dart';
part 'vehicle.g.dart';

@HiveType(typeId: 0)
class Vehicle extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String make;

  @HiveField(2)
  final String model;

  @HiveField(3)
  final List<String> photos;

  @HiveField(4)
  final String price;

  @HiveField(5)
  final String registrationId;

  @HiveField(6)
  final String color;

  @HiveField(7)
  final String status;

  @HiveField(8)
  final String year;

  @HiveField(9)
  final String? description;

  @HiveField(10)
  final String? purchaseDate;

  @HiveField(11)
  final String purchaseName;

  @HiveField(12)
  final String purchasePhone;

  @HiveField(13)
  final String purchaseAddress;

  @HiveField(14)
  final String purchasePrice;

  @HiveField(15)
  final String purchaseMode;

  @HiveField(16)
  final String? purchasePaymentStatus;

  @HiveField(17)
  final List <Partnership>? partnerships;

  @HiveField(18)
  final String? salesId;

  @HiveField(19)
  final double mileage; //required by backend

  @HiveField(20)
  final String fuelType;

  Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.photos,
    required this.price,
    required this.registrationId,
    required this.color,
    required this.status,
    required this.year,
    this.description,
    required  this.purchaseDate,
    required  this.purchaseName,
    required  this.purchasePhone,
    required  this.purchaseAddress,
    required  this.purchasePrice,
    required  this.purchaseMode,
    required  this.purchasePaymentStatus,
    this.partnerships,
    this.salesId,
    required this.mileage,
    required this.fuelType,
  });
  Vehicle copyWith({
    String? id,
    String? make,
    String? model,
    List<String>? photos,
    String? price,
    String? registrationId,
    String? color,
    String? status,
    String? year,
    String? description,
    String? purchaseDate,
    String? purchaseName,
    String? purchasePhone,
    String? purchaseAddress,
    String? purchasePrice,
    String? purchaseMode,
    String? purchasePaymentStatus,
    Partnership? partnership,
    String? salesId,
    double? mileage,
    String? fuelType,
  }) {
    return Vehicle(
      id: id ?? this.id,
      make: make ?? this.make,
      model: model ?? this.model,
      photos: photos ?? this.photos,
      price: price ?? this.price,
      registrationId: registrationId ?? this.registrationId,
      color: color ?? this.color,
      status: status ?? this.status,
      year: year ?? this.year,
      description: description ?? this.description,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchaseName: purchaseName ?? this.purchaseName,
      purchasePhone: purchasePhone ?? this.purchasePhone,
      purchaseAddress: purchaseAddress ?? this.purchaseAddress,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchaseMode: purchaseMode ?? this.purchaseMode,
      purchasePaymentStatus:
          purchasePaymentStatus ?? this.purchasePaymentStatus,
      partnerships: partnerships ?? this.partnerships,
      salesId: salesId ?? this.salesId,
      mileage: mileage ?? this.mileage,
      fuelType: fuelType ?? this.fuelType,
    );
  }

//  factory Vehicle.fromJson(Map<String, dynamic> json) {
//     const baseUrl = 'http://192.168.29.29:5000'; // Your backend URL
//   return Vehicle(
//     id: json['id'].toString(),
//     make: json['make'] ?? '',
//     model: json['model'] ?? '',
//     photos: (json['photos'] is List)
//         ? (json['photos'] as List).map((e) {
//             if (e.toString().startsWith('http')) {
//               return e.toString();
//             } else {
//               return '$baseUrl/${e.toString()}';
//             }
//           }).toList()
//         : [],
//     price: json['expected_price']?.toString() ?? '0',
//     registrationId: json['reg_no'] ?? '',
//     color: json['color'] ?? '',
//     status: (json['status'] ?? 'available').toLowerCase(),
//     year: json['year'].toString(),
//     description: json['notes'],

//      purchaseDate: json['purchase_info']?['date']?.toString(),
//     purchaseName: json['purchase_info']?['name'] ?? '',
//     purchasePhone: json['purchase_info']?['phone'] ?? '',
//     purchaseAddress: json['purchase_info']?['address'] ?? '',
//     purchasePrice: json['purchase_info']?['price']??'',
//     purchaseMode: json['purchase_info']?['mode_of_payment'],
//     purchasePaymentStatus: json['purchase_info']?['payment_status'],

//     // Keep existing partnership handling
//     partnership: json['partnerships'] != null &&
//         json['partnerships'] is List &&
//         (json['partnerships'] as List).isNotEmpty
//         ? Partnership.fromJson((json['partnerships'] as List).first)
//         : null,

//     // Keep existing sale_info handling
//     salesId: json['sale_info']?['id']?.toString(),
//     mileage: json['mileage']?.toDouble() ?? 0.0,
//     fuelType: json['fuel_type'] ?? 'petrol',
//   );
// }
factory Vehicle.fromJson(Map<String, dynamic> json) {
  const baseUrl = 'http://192.168.29.29:5000'; // Your backend URL
  return Vehicle(
    id: (json['id'] ?? json['_id'] ?? '').toString(),
    make: json['make'] ?? '',
    model: json['model'] ?? '',
    photos: (json['photos'] is List)
        ? (json['photos'] as List).map((e) {
            if (e.toString().startsWith('http')) {
              return e.toString();
            } else {
              return '$baseUrl/${e.toString()}';
            }
          }).toList()
        : [],
    price: json['expected_price']?.toString() ?? '0',
    registrationId: json['reg_no'] ?? '',
    color: json['color'] ?? '',
    status: (json['status'] ?? 'available').toLowerCase(),
    year: (json['year'] ?? '').toString(),
    description: json['notes'],

    // ✅ Purchase info safely handled
    purchaseDate: json['purchase_info']?['date']?.toString() ?? '',
    purchaseName: json['purchase_info']?['name'] ?? '',
    purchasePhone: json['purchase_info']?['phone'] ?? '',
    purchaseAddress: json['purchase_info']?['address'] ?? '',
    purchasePrice: json['purchase_info']?['price']?.toString() ?? '0',
    purchaseMode: json['purchase_info']?['mode_of_payment'] ?? '',
    purchasePaymentStatus: json['purchase_info']?['payment_status'] ?? 'pending',

    // ✅ Partnership handling stays the same
   partnerships: json['partnerships'] != null && json['partnerships'] is List
    ? (json['partnerships'] as List)
        .map((e) => Partnership.fromJson(e))
        .toList()
    : [],


    salesId: json['sale_info']?['id']?.toString(),
    mileage: (json['mileage'] is num)
        ? (json['mileage'] as num).toDouble()
        : 0.0,
    fuelType: json['fuel_type'] ?? 'petrol',
  );
}


  /// ✅ toJson for POST/PUT
  // Map<String, dynamic> toJson() {
    
  //   // Helper function to clean numeric strings
  //   dynamic cleanNumeric(String? value) {
  //     if (value == null) return 0.0;
  //      final cleaned = value.replaceAll(',', '');
  //     return double.tryParse(cleaned) ?? 0.0;
  //   }

  //   // Handle date conversion
  // String? cleanDate(String? date) {
  //   if (date == null || date.isEmpty) return null;
  //   return date;
  // }

  //   return {
  //     // Core vehicle fields
  //   'make': make,
  //   'model': model,
  //   'year': int.tryParse(year) ?? 0,
  //   'reg_no': registrationId,
  //   'color': color,
  //   'mileage': mileage,
  //   'expected_price': cleanNumeric(price),
  //   'status': status,
  //   'notes': description ?? '',
  //   'fuel_type': fuelType.toLowerCase(),
  //   'photos': photos,
  //   'is_partnership': partnerships != null,

  //    // Flattened purchase fields
  //   'purchase_name': purchaseName ?? '',
  //   'purchase_phone': purchasePhone ?? '',
  //   'purchase_address': purchaseAddress ?? '',
  //    'purchase_date': cleanDate(purchaseDate), // Handle empty dates
  //   'purchase_price': cleanNumeric(purchasePrice),
  //   'purchase_mode_of_payment': purchaseMode ?? '',
  //   'purchase_payment_status': purchasePaymentStatus ?? 'pending',

  //   // Partnership data if exists
  //   // if (partnership != null) ...{
  //   //   'partnerships': [partnership!.toJson()]
  //   // }
     
  //    if (partnerships != null && partnerships!.isNotEmpty)
  // 'partnerships': partnerships!.map((p) => p.toJson()).toList(),



  //   };
  // }


  Map<String, dynamic> toJson() {
  dynamic cleanNumeric(String? value) {
    if (value == null) return 0.0;
    final cleaned = value.replaceAll(',', '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  String? cleanDate(String? date) {
    if (date == null || date.isEmpty) return null;
    return date;
  }

  return {
    'make': make,
    'model': model,
    'year': int.tryParse(year) ?? 0,
    'reg_no': registrationId,
    'color': color,
    'mileage': mileage,
    'expected_price': cleanNumeric(price),
    'status': status,
    'notes': description ?? '',
    'fuel_type': fuelType.toLowerCase(),
    'photos': photos,
    'is_partnership': partnerships != null,

    'purchase_name': purchaseName ?? '',
    'purchase_phone': purchasePhone ?? '',
    'purchase_address': purchaseAddress ?? '',
    'purchase_date': cleanDate(purchaseDate),
    'purchase_price': cleanNumeric(purchasePrice),
    'purchase_mode_of_payment': purchaseMode ?? '',
    'purchase_payment_status': purchasePaymentStatus ?? 'pending',

    if (partnerships != null && partnerships!.isNotEmpty)
      'partnerships': partnerships!.map((p) => p.toJson()).toList(),
  };
}


  
}
