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
  final int? accountId;
  final String? accountName;

  Finance({
    required this.id,
    required this.vehicleId,
    required this.toAccount,
    required this.paymentStatus,
    required this.amount,
    required this.receivedPrice,
    this.financier,
    this.vehicle,
    this.accountId,
    this.accountName,
  });

  factory Finance.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parsing Finance from JSON: $json');

      VehicleSummary? vehicleSummary;

      if (json['vehicle'] != null && json['vehicle'] is Map<String, dynamic>) {
        final vehicleJson = json['vehicle'] as Map<String, dynamic>;
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
        toAccount: (json['finance_to_account'] ??
                json['to_account'] ??
                json['account_id'] ??
                '')
            .toString(),
        paymentStatus: (json['finance_payment_status'] ??
                json['payment_status'] ??
                '')
            .toString(),
        amount: (json['finance_amount'] ??
                    json['amount'] ??
                    0)
                is num
            ? (json['finance_amount'] ?? json['amount']).toDouble()
            : double.tryParse(
                    (json['finance_amount'] ?? json['amount'] ?? '0')
                        .toString()) ??
                0.0,
        receivedPrice: (json['finance_received_price'] ??
                    json['received_price'] ??
                    0)
                is num
            ? (json['finance_received_price'] ?? json['received_price'])
                .toDouble()
            : double.tryParse(
                    (json['finance_received_price'] ??
                            json['received_price'] ??
                            '0')
                        .toString()) ??
                0.0,
        accountId: json['account_id'] is int
            ? json['account_id']
            : int.tryParse(json['account_id']?.toString() ?? ''),
        accountName: json['account_name'] ?? '',
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
      'finance_to_account': toAccount,
      'finance_payment_status': paymentStatus,
      'finance_amount': amount,
      'finance_received_price': receivedPrice,
      'financier_id': financier?.id,
      'account_id': accountId,
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
    int? accountId,
    String? accountName,
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
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
    );
  }
}
