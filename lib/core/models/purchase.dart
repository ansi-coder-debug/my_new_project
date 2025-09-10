


class Purchase  {
  
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

  Purchase({
    required this.id,
    required this.vehicleId,
    required this.userId,
    required this.name,
    required this.phone,
    required this.address,
    required this.date,
    required this.price,
    required this.modeOfPayment,
    required this.paymentStatus,
  });

  // ✅ JSON factory (to map with backend API)
  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'].toString(),
      vehicleId: json['vehicle_id'].toString(),
      userId: json['user_id'].toString(),
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      // date: DateTime.parse(json['date']),
      //temp date code 
      date:json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      modeOfPayment: json['mode_of_payment'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
    );
  }

  // ✅ Convert to JSON (for sending to backend)
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
      'mode_of_payment': modeOfPayment,
      'payment_status': paymentStatus,
    };
  }
}
