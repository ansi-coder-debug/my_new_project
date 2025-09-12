import 'package:my_new_project/core/models/brokerage.dart';
import 'package:my_new_project/core/models/partnership.dart';
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
  final String? purchaseDate;
  final String purchaseName;
  final String purchasePhone;
  final String purchaseAddress;
  final String purchasePrice;
  final String purchaseMode;
  final String? purchasePaymentStatus;
  final List<Partnership>? partnerships;
  final SaleInfo? saleInfo;
  final double mileage; //required by backend
  final String fuelType;
  final List<Brokerage>? brokerageInfo;

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
    required this.purchaseDate,
    required this.purchaseName,
    required this.purchasePhone,
    required this.purchaseAddress,
    required this.purchasePrice,
    required this.purchaseMode,
    required this.purchasePaymentStatus,
    this.partnerships,
    this.saleInfo,
    required this.mileage,
    required this.fuelType,
    this.brokerageInfo,
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
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchaseName: purchaseName ?? this.purchaseName,
      purchasePhone: purchasePhone ?? this.purchasePhone,
      purchaseAddress: purchaseAddress ?? this.purchaseAddress,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchaseMode: purchaseMode ?? this.purchaseMode,
      purchasePaymentStatus:
          purchasePaymentStatus ?? this.purchasePaymentStatus,
      partnerships: partnerships ?? this.partnerships, // ✅ now types match
      saleInfo: saleInfo ?? this.saleInfo,
      mileage: mileage ?? this.mileage,
      fuelType: fuelType ?? this.fuelType,
      brokerageInfo: brokerageInfo ?? this.brokerageInfo,

    );
  }

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
      purchasePaymentStatus:
          json['purchase_info']?['payment_status'] ?? 'pending',

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
        .map((e) => Brokerage.fromJson(e))
        .toList()
    : [],

    );
  }

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

      // 'partnerships': partnerships?.map((p) => p.toJson()).toList(),

      // 🔥 CHANGED → only include if non-empty
      'partnerships_info': partnerships!.map((p) => p.toJson()).toList(),

      'purchase_name': purchaseName ?? '',
      'purchase_phone': purchasePhone ?? '',
      'purchase_address': purchaseAddress ?? '',
      'purchase_date': cleanDate(purchaseDate),
      'purchase_price': cleanNumeric(purchasePrice),
      'purchase_mode_of_payment': purchaseMode ?? '',
      'purchase_payment_status': purchasePaymentStatus ?? 'pending',

      if (saleInfo != null) 'sale_info': saleInfo!.toJson(),

      if (brokerageInfo != null && brokerageInfo!.isNotEmpty)
    'brokerage_info': brokerageInfo!.map((b) => b.toJson()).toList(),


    };
  }
}
