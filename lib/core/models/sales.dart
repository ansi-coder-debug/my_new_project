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
  final String? accountName; // holds the account name (e.g., "Federal Bank")

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
  });

  factory SaleInfo.fromJson(Map<String, dynamic> json) {
    print('🔥 SaleInfo JSON received: $json');
    return SaleInfo(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      date: json['date'] ?? '',
      price: json['price']?.toString() ?? '0',
      receivedPrice: json['received_price']?.toString() ?? '0',
      modeOfPayment: json['mode_of_payment'] ?? '',

      paymentStatus: json['payment_status'] ?? 'pending',
      accountId: json['account_id']?.toString(), // PARSE HERE
      accountName: json['account_name'] ?? '', // NEW field added
    );
  }

  Map<String, dynamic> toJson() {
    dynamic cleanNumeric(String? value) {
      if (value == null) return 0.0;
      final cleaned = value.replaceAll(',', '');
      return double.tryParse(cleaned) ?? 0.0;
    }

    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'date': date,
      'price': cleanNumeric(price),
      'received_price': cleanNumeric(receivedPrice),
      'mode_of_payment': modeOfPayment,
      'payment_status': paymentStatus,
      'account_id': accountId, // INCLUDE HERE TOO
    };
  }
}
