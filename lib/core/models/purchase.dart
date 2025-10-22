class Purchase {
  final String id;
  final String vehicleId;
  final String userId;
  final String name;
  final String phone;
  final String address;
  final DateTime date;
  final double price;
  final String modeOfPayment;
  final String paymentStatus;
  // final  purchasePaid; // add this
  final double paidAmount; //
  final String? accountId;
  final String? accountName; // holds the account name (e.g., "Federal Bank")

  Purchase({
    required this.id,
    required this.vehicleId,
    required this.userId,
    required this.name,
    required this.phone,
    required this.address,
    required this.date,
    required this.price,
    required this.modeOfPayment, // Will store Account ID as String, not just a string name
    required this.paymentStatus,
    // required this.purchasePaid, //(partial , paid )
    required this.paidAmount,
    this.accountId,
    this.accountName,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'].toString(),
      vehicleId: json['vehicle_id'].toString(),
      userId: json['user_id'].toString(),
      name: json['purchase_name'] ?? json['name'] ?? '',
      phone: json['purchase_phone'] ?? json['phone'] ?? '',
      address: json['purchase_address'] ?? json['address'] ?? '',
      date: json['purchase_date'] != null
          ? DateTime.parse(json['purchase_date'])
          : DateTime.now(),
      price: double.tryParse(json['purchase_price'].toString()) ?? 0.0,
      modeOfPayment:
          (json['purchase_mode_of_payment'] ?? json['mode_of_payment'] ?? '')
              .toString(),
      paymentStatus:
          json['purchase_payment_status'] ?? json['payment_status'] ?? '',
      paidAmount: double.tryParse(json['purchase_paid'].toString()) ?? 0.0,
      accountId: json['account_id']?.toString(),
      accountName: json['account_name'] ?? '',
    );
  }

Map<String, dynamic> toJson() {
  final jsonMap = {
    'id': id,
    'vehicle_id': vehicleId,
    'user_id': userId,
    'purchase_name': name, // Changed from 'name'
    'purchase_phone': phone, // Changed from 'phone'
    'purchase_address': address, // Changed from 'address'
    'purchase_date': date.toIso8601String(), // Changed from 'date'
    'purchase_price': price.toString(), // Changed from 'price'
    'purchase_paid': paidAmount.toString(), // This field is crucial!
    'purchase_from_account': modeOfPayment, // Changed from 'mode_of_payment'
    'purchase_payment_status': paymentStatus, // Changed from 'payment_status'
  };

  print('🔥 Purchase.toJson() → $jsonMap');
  return jsonMap;
}

}
