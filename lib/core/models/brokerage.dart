class Brokerage {
  final int? id;
  final int ?brokerId;
  final String brokerName;
  final String amount;
  final String? remarks;
  final String? brokeragePaid;
final String? paymentStatus;
final int? saleId;
  



  Brokerage({
    this.id,
     this.brokerId,
    required this.brokerName,
    required this.amount,
    this.remarks,
    this.brokeragePaid,     
  this.paymentStatus, 
  this.saleId 

  });

  factory Brokerage.fromJson(Map<String, dynamic> json) {
    return Brokerage(
      id: json['id'],
      brokerId: json['broker_id'],
      brokerName: json['broker_name'],
      amount: json['amount'],
      remarks: json['remarks'],
       brokeragePaid: json['brokerage_paid'],      // new
    paymentStatus: json['payment_status'],      // new
      saleId: json['sale_id'], // new
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'broker_id': brokerId,
      'broker_name': brokerName,
      'amount': amount,
      'remarks': remarks,
       'brokerage_paid': brokeragePaid,      // new
    'payment_status': paymentStatus,      // new
      'sale_id': saleId, // new
    };
  }
}
