class DailySummary {
  final String date;

  final int expenseCount;
  final double expenseAmount;
  final double expensePaid;
  final double expenseBalance;

  final int saleCount;
  final double saleReceived;
  final double salePending;

  final int purchaseCount;
  final double purchasePaid;
  final double purchasePending;

  DailySummary({
    required this.date,
    required this.expenseCount,
    required this.expenseAmount,
    required this.expensePaid,
    required this.expenseBalance,
    required this.saleCount,
    required this.saleReceived,
    required this.salePending,
    required this.purchaseCount,
    required this.purchasePaid,
    required this.purchasePending,
  });

  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      date: json['date'],

      expenseCount: json['expense']?['count'] ?? 0,
      expenseAmount: (json['expense']?['amount'] ?? 0).toDouble(),
      expensePaid: (json['expense']?['paid'] ?? 0).toDouble(),
      expenseBalance: (json['expense']?['balance'] ?? 0).toDouble(),

      saleCount: json['sale']?['count'] ?? 0,
      saleReceived: (json['sale']?['received'] ?? 0).toDouble(),
      salePending: (json['sale']?['pending'] ?? 0).toDouble(),

      purchaseCount: json['purchase']?['count'] ?? 0,
      purchasePaid: (json['purchase']?['paid'] ?? 0).toDouble(),
      purchasePending: (json['purchase']?['pending'] ?? 0).toDouble(),
    );
  }
}
