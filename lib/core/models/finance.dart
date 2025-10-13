import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/core/models/financier.dart';
import 'package:my_new_project/core/models/vehicle_summary.dart';

class Finance {
  final String id;
  final String vehicleId;
  final String toAccount;
  final String paymentStatus;
  final double amount;
  final double receivedPrice;
  final Financier? financier;
  final VehicleSummary? vehicle;

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
    try {
      print('🔍 Parsing Finance from JSON: $json');

      VehicleSummary? vehicleSummary;

      if (json['vehicle'] != null && json['vehicle'] is Map<String, dynamic>) {
        final vehicleJson = json['vehicle'] as Map<String, dynamic>;

        // Create a new map with flat keys for VehicleSummary.fromJson
        final flatVehicleJson = {
          'vehicle_name':
              '${vehicleJson['make'] ?? ''} ${vehicleJson['model'] ?? ''}'
                  .trim(),
          'vehicle_reg_no': vehicleJson['reg_no'],
        };

        vehicleSummary = VehicleSummary.fromJson(flatVehicleJson);
      }

      return Finance(
        id: json['id']?.toString() ?? '',
        vehicleId: json['vehicle_id']?.toString() ?? '',
        toAccount: json['to_account']?.toString() ?? '',
        paymentStatus: json['payment_status']?.toString() ?? '',
        amount: (json['amount'] is num)
            ? (json['amount'] as num).toDouble()
            : double.tryParse(json['amount']?.toString() ?? '') ?? 0.0,
        receivedPrice: (json['received_price'] is num)
            ? (json['received_price'] as num).toDouble()
            : double.tryParse(json['received_price']?.toString() ?? '') ?? 0.0,
        financier: json['financier_name'] != null
            ? Financier(
                id: json['financier_id'] is int
                    ? json['financier_id']
                    : int.tryParse(json['financier_id']?.toString() ?? ''),
                companyName: json['financier_name'],
                contactPerson: '',
                contactNumber: '',
                address: '',
              )
            : null,
        vehicle: vehicleSummary,
      );
    } catch (e, stack) {
      print('⚠️ Error parsing Finance JSON: $e\n$stack');
      return Finance(
        id: '',
        vehicleId: '',
        toAccount: '',
        paymentStatus: '',
        amount: 0,
        receivedPrice: 0,
        financier: null,
        vehicle: null,
      );
    }
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
    VehicleSummary? vehicle,
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
