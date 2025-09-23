class ExpenseType {
  final int? id;
  final int userId;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ExpenseType({
    this.id,
    required this.userId,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory ExpenseType.fromJson(Map<String, dynamic> json) {
    return ExpenseType(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
    };
  }
}
