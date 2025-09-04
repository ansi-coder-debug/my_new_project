class Partner {
  final String? id;
  final String name;
  final String address;
  final String? phone;

  Partner({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'] ?.toString(),
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
    };
  }

  /// ✅ CopyWith for Partner
  Partner copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
  }) {
    return Partner(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }
}
