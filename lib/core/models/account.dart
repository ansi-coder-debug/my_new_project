class Account {
  final String? id;           // id can be null for new accounts
  final String name;
  final String type;          // 'cash' or 'bank'
  final String? description;
  final String? partnerId;
  final double amount; // ✅ CORRECT (backend uses "amount")
   final DateTime? createdAt; // Add this

  Account({
    this.id,
    required this.name,
    required this.type,
    this.description,
    this.partnerId,
  this.amount = 0.0, 
    this.createdAt
     });
      // Add copyWith method for editing
  Account copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
    String? partnerId,
    double? amount,
    DateTime? createdAt,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      partnerId: partnerId ?? this.partnerId,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

 factory Account.fromJson(Map<String, dynamic> json) {
  return Account(
    id: json['id']?.toString() ?? json['_id']?.toString(), // handles both "id" and "_id"
    name: json['name'],
    type: json['type'],
    description: json['description'],
    partnerId: json['partner_id']?.toString(), // ✅ Convert to String safely
     amount: _parseAmount(json['amount']), // ✅ Handles both string and number
     createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : null,
  );
}


  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'type': type,
      if (description != null) 'description': description,
      if (partnerId != null) 'partner_id': partnerId,
       'amount': amount, // ✅ correct
    };
  }
  static double _parseAmount(dynamic amount) {
  if (amount == null) return 0.0;
  if (amount is double) return amount;
  if (amount is int) return amount.toDouble();
  if (amount is String) {
    return double.tryParse(amount) ?? 0.0;
  }
  return 0.0;
}
}
