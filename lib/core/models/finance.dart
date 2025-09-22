import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/core/models/financier.dart';

class Finance {
  final String id;
  final String vehicleId;
  final String toAccount;
  final String paymentStatus;
  final double amount;
  final double receivedPrice;
  final Financier? financier;
  final Vehicle? vehicle;

  Finance({
    required this.id,
    required this.vehicleId,
    required this.toAccount,
    required this.paymentStatus,
    required this.amount,
    required this.receivedPrice,
    this.financier,
    this.vehicle,
  });

  factory Finance.fromJson(Map<String, dynamic> json) {
    return Finance(
      id: json['id'].toString(),
      vehicleId: json['vehicle_id'].toString(),
      toAccount: json['to_account'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      receivedPrice: (json['received_price'] ?? 0).toDouble(),

      // Assuming backend returns `financier` or `financier_id` + related fields
      financier: json['financier'] != null
          ? Financier.fromJson(json['financier'])
          : json['financier_id'] != null
              ? Financier(id: json['financier_id'], companyName: '', contactPerson: '', contactNumber: '', address: '')
              : null,

      // Assuming backend returns partial vehicle details in `vehicle`
      vehicle: json['vehicle'] != null
          ? Vehicle.fromJson(json['vehicle'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'to_account': toAccount,
      'payment_status': paymentStatus,
      'amount': amount,
      'received_price': receivedPrice,
      'financier_id': financier?.id,
    };
  }

  Finance copyWith({
    String? id,
    String? vehicleId,
    String? toAccount,
    String? paymentStatus,
    double? amount,
    double? receivedPrice,
    Financier? financier,
    Vehicle? vehicle,
  }) {
    return Finance(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      toAccount: toAccount ?? this.toAccount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      amount: amount ?? this.amount,
      receivedPrice: receivedPrice ?? this.receivedPrice,
      financier: financier ?? this.financier,
      vehicle: vehicle ?? this.vehicle,
    );
  }
}
