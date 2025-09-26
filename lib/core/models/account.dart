class Account {
  final String? id;           // id can be null for new accounts
  final String name;
  final String type;          // 'cash' or 'bank'
  final String? description;
  final String? partnerId;

  Account({
    this.id,
    required this.name,
    required this.type,
    this.description,
    this.partnerId,
  });

 factory Account.fromJson(Map<String, dynamic> json) {
  return Account(
    id: json['id']?.toString() ?? json['_id']?.toString(), // handles both "id" and "_id"
    name: json['name'],
    type: json['type'],
    description: json['description'],
    partnerId: json['partner_id']?.toString(), // ✅ Convert to String safely
  );
}


  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'type': type,
      if (description != null) 'description': description,
      if (partnerId != null) 'partner_id': partnerId,
    };
  }
}
