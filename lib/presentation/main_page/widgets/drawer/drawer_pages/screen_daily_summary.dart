// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_new_project/application/dailysummary/dailysummary_provider.dart';
// import 'package:my_new_project/core/models/dailysummary.dart';

// class ScreenDailySummary extends ConsumerStatefulWidget {
//   const ScreenDailySummary({super.key});

//   @override
//   ConsumerState<ScreenDailySummary> createState() => _ScreenDailySummaryState();
// }

// class _ScreenDailySummaryState extends ConsumerState<ScreenDailySummary> {
//   String selectedTab = 'sales'; // sales, purchases, expenses

//   @override
//   Widget build(BuildContext context) {
//     final dailySummaryState = ref.watch(dailySummaryProvider);
//     final summaries = dailySummaryState.summaries;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Daily Reports'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list),
//             onPressed: () {
//               // TODO: Implement filters
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               ref.read(dailySummaryProvider.notifier).loadDailySummaries();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildTabButton('Sales'),
//                 _buildTabButton('Purchases'),
//                 _buildTabButton('Expenses'),
//               ],
//             ),
//           ),
//           Expanded(
//             child: dailySummaryState.isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : summaries.isEmpty
//                     ? const Center(child: Text('No daily reports found'))
//                     : ListView.builder(
//                         padding: const EdgeInsets.all(12),
//                         itemCount: summaries.length,
//                         itemBuilder: (context, index) {
//                           final summary = summaries[index];
//                           return _buildSummaryCard(summary);
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabButton(String tabName) {
//     final isSelected = selectedTab == tabName.toLowerCase();
//     return Expanded(
//       child: OutlinedButton(
//         style: OutlinedButton.styleFrom(
//           backgroundColor: isSelected ? Colors.black : Colors.transparent,
//           foregroundColor: isSelected ? Colors.white : Colors.black,
//           side: const BorderSide(color: Colors.black),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         ),
//         onPressed: () {
//           setState(() {
//             selectedTab = tabName.toLowerCase();
//           });
//         },
//         child: Text(tabName),
//       ),
//     );
//   }

//   Widget _buildSummaryCard(DailySummary summary) {
//     // Format date (e.g., 2025-09-21 → 21 Sep 2025)
//     final date = DateTime.parse(summary.date);
//     final title = '${date.day}-${date.month}-${date.year}';

//     String countText = '';
//     double amount = 0;
//     String receivedOrPaidLabel = '';
//     double receivedOrPaidAmount = 0;
//     String balanceLabel = '';
//     double balanceAmount = 0;

//     switch (selectedTab) {
//       case 'sales':
//         countText = 'Sales: ${summary.saleCount}';
//         amount = summary.saleReceived + summary.salePending;
//         receivedOrPaidLabel = 'Received';
//         receivedOrPaidAmount = summary.saleReceived;
//         balanceLabel = 'Pending';
//         balanceAmount = summary.salePending;
//         break;

//       case 'purchases':
//         countText = 'Purchases: ${summary.purchaseCount}';
//         amount = summary.purchasePaid + summary.purchasePending;
//         receivedOrPaidLabel = 'Paid';
//         receivedOrPaidAmount = summary.purchasePaid;
//         balanceLabel = 'Pending';
//         balanceAmount = summary.purchasePending;
//         break;

//       case 'expenses':
//         countText = 'Expenses: ${summary.expenseCount}';
//         amount = summary.expenseAmount;
//         receivedOrPaidLabel = 'Paid';
//         receivedOrPaidAmount = summary.expensePaid;
//         balanceLabel = 'Balance';
//         balanceAmount = summary.expenseBalance;
//         break;
//     }

//     String formatCurrency(double val) => '₹${val.toStringAsFixed(2)}';

//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               formatCurrency(amount),
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               countText,
//               style: const TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//             const SizedBox(height: 6),
//             Row(
//               children: [
//                 Text(
//                   '$receivedOrPaidLabel: ',
//                   style: const TextStyle(fontSize: 14, color: Colors.green),
//                 ),
//                 Text(
//                   formatCurrency(receivedOrPaidAmount),
//                   style: const TextStyle(fontSize: 14, color: Colors.green),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 Text(
//                   '$balanceLabel: ',
//                   style: const TextStyle(fontSize: 14, color: Colors.red),
//                 ),
//                 Text(
//                   formatCurrency(balanceAmount),
//                   style: const TextStyle(fontSize: 14, color: Colors.red),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/dailysummary/dailysummary_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/dailysummary.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart'; // Assuming you use this

class ScreenDailySummary extends ConsumerStatefulWidget {
  const ScreenDailySummary({super.key});

  @override
  ConsumerState<ScreenDailySummary> createState() => _ScreenDailySummaryState();
}

class _ScreenDailySummaryState extends ConsumerState<ScreenDailySummary> {
  String selectedTab = 'sales';

  @override
  Widget build(BuildContext context) {
    final dailySummaryState = ref.watch(dailySummaryProvider);
    final summaries = dailySummaryState.summaries;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 Custom Header
            CustomHeader(
              title: 'Daily Summary',
              onBack: () => Navigator.pop(context),
              onRefresh: () {
                ref.read(dailySummaryProvider.notifier).loadDailySummaries();
              },
              onFilter: () {
                // TODO: Open filter dialog
              },
              customActions: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    _buildIconButton(Icons.filter_alt_outlined, () {
                      // TODO: Open filters
                    }),
                    _buildIconButton(Icons.refresh, () {
                      ref.read(dailySummaryProvider.notifier).loadDailySummaries();
                    }),
                  ],
                ),
              ),
            ),

            /// 🔹 Tabs
           // 🔹 Tabs + Actions in One Row
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Row(
    children: [
      // Tabs
      _buildTabButton('Sales'),
      const SizedBox(width: 6),
      _buildTabButton('Purchases'),
      const SizedBox(width: 6),
      _buildTabButton('Expenses'),

      const Spacer(),

      // Filter + Refresh Buttons
      _buildIconButton(Icons.filter_alt_outlined, () {
        // TODO: Open filters
      }),
      _buildIconButton(Icons.refresh, () {
        ref.read(dailySummaryProvider.notifier).loadDailySummaries();
      }),
    ],
  ),
),


           KHeight16,

            /// 🔹 Summary List
            Expanded(
              child: dailySummaryState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : summaries.isEmpty
                      ? const Center(child: Text('No daily reports found'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: summaries.length,
                          itemBuilder: (context, index) {
                            final summary = summaries[index];
                            return _buildSummaryCard(summary);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔸 Tab Buttons
  Widget _buildTabButton(String tabName) {
    final isSelected = selectedTab == tabName.toLowerCase();

    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            selectedTab = tabName.toLowerCase();
          });
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Colors.black : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(color: Colors.grey.shade300),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          tabName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// 🔸 Square Icon Button
  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: SizedBox(
        width: 36,
        height: 36,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  /// 🔸 Summary Card
  Widget _buildSummaryCard(DailySummary summary) {
    final date = DateTime.parse(summary.date);
    final title = '${date.day}-${date.month}-${date.year}';

    String countText = '';
    double totalAmount = 0;
    String paidLabel = '';
    double paidAmount = 0;
    String balanceLabel = '';
    double balanceAmount = 0;

    switch (selectedTab) {
      case 'sales':
        countText = 'Sales: ${summary.saleCount}';
        totalAmount = summary.saleReceived + summary.salePending;
        paidLabel = 'Received';
        paidAmount = summary.saleReceived;
        balanceLabel = 'Pending';
        balanceAmount = summary.salePending;
        break;

      case 'purchases':
        countText = 'Purchases: ${summary.purchaseCount}';
        totalAmount = summary.purchasePaid + summary.purchasePending;
        paidLabel = 'Paid';
        paidAmount = summary.purchasePaid;
        balanceLabel = 'Pending';
        balanceAmount = summary.purchasePending;
        break;

      case 'expenses':
        countText = 'Expenses: ${summary.expenseCount}';
        totalAmount = summary.expenseAmount;
        paidLabel = 'Paid';
        paidAmount = summary.expensePaid;
        balanceLabel = 'Balance';
        balanceAmount = summary.expenseBalance;
        break;
    }

    String formatCurrency(double val) => '₹${val.toStringAsFixed(2)}';

    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(formatCurrency(totalAmount),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(countText, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 6),

            Row(
              children: [
                Text('$paidLabel: ', style: const TextStyle(color: Colors.green)),
                Text(formatCurrency(paidAmount), style: const TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('$balanceLabel: ', style: const TextStyle(color: Colors.red)),
                Text(formatCurrency(balanceAmount), style: const TextStyle(color: Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

