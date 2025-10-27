import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/brokerage.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/purchase.dart';
import 'package:my_new_project/core/models/sales.dart';

class Vehicle {
  final String id;
  final String make;
  final String model;
  final List<String> photos;
  final String price;
  final String registrationId;
  final String color;
  final String status;
  final String year;
  final String? description;

final Purchase purchaseInfo; // 👈 required field


  final List<Partnership>? partnerships;
  final SaleInfo? saleInfo;
  final double mileage; //required by backend
  final String fuelType;
  final List<Brokerage>? brokerageInfo;
   final int? toAccount; // <-- add this
     final String? accountName;

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

  required this.purchaseInfo,

    this.partnerships,
    this.saleInfo,
    required this.mileage,
    required this.fuelType,
    this.brokerageInfo, 
     this.toAccount,
     this.accountName
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

   Purchase? purchaseInfo,


    List<Partnership>? partnerships, // ✅ FIXED (was Partnership?)
    SaleInfo? saleInfo,
    double? mileage,
    String? fuelType,
   List<Brokerage>? brokerageInfo,

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

       purchaseInfo: purchaseInfo ?? this.purchaseInfo,


      partnerships: partnerships ?? this.partnerships, // ✅ now types match
      saleInfo: saleInfo ?? this.saleInfo,
      mileage: mileage ?? this.mileage,
      fuelType: fuelType ?? this.fuelType,
      brokerageInfo: brokerageInfo ?? this.brokerageInfo,

    );
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
     print("Vehicle JSON: $json");  // debug print

    const baseUrl = '$HbaseUrl'; // Your backend URL

    // Parse saleInfo first so we can print it
  SaleInfo? saleInfo;
  if (json['sale_info'] != null) {
    saleInfo = SaleInfo.fromJson(json['sale_info']);
    print('🔥 SaleInfo JSON received: ${json['sale_info']}');
    print('Sale Info object: $saleInfo');
    print('Received in account: ${saleInfo.accountId}');
    print('Address: ${saleInfo.address}');
  }
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

      purchaseInfo: json['purchase_info'] != null
    ? Purchase.fromJson({
        ...json['purchase_info'],
        'vehicle_id': json['id'].toString(),
        'user_id': json['user_id']?.toString() ?? '', // Fallback if not present
      })
    : throw Exception('Missing purchase_info'),


      // partnerships: (json['partnerships_info'] as List<dynamic>?)
      //         ?.map((e) => Partnership.fromJson(e))
      //         .toList(),

      // 🔥 CHANGED → safe partnerships handling
      partnerships: json['partnerships_info'] != null
          ? (json['partnerships_info'] as List<dynamic>)
                .map((p) => Partnership.fromJson(p))
                .toList()
          : [],

      saleInfo: json['sale_info'] != null
          ? SaleInfo.fromJson(json['sale_info'])
          : null,

      mileage: (json['mileage'] is num)
          ? (json['mileage'] as num).toDouble()
          : 0.0,
      fuelType: json['fuel_type'] ?? 'petrol',


    brokerageInfo: json['brokerage_info'] != null
    ? (json['brokerage_info'] as List<dynamic>)
        .map((e) {
          print('🔄 Parsing brokerage: $e'); // Debug print
          return Brokerage.fromJson(e);
        })
        .toList()
    : [],

       toAccount: json['to_account'],      // map backend
      accountName: json['account_name'],  // map backend

    );
  }

  Map<String, dynamic> toJson() {
  dynamic cleanNumeric(String? value) {
    if (value == null) return 0.0;
    final cleaned = value.replaceAll(',', '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  // Start with vehicle data
  final jsonMap = {
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
    'is_partnership': partnerships != null && partnerships!.isNotEmpty,
  };

  // ✅ FLATTEN purchase info to root level (like your friend's React app)
  jsonMap.addAll({
    'purchase_name': purchaseInfo.name,
    'purchase_phone': purchaseInfo.phone,
    'purchase_address': purchaseInfo.address,
    'purchase_date': purchaseInfo.date.toIso8601String(),
    'purchase_price': purchaseInfo.price.toString(),
    'purchase_paid': purchaseInfo.paidAmount.toString(), // This is important!
    'purchase_from_account': purchaseInfo.modeOfPayment, // Changed from mode_of_payment
    'purchase_payment_status': purchaseInfo.paymentStatus,
  });

  // Add partnerships if they exist
  if (partnerships != null && partnerships!.isNotEmpty) {
    jsonMap['partnerships'] = partnerships!.map((p) => p.toJson()).toList();
  }

  // Add other optional fields
  if (saleInfo != null) {
    jsonMap.addAll(saleInfo!.toJson());
  }

  if (brokerageInfo != null && brokerageInfo!.isNotEmpty) {
    jsonMap['brokerage_info'] = brokerageInfo!.map((b) => b.toJson()).toList();
  }

  // Debug print to verify the structure
  print('🚗 Vehicle.toJson() → $jsonMap');

  return jsonMap;
}
}
