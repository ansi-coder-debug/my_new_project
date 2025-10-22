class Brokerage {
  final int? id;
  final int? brokerId;
  final String brokerName;
  final double amount;
  final String? remarks;
  final double? brokeragePaid;
  final String? paymentStatus;
  final int? saleId;
  final int? fromAccount;      // NEW
  final String? accountName;   // NEW

  Brokerage({
    this.id,
    this.brokerId,
    required this.brokerName,
    required this.amount,
    this.remarks,
    this.brokeragePaid,
    this.paymentStatus,
    this.saleId,
    this.fromAccount,
    this.accountName,
  });

  factory Brokerage.fromJson(Map<String, dynamic> json) {
    return Brokerage(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      brokerId: json['broker_id'] is int ? json['broker_id'] : int.tryParse(json['broker_id']?.toString() ?? ''),
      brokerName: json['broker_name'] ?? '',
      amount: (json['brokerage_amount'] is num)
          ? (json['brokerage_amount'] as num).toDouble()
          : double.tryParse(json['brokerage_amount']?.toString() ?? '0') ?? 0.0,
      remarks: json['remarks'] ?? '',
      brokeragePaid: (json['brokerage_paid'] is num)
          ? (json['brokerage_paid'] as num).toDouble()
          : double.tryParse(json['brokerage_paid']?.toString() ?? '0'),
      paymentStatus: json['brokerage_payment_status'] ?? json['payment_status'],
      saleId: json['sale_id'] is int ? json['sale_id'] : int.tryParse(json['sale_id']?.toString() ?? ''),
      fromAccount: json['from_account'] is int
          ? json['from_account']
          : int.tryParse(json['from_account']?.toString() ?? ''),
      accountName: json['account_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'broker_id': brokerId,
      'broker_name': brokerName,
      'brokerage_amount': amount,
      'remarks': remarks,
      'brokerage_paid': brokeragePaid ?? 0.0,
      'brokerage_payment_status': paymentStatus ?? 'pending',
      'sale_id': saleId,
      'from_account': fromAccount,
      'account_name': accountName,
    };
  }
}
