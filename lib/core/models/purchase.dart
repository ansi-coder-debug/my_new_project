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
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      // modeOfPayment: json['mode_of_payment']
      //     .toString(), // This should be account id string
      modeOfPayment: (json['mode_of_payment'] ?? json['account_id'] ?? '').toString(),
      paymentStatus: json['payment_status'] ?? '',
      // purchasePaid:
      //     json['purchase_paid'] == 1 ||
      //     json['purchase_paid'] == true, // adapt based on actual type
       paidAmount: double.tryParse(json['purchase_paid'].toString()) ?? 0.0,
        accountId: json['account_id']?.toString(), // PARSE HERE
      accountName: json['account_name'] ?? '', // NEW field added
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_id': vehicleId,
      'user_id': userId,
      'name': name,
      'phone': phone,
      'address': address,
      'date': date.toIso8601String(),
      'price': price,
      'mode_of_payment': modeOfPayment, // account id string here
      'payment_status': paymentStatus,
      // 'purchase_paid': purchasePaid ? 1 : 0, // adapt type accordingly
      'purchase_paid': paidAmount, 
       'account_id': accountId, // INCLUDE HERE TOO
    };
  }
}
