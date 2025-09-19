class Financier {
  final int? id;
  final int? userId;
  final String companyName;
  final String contactPerson;
  final String contactNumber;
  final String address;

  Financier({
    this.id,
    this.userId,
    required this.companyName,
    required this.contactPerson,
    required this.contactNumber,
    required this.address,
  });

  factory Financier.fromJson(Map<String, dynamic> json) {
    return Financier(
      id: json['id'],
      userId: json['user_id'],
      companyName: json['company_name'] ?? '',
      contactPerson: json['contact_person'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'contact_person': contactPerson,
      'contact_number': contactNumber,
      'address': address,
      // Don't include `id` or `user_id` unless needed
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
    };
  }
}
