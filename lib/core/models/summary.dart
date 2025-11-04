class Summary {
  final SummarySection expense;
  final SaleSection sale;
  final PurchaseSection purchase;
  final FinanceSection finance;
  final PayrollSection payroll;
  final BrokerageSection brokerage;
  final PartnershipSection partnership;
  final MaintenanceSection maintenance;

  Summary({
    required this.expense,
    required this.sale,
    required this.purchase,
    required this.finance,
    required this.payroll,
    required this.brokerage,
    required this.partnership,
    required this.maintenance,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      expense: SummarySection.fromJson(json['expense'] ?? {}),
      sale: SaleSection.fromJson(json['sale'] ?? {}),
      purchase: PurchaseSection.fromJson(json['purchase'] ?? {}),
      finance: FinanceSection.fromJson(json['finance'] ?? {}),
      payroll: PayrollSection.fromJson(json['payroll'] ?? {}),
      brokerage: BrokerageSection.fromJson(json['brokerage'] ?? {}),
      partnership: PartnershipSection.fromJson(json['partnership'] ?? {}),
      maintenance: MaintenanceSection.fromJson(json['maintenance'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expense': expense.toJson(),
      'sale': sale.toJson(),
      'purchase': purchase.toJson(),
      'finance': finance.toJson(),
      'payroll': payroll.toJson(),
      'brokerage': brokerage.toJson(),
      'partnership': partnership.toJson(),
      'maintenance': maintenance.toJson(),
    };
  }
}

class SummarySection {
  final double total;
  final double paid;
  final double pending;

  SummarySection({
    required this.total,
    required this.paid,
    required this.pending,
  });

  factory SummarySection.fromJson(Map<String, dynamic> json) {
    return SummarySection(
      total: (json['total'] ?? 0).toDouble(),
      paid: (json['paid'] ?? 0).toDouble(),
      pending: (json['pending'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'paid': paid,
      'pending': pending,
    };
  }
}

class SaleSection {
  final int count;
  final double total;
  final double received;
  final double pending;

  SaleSection({
    required this.count,
    required this.total,
    required this.received,
    required this.pending,
  });

  factory SaleSection.fromJson(Map<String, dynamic> json) {
    return SaleSection(
      count: json['count'] ?? 0,
      total: (json['total'] ?? 0).toDouble(),
      received: (json['received'] ?? 0).toDouble(),
      pending: (json['pending'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'total': total,
      'received': received,
      'pending': pending,
    };
  }
}

class PurchaseSection {
  final int count;
  final double total;
  final double paid;
  final double pending;

  PurchaseSection({
    required this.count,
    required this.total,
    required this.paid,
    required this.pending,
  });

  factory PurchaseSection.fromJson(Map<String, dynamic> json) {
    return PurchaseSection(
      count: json['count'] ?? 0,
      total: (json['total'] ?? 0).toDouble(),
      paid: (json['paid'] ?? 0).toDouble(),
      pending: (json['pending'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'total': total,
      'paid': paid,
      'pending': pending,
    };
  }
}

class FinanceSection {
  final double total;
  final double received;
  final double pending;

  FinanceSection({
    required this.total,
    required this.received,
    required this.pending,
  });

  factory FinanceSection.fromJson(Map<String, dynamic> json) {
    return FinanceSection(
      total: (json['total'] ?? 0).toDouble(),
      received: (json['received'] ?? 0).toDouble(),
      pending: (json['pending'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'received': received,
      'pending': pending,
    };
  }
}

class PayrollSection {
  final double total;

  PayrollSection({required this.total});

  factory PayrollSection.fromJson(Map<String, dynamic> json) {
    return PayrollSection(
      total: (json['total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'total': total};
  }
}

class BrokerageSection {
  final double total;
  final double paid;
  final double pending;

  BrokerageSection({
    required this.total,
    required this.paid,
    required this.pending,
  });

  factory BrokerageSection.fromJson(Map<String, dynamic> json) {
    return BrokerageSection(
      total: (json['total'] ?? 0).toDouble(),
      paid: (json['paid'] ?? 0).toDouble(),
      pending: (json['pending'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'paid': paid,
      'pending': pending,
    };
  }
}

class PartnershipSection {
  final double total;
  final double paid;
  final double pending;

  PartnershipSection({
    required this.total,
    required this.paid,
    required this.pending,
  });

  factory PartnershipSection.fromJson(Map<String, dynamic> json) {
    return PartnershipSection(
      total: (json['total'] ?? 0).toDouble(),
      paid: (json['paid'] ?? 0).toDouble(),
      pending: (json['pending'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'paid': paid,
      'pending': pending,
    };
  }
}

class MaintenanceSection {
  final int count;

  MaintenanceSection({required this.count});

  factory MaintenanceSection.fromJson(Map<String, dynamic> json) {
    return MaintenanceSection(
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'count': count};
  }
}
