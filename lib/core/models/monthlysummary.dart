class MonthlySummary {
  final int year;
  final String month;

  // Expense
  final int expenseCount;
  final double expenseAmount;
  final double expensePaid;
  final double expenseBalance;

  // Sale
  final int saleCount;
  final double saleReceived;
  final double salePending;

  // Purchase
  final int purchaseCount;
  final double purchasePaid;
  final double purchasePending;

  MonthlySummary({
    required this.year,
    required this.month,
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

  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    return MonthlySummary(
      year: (json['year'] is int) ? json['year'] : int.parse(json['year'].toString()),
      month: json['month'],

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
