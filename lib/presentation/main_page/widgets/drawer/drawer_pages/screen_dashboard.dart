// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:my_new_project/application/expense/expense_provider.dart';
// import 'package:my_new_project/application/finance/finance_provider.dart';
// import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
// import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/presentation/main_page/widgets/drawer/drawer_pages/screen_inventory.dart';
// import 'package:my_new_project/presentation/main_page/widgets/screen_main_page.dart';
// import 'package:my_new_project/widgets/dashboard/dashboard_card.dart';
// import 'package:my_new_project/widgets/dashboard/pie_chart.dart';

// class ScreenDashboard extends ConsumerStatefulWidget {
//   final void Function(int index, {String? status})? onCardTap;

//   const ScreenDashboard({super.key, this.onCardTap});

//   @override
//   ConsumerState<ScreenDashboard> createState() => _ScreenDashboardState();
// }

// class _ScreenDashboardState extends ConsumerState<ScreenDashboard> {
//   @override
//   Widget build(BuildContext context) {
//     final vehicleState = ref.watch(vehicleProvider);
//     final totalVehicles = vehicleState.vehicles.length;

//     final availableVehicles = vehicleState.vehicles
//         .where((v) => v.status.toLowerCase() == 'available')
//         .length;

//     final soldVehicles = vehicleState.vehicles
//         .where((v) => v.status.toLowerCase() == 'sold')
//         .length;

//     final maintainceVehicles = vehicleState.vehicles
//         .where((v) => v.status.toLowerCase() == 'maintenance')
//         .length;

//     //expense
//     final expenseState = ref.watch(expenseProvider);
//     final expenses = expenseState.expenses;

//     double parseAmount(String? value) => double.tryParse(value ?? '0') ?? 0;
//     final totalExpense = expenses.fold<double>(
//       0,
//       (sum, item) => sum + (item.amount),
//     );

//     final totalPaid = expenses.fold<double>(
//       0,
//       (sum, item) => sum + (item.expensePaid),
//     );

//     final totalBalance = totalExpense - totalPaid;

//     String formatCurrency(double amount) {
//       return '₹${amount.toStringAsFixed(0)}';
//     }

//     // SALES
//     final saleVehicles = vehicleState.vehicles
//         .where((v) => v.saleInfo != null)
//         .toList();

//     double parseSaleAmount(String? value) => double.tryParse(value ?? '') ?? 0;

//     final totalSales = saleVehicles.fold<double>(
//       0,
//       (sum, vehicle) => sum + parseSaleAmount(vehicle.saleInfo?.price),
//     );

//     final totalSalesReceived = saleVehicles.fold<double>(
//       0,
//       (sum, vehicle) => sum + parseSaleAmount(vehicle.saleInfo?.receivedPrice),
//     );

//     final totalSalesBalance = totalSales - totalSalesReceived;

//     // PURCHASE
//     final purchasedVehicles = vehicleState.vehicles
//         .where((v) => v.purchaseInfo != null)
//         .toList();

//     double getPurchaseValue(double? val) => val ?? 0;

//     final totalPurchaseAmount = purchasedVehicles.fold<double>(
//       0,
//       (sum, v) => sum + getPurchaseValue(v.purchaseInfo?.price),
//     );

//     final totalPurchasePaid = purchasedVehicles.fold<double>(
//       0,
//       (sum, v) => sum + getPurchaseValue(v.purchaseInfo?.paidAmount),
//     );

//     final totalPurchaseBalance = totalPurchaseAmount - totalPurchasePaid;

//     // PARTNERSHIPS
//     final allPartnerships = vehicleState.vehicles
//         .expand((vehicle) => vehicle.partnerships ?? [])
//         .toList();

//     double parsePartnershipAmount(String? value) =>
//         double.tryParse(value ?? '0') ?? 0;

