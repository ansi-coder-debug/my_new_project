class Broker {
  final int? id;
  final String name;
  final String phone;
  final String address;

  Broker({
    this.id,
    required this.name,
    required this.phone,
   required this.address,
  });

  factory Broker.fromJson(Map<String, dynamic> json) {
    return Broker(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
    };
  }
}
