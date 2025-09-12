class Brokerage {
  final int? id;
  final int ?brokerId;
  final String brokerName;
  final String amount;
  final String? remarks;

  Brokerage({
    this.id,
     this.brokerId,
    required this.brokerName,
    required this.amount,
    this.remarks,
  });

  factory Brokerage.fromJson(Map<String, dynamic> json) {
    return Brokerage(
      id: json['id'],
      brokerId: json['broker_id'],
      brokerName: json['broker_name'],
      amount: json['amount'],
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'broker_id': brokerId,
      'broker_name': brokerName,
      'amount': amount,
      'remarks': remarks,
    };
  }
}