//     final totalPartnerContribution = allPartnerships.fold<double>(
//       0,
//       (sum, p) => sum + parsePartnershipAmount(p.contribution),
//     );

//     final totalPartnerPaid = totalPartnerContribution;

//     final totalPartnerBalance = totalPartnerContribution - totalPartnerPaid;

//     // FINANCE
//     final financeState = ref.watch(financeProvider);
//     final finances = financeState.finances;

//     double totalFinanceAmount = finances.fold<double>(
//       0,
//       (sum, item) => sum + (item.amount ?? 0),
//     );

//     double totalFinanceReceived = finances.fold<double>(
//       0,
//       (sum, item) => sum + (item.receivedPrice ?? 0),
//     );

//     double totalFinanceBalance = totalFinanceAmount - totalFinanceReceived;

//     // --- Chart Data Preparation ---
//     final Map<String, double> dailySalesMap = {};

//     for (final vehicle in saleVehicles) {
//       final sale = vehicle.saleInfo!;
//       final rawDate = sale.date ?? ''; // raw string date from saleInfo
//       final amount = parseSaleAmount(sale.price);

//       // Attempt to parse the raw date safely
//       final DateTime? parsedDate = DateTime.tryParse(rawDate);
//       if (parsedDate != null) {
//         final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

//         if (dailySalesMap.containsKey(formattedDate)) {
//           dailySalesMap[formattedDate] = dailySalesMap[formattedDate]! + amount;
//         } else {
//           dailySalesMap[formattedDate] = amount;
//         }
//       }
//     }

//     // Create data points for last 30 days
//     final now = DateTime.now();
//     final List<MapEntry<String, double>> chartData = [];

