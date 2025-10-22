import 'package:my_new_project/core/models/finance.dart';

class SaleInfo {
  final String? id;
  final String name;
  final String phone;
  final String address;
  final String date;
  final String price;
  final String receivedPrice;
  final String modeOfPayment;
  final String paymentStatus;
  final String? accountId;
  final String? accountName;
  final Finance? financeInfo;

  SaleInfo({
    this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.date,
    required this.price,
    required this.receivedPrice,
    required this.modeOfPayment,
    required this.paymentStatus,
    this.accountId,
    this.accountName,
    this.financeInfo,
  });

  // ✅ Factory from backend JSON
  factory SaleInfo.fromJson(Map<String, dynamic> json) {
    print('🔥 SaleInfo JSON received: $json');
    return SaleInfo(
      id: json['id']?.toString(),
      name: json['sale_name'] ?? json['name'] ?? '',
      phone: json['sale_phone'] ?? json['phone'] ?? '',
      address: json['sale_address'] ?? json['address'] ?? '',
      date: json['sale_date']?.toString() ?? json['date'] ?? '',
      price: json['sale_price']?.toString() ?? json['price']?.toString() ?? '0',
      receivedPrice:
          json['sale_received_price']?.toString() ?? json['received_price']?.toString() ?? '0',
      modeOfPayment: (json['sale_to_account'] ??
              json['sale_mode_of_payment'] ??
              json['mode_of_payment'] ??
              '')
          .toString(),
      paymentStatus:
          json['sale_payment_status'] ?? json['payment_status'] ?? 'pending',
      accountId: json['account_id']?.toString(),
      accountName: json['account_name'] ?? '',
      financeInfo: json['finance_info'] != null
          ? Finance.fromJson(json['finance_info'])
          : null,
    );
  }

  // ✅ Convert to backend-compatible payload
  Map<String, dynamic> toJson() {
    dynamic cleanNumeric(String? value) {
      if (value == null) return 0.0;
      final cleaned = value.replaceAll(',', '');
      return double.tryParse(cleaned) ?? 0.0;
    }

    return {
      'id': id,
      'sale_name': name,
      'sale_phone': phone,
      'sale_address': address,
      'sale_date': date,
      'sale_price': cleanNumeric(price),
      'sale_received_price': cleanNumeric(receivedPrice),
      'sale_to_account': modeOfPayment, // ✅ backend key
      'sale_payment_status': paymentStatus, // ✅ backend key
      'account_id': accountId ?? '',
      'account_name': accountName ?? '',
      if (financeInfo != null) 'finance_info': financeInfo!.toJson(),
    };
  }
}