//     for (int i = 29; i >= 0; i--) {
//       final date = now.subtract(Duration(days: i));
//       final formattedDate = DateFormat('yyyy-MM-dd').format(date);
//       chartData.add(MapEntry(formattedDate, dailySalesMap[formattedDate] ?? 0));
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("Dashboard")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               DashboardCard(
//                 title: "VEHICLES",
//                 totalValue: totalVehicles.toString(),
//                 icon: Icons.directions_car,
//                 backgroundColor: const Color(0xFF3498DB),
//                 items: [
//                   DashboardCardItem(
//                     label: "Available",
//                     value: availableVehicles.toString(),
//                     onTap: () => widget.onCardTap?.call(1, status: "Available"),
//                   ),
//                   DashboardCardItem(
//                     label: 'Sold',
//                     value: soldVehicles.toString(),
//                     onTap: () => widget.onCardTap?.call(1, status: "Sold"),
//                   ),
//                   DashboardCardItem(
//                     label: 'Maintenance',
//                     value: maintainceVehicles.toString(),
//                     onTap: () =>
//                         widget.onCardTap?.call(1, status: "Maintenance"),
//                   ),
//                 ],
//               ),
//               KHeight,
//               DashboardCard(
//                 title: "EXPENSE",
//                 totalValue: formatCurrency(totalExpense),
//                 icon: Icons.receipt_long,
//                 backgroundColor: const Color(0xFFE74C3C),
//                 items: [
//                   DashboardCardItem(
//                     label: "Paid",
//                     value: formatCurrency(totalPaid),
//                     onTap: () => widget.onCardTap?.call(4),
//                   ),
//                   DashboardCardItem(
//                     label: "Balance",
//                     value: formatCurrency(totalBalance),
//                     onTap: () => widget.onCardTap?.call(4),
//                   ),
//                 ],
//               ),
//               KHeight,
//               DashboardCard(
//                 title: "SALES",
//                 totalValue: formatCurrency(totalSales),
//                 icon: Icons.volunteer_activism,
//                 backgroundColor: const Color(0xFF2ECC71),
//                 items: [
//                   DashboardCardItem(
//                     label: "Recieved",
//                     value: formatCurrency(totalSalesReceived),
//                     onTap: () => widget.onCardTap?.call(2),
//                   ),
//                   DashboardCardItem(
//                     label: "Balance",
//                     value: formatCurrency(totalSalesBalance),
//                     onTap: () => widget.onCardTap?.call(2),
//                   ),
//                 ],
//               ),
//               KHeight,
//               DashboardCard(
//                 title: "PURCHASES",
//                 totalValue: formatCurrency(totalPurchaseAmount),
//                 icon: Icons.shopping_cart,
//                 backgroundColor: const Color(0xFFF39C12),
//                 items: [
//                   DashboardCardItem(
//                     label: "Paid",
//                     value: formatCurrency(totalPurchasePaid),
//                     onTap: () => widget.onCardTap?.call(3),
//                   ),
//                   DashboardCardItem(
//                     label: "Balance",
//                     value: formatCurrency(totalPurchaseBalance),
//                     onTap: () => widget.onCardTap?.call(3),
//                   ),
//                 ],
//               ),
//               KHeight,
//               DashboardCard(
//                 title: "Partnership",
//                 totalValue: formatCurrency(totalPartnerContribution),
//                 icon: Icons.handshake_sharp,
//                 backgroundColor: Color.fromRGBO(143, 179, 14, 0.7411764706),
//                 items: [
//                   DashboardCardItem(
//                     label: "Paid",
//                     value: formatCurrency(totalPartnerPaid),
//                     onTap: () => widget.onCardTap?.call(11),
//                   ),
//                   DashboardCardItem(
//                     label: "Balance",
//                     value: formatCurrency(totalPartnerBalance),
//                     onTap: () => widget.onCardTap?.call(11),
//                   ),
//                 ],
//               ),
//               KHeight,
//               DashboardCard(
//                 title: "FINANCE",
//                 totalValue: formatCurrency(totalFinanceAmount),
//                 icon: Icons.account_balance,
//                 backgroundColor: const Color(0xFF9B59B6),
//                 items: [
//                   DashboardCardItem(
//                     label: "Recieved",
//                     value: formatCurrency(totalFinanceReceived),
//                     onTap: () => widget.onCardTap?.call(10),
//                   ),
//                   DashboardCardItem(
//                     label: "Balance",
//                     value: formatCurrency(totalFinanceBalance),
//                     onTap: () => widget.onCardTap?.call(10),
//                   ),
//                 ],
//               ),
//               KHeight16,
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey.shade300, width: 1),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       blurRadius: 6,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Text(
//                         "Daily Sales (Last 30 Days)",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                     KHeight,
//                     buildSalesChart(chartData),
//                     KHeight16,
//                     // Pie Chart section
//                     SalesVsPurchasePieChart(
//                       totalSalesReceived: totalSalesReceived,
//                       totalPurchasePaid: totalPurchasePaid,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- UPDATED CHART CODE (ONLY buildSalesChart function modified) ---
//   Widget buildSalesChart(List<MapEntry<String, double>> chartData) {
//     double maxSales = 0;
//     if (chartData.isNotEmpty) {
//       maxSales = chartData.map((e) => e.value).reduce((a, b) => a > b ? a : b);
//     }
//     maxSales = maxSales * 1.1;
//     if (maxSales < 1000) maxSales = 1000;

//     double getYAxisInterval(double maxValue) {
//       if (maxValue < 5000) return 1000;
//       if (maxValue < 20000) return 5000;
//       if (maxValue < 50000) return 10000;
//       return 25000;
//     }

//     final double yAxisInterval = getYAxisInterval(maxSales);

//     String formatYAxisLabel(double value) {
//       if (value == 0) return '₹0';
//       if (value >= 100000) return '₹${(value / 100000).toStringAsFixed(1)}L';
//       if (value >= 1000) return '₹${(value / 1000).toStringAsFixed(0)}K';
//       return '₹${value.toInt()}';
//     }

//     final Color lineColor = Colors.redAccent;
//     final Color gridColor = Colors.grey.shade200;
//     final Color textColor = Colors.grey.shade700;
//     final Color tooltipBgColor = Colors.blueGrey.shade800;

//     return SizedBox(
//       height: 250,
//       child: LineChart(
//         LineChartData(
//           minX: 0,
//           maxX: (chartData.length - 1).toDouble(),
//           minY: 0,
//           maxY: maxSales,
//           gridData: FlGridData(
//             show: true,
//             drawHorizontalLine: true,
//             drawVerticalLine: false,
//             getDrawingHorizontalLine: (value) {
//               return FlLine(
//                 color: gridColor,
//                 strokeWidth: 1,
//                 dashArray: [5, 5],
//               );
//             },
//           ),
//           titlesData: FlTitlesData(
//             show: true,
//             topTitles: const AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             rightTitles: const AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 30,
//                 interval: chartData.length > 7
//                     ? (chartData.length / 5).floor().toDouble()
//                     : 1,
//                 getTitlesWidget: (value, meta) {
//                   final index = value.toInt();
//                   if (index < 0 || index >= chartData.length)
//                     return const SizedBox();
//                   final dateStr = chartData[index].key;
//                   final date = DateTime.parse(dateStr);
//                   final formatted = DateFormat('MM/dd').format(date);
//                   return SideTitleWidget(
//                     axisSide: meta.axisSide,
//                     space: 8,
//                     child: Text(
//                       formatted,
//                       style: TextStyle(
//                         color: textColor,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 50,
//                 interval: yAxisInterval,
//                 getTitlesWidget: (value, meta) {
//                   return SideTitleWidget(
//                     axisSide: meta.axisSide,
//                     space: 10,
//                     child: Text(
//                       formatYAxisLabel(value),
//                       style: TextStyle(
//                         color: textColor,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       textAlign: TextAlign.right,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           borderData: FlBorderData(
//             show: true,
//             border: Border.all(color: gridColor, width: 1),
//           ),
//           lineBarsData: [
//             LineChartBarData(
//               spots: List.generate(chartData.length, (index) {
//                 return FlSpot(index.toDouble(), chartData[index].value);
//               }),
//               isCurved: true,
//               color: lineColor,
//               barWidth: 3,
//               isStrokeCapRound: true,
//               belowBarData: BarAreaData(
//                 show: true,
//                 gradient: LinearGradient(
//                   colors: [
//                     lineColor.withOpacity(0.3),
//                     lineColor.withOpacity(0.0),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//               dotData: FlDotData(
//                 show: true,
//                 getDotPainter: (spot, percent, bar, index) {
//                   // --- MODIFIED DOT RENDERING LOGIC ---
//                   // Show a dot for the first point, the last point,
//                   // and every 5th point in between.
//                   if (index == 0 ||
//                       index == chartData.length - 1 ||
//                       index % 5 == 0) {
//                     // Shows dots at index 0, 5, 10, 15, 20, 25, 29 (for 30 days)
//                     return FlDotCirclePainter(
//                       radius: 4,
//                       color: lineColor,
//                       strokeColor: Colors.white,
//                       strokeWidth: 2,
//                     );
//                   }
//                   return FlDotCirclePainter(
//                     radius: 0, // Don't show a dot for other points
//                     color: Colors.transparent,
//                     strokeColor: Colors.transparent,
//                     strokeWidth: 0,
//                   );
//                   // --- END MODIFIED DOT RENDERING LOGIC ---
//                 },
//               ),
//             ),
//           ],
//           lineTouchData: LineTouchData(
//             touchTooltipData: LineTouchTooltipData(
//               tooltipBgColor: tooltipBgColor,
//               getTooltipItems: (touchedSpots) {
//                 return touchedSpots.map((LineBarSpot touchedSpot) {
//                   final index = touchedSpot.spotIndex;
//                   if (index < 0 || index >= chartData.length) return null;
//                   final date = DateTime.parse(chartData[index].key);
//                   final formattedDate = DateFormat('MMM d, yyyy').format(date);
//                   final salesValue = chartData[index].value;
//                   return LineTooltipItem(
//                     '$formattedDate\n${formatYAxisLabel(salesValue)}',
//                     const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   );
//                 }).toList();
//               },
//             ),
//             handleBuiltInTouches: true,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/dailysummary/dailysummary_provider.dart';
import 'package:my_new_project/application/summary/summary_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/dailysummary.dart';
import 'package:my_new_project/core/models/summary.dart';
import 'package:my_new_project/widgets/dashboard/dashboard_card.dart';
import 'package:my_new_project/widgets/dashboard/pie_chart.dart';

class ScreenDashboard extends ConsumerStatefulWidget {
  final void Function(int index, {String? status})? onCardTap;

  const ScreenDashboard({super.key, this.onCardTap});

  @override
  ConsumerState<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends ConsumerState<ScreenDashboard> {
  @override
  void initState() {
    super.initState();
    // Fetch summary data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(summaryProvider.notifier).fetchSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final summaryState = ref.watch(summaryProvider);
    final summary = summaryState.summary;

    final dailySummaryState = ref.watch(dailySummaryProvider);
final dailySummaries = dailySummaryState.summaries;

    // Show loading indicator
    if (summaryState.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Dashboard")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Show error message
    if (summaryState.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Dashboard")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Error loading dashboard",
                style: TextStyle(fontSize: 16, color: Colors.red.shade700),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(summaryProvider.notifier).fetchSummary();
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    // Show empty state if no data
    if (summary == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Dashboard")),
        body: const Center(child: Text("No data available")),
      );
    }

    String formatCurrency(double amount) {
      return '₹${amount.toStringAsFixed(0)}';
    }

    // Get vehicle counts from summary data
    final totalVehicles = (summary.sale.count + summary.purchase.count);
    final soldVehicles = summary.sale.count;
    final availableVehicles =
        totalVehicles - soldVehicles; // Assuming available = total - sold
    final maintenanceVehicles = summary.maintenance.count;

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // VEHICLES CARD
              DashboardCard(
                title: "VEHICLES",
                totalValue: totalVehicles.toString(),
                icon: Icons.directions_car,
                backgroundColor: const Color(0xFF3498DB),
                items: [
                  DashboardCardItem(
                    label: "Available",
                    value: availableVehicles.toString(),
                    onTap: () => widget.onCardTap?.call(1, status: "Available"),
                  ),
                  DashboardCardItem(
                    label: 'Sold',
                    value: soldVehicles.toString(),
                    onTap: () => widget.onCardTap?.call(1, status: "Sold"),
                  ),
                  DashboardCardItem(
                    label: 'Maintenance',
                    value: maintenanceVehicles.toString(),
                    onTap: () =>
                        widget.onCardTap?.call(1, status: "Maintenance"),
                  ),
                ],
              ),
              KHeight,

              // EXPENSE CARD
              DashboardCard(
                title: "EXPENSE",
                totalValue: formatCurrency(summary.expense.total),
                icon: Icons.receipt_long,
                backgroundColor: const Color(0xFFE74C3C),
                items: [
                  DashboardCardItem(
                    label: "Paid",
                    value: formatCurrency(summary.expense.paid),
                    onTap: () => widget.onCardTap?.call(4),
                  ),
                  DashboardCardItem(
                    label: "Balance",
                    value: formatCurrency(summary.expense.pending),
                    onTap: () => widget.onCardTap?.call(4),
                  ),
                ],
              ),
              KHeight,

              // SALES CARD
              DashboardCard(
                title: "SALES",
                totalValue: formatCurrency(summary.sale.total),
                icon: Icons.volunteer_activism,
                backgroundColor: const Color(0xFF2ECC71),
                items: [
                  DashboardCardItem(
                    label: "Received",
                    value: formatCurrency(summary.sale.received),
                    onTap: () => widget.onCardTap?.call(2),
                  ),
                  DashboardCardItem(
                    label: "Balance",
                    value: formatCurrency(summary.sale.pending),
                    onTap: () => widget.onCardTap?.call(2),
                  ),
                ],
              ),
              KHeight,

              // PURCHASES CARD
              DashboardCard(
                title: "PURCHASES",
                totalValue: formatCurrency(summary.purchase.total),
                icon: Icons.shopping_cart,
                backgroundColor: const Color(0xFFF39C12),
                items: [
                  DashboardCardItem(
                    label: "Paid",
                    value: formatCurrency(summary.purchase.paid),
                    onTap: () => widget.onCardTap?.call(3),
                  ),
                  DashboardCardItem(
                    label: "Balance",
                    value: formatCurrency(summary.purchase.pending),
                    onTap: () => widget.onCardTap?.call(3),
                  ),
                ],
              ),
              KHeight,

              // PARTNERSHIP CARD
              DashboardCard(
                title: "PARTNERSHIP",
                totalValue: formatCurrency(summary.partnership.total),
                icon: Icons.handshake_sharp,
                backgroundColor: const Color(0xFF8FB30E).withOpacity(0.74),
                items: [
                  DashboardCardItem(
                    label: "Paid",
                    value: formatCurrency(summary.partnership.paid),
                    onTap: () => widget.onCardTap?.call(11),
                  ),
                  DashboardCardItem(
                    label: "Balance",
                    value: formatCurrency(summary.partnership.pending),
                    onTap: () => widget.onCardTap?.call(11),
                  ),
                ],
              ),
              KHeight,

              // FINANCE CARD
              DashboardCard(
                title: "FINANCE",
                totalValue: formatCurrency(summary.finance.total),
                icon: Icons.account_balance,
                backgroundColor: const Color(0xFF9B59B6),
                items: [
                  DashboardCardItem(
                    label: "Received",
                    value: formatCurrency(summary.finance.received),
                    onTap: () => widget.onCardTap?.call(10),
                  ),
                  DashboardCardItem(
                    label: "Balance",
                    value: formatCurrency(summary.finance.pending),
                    onTap: () => widget.onCardTap?.call(10),
                  ),
                ],
              ),
              KHeight,

              // Charts Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Financial Overview",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    KHeight,
                    // Pie Chart - Sales vs Purchases
                    SalesVsPurchasePieChart(
                      totalSalesReceived: summary.sale.received,
                      totalPurchasePaid: summary.purchase.paid,
                    ),
                    KHeight16,
                    // Daily Sales Chart (Line Chart)
                    _buildDailySalesChart(dailySummaries),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   Widget _buildDailySalesChart(List<DailySummary> summaries) {
    // Sort summaries by date to ensure correct plotting order
    summaries.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    List<FlSpot> spots = [];
    double maxYValue = 0;
    DateTime? firstDate;
    DateTime? lastDate;

    if (summaries.isNotEmpty) {
      firstDate = DateTime.parse(summaries.first.date);
      lastDate = DateTime.parse(summaries.last.date);
    }

    for (int i = 0; i < summaries.length; i++) {
      final summary = summaries[i];
      final currentSaleAmount = summary.saleReceived;
      final currentDate = DateTime.parse(summary.date);

      // Use the difference in days from the first date as the x-value
      // This ensures dates are correctly spaced on the X-axis
      final xValue = (currentDate.difference(firstDate!).inDays).toDouble();
      spots.add(FlSpot(xValue, currentSaleAmount)); // Use saleReceived for the Y-axis value
      if (currentSaleAmount > maxYValue) {
        maxYValue = currentSaleAmount;
      }
    }

    if (spots.isEmpty) {
      // If no data, display a default single point at 0,0 and set a sensible maxY
      spots.add(FlSpot(0, 0));
      maxYValue = 4; // Default max Y for an empty chart
      firstDate = DateTime.now();
      lastDate = DateTime.now();
    } else if (spots.length == 1) {
      // If only one data point, ensure the chart has a visible range
      maxYValue = spots.first.y == 0 ? 4 : spots.first.y * 2;
      firstDate = DateTime.parse(summaries.first.date);
      lastDate = firstDate.add(const Duration(days: 1)); // Extend to show a range
    } else {
      maxYValue = maxYValue * 1.2; // Add 20% padding to the max Y value
      if (maxYValue == 0) maxYValue = 4; // Ensure min Y if all sales are 0
    }

    // Determine min and max X values for the chart based on date differences
    final double minX = 0;
    final double maxX = (lastDate != null && firstDate != null)
        ? (lastDate.difference(firstDate).inDays).toDouble()
        : 1; // Ensure maxX is at least 1 for single point case

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Daily Sales (Last 30 Days)",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData:  FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 1,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: ((maxX / 6).ceilToDouble() > 0 ? (maxX / 6).ceilToDouble() : 1), // Aim for around 6 labels
                    getTitlesWidget: (value, meta) {
                      if (firstDate == null) return const SizedBox.shrink();

                      // Calculate the date for the current x-value
                      final date = firstDate.add(Duration(days: value.toInt()));
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8.0,
                        child: Text(
                          DateFormat('MM/dd').format(date), // Format as MM/dd
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: (maxYValue / 4).ceilToDouble() > 0 ? (maxYValue / 4).ceilToDouble() : 1,
                    getTitlesWidget: (value, meta) {
                      // Display currency symbol and K for thousands if needed
                      String text;
                      if (value >= 1000) {
                        text = '₹${(value / 1000).toStringAsFixed(0)}K';
                      } else {
                        text = '₹${value.toInt()}';
                      }
                      return Text(
                        text,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      );
                    },
                    reservedSize: 35, // Adjust reserved size for currency symbol
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
              ),
              minX: minX,
              maxX: maxX,
              minY: 0,
              maxY: maxYValue,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  color: Colors.red,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Colors.red,
                        strokeWidth: 1,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: false,
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.blueGrey,
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((LineBarSpot touchedSpot) {
                      if (firstDate == null) return null;

final date = firstDate.add(Duration(days: touchedSpot.x.toInt()));
                      // Find the actual DailySummary object for the date
                      final DailySummary? correspondingSummary = summaries.firstWhere(
                        (ds) => DateTime.parse(ds.date).day == date.day &&
                               DateTime.parse(ds.date).month == date.month &&
                               DateTime.parse(ds.date).year == date.year,
                        orElse: () => DailySummary( // Return a default summary if not found
                          date: DateFormat('yyyy-MM-dd').format(date),
                          expenseCount: 0, expenseAmount: 0, expensePaid: 0, expenseBalance: 0,
                          saleCount: 0, saleReceived: 0, salePending: 0,
                          purchaseCount: 0, purchasePaid: 0, purchasePending: 0,
                        ),
                      );

                      return LineTooltipItem(
'${DateFormat('MMM dd, yyyy').format(date)}\nSales: ₹${correspondingSummary?.saleReceived.toInt()}\nTransactions: ${correspondingSummary?.saleCount ?? 0}',                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 12,
                height: 2,
                color: Colors.red,
              ),
              const SizedBox(width: 4),
              const Text(
                "Sales",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // _getMaxValue is not directly used by this chart, but keeping it for completeness
  // if it's used elsewhere in your original code with a 'Summary' object.
  // If not needed, you can remove it.
  double _getMaxValue(List<DailySummary> summaries) {
    if (summaries.isEmpty) return 1.0;
    final values = summaries.map((s) => s.saleReceived).toList();
    return (values.reduce((a, b) => a > b ? a : b) * 1.1);
  }
}