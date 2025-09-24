// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:my_new_project/application/monthlysummary/monthlysummary_provider.dart';
// import 'package:my_new_project/core/models/monthlysummary.dart';

// class ScreenMonthlySummary extends ConsumerStatefulWidget {
//   const ScreenMonthlySummary({super.key});

//   @override
//   ConsumerState<ScreenMonthlySummary> createState() => _ScreenMonthlySummaryState();
// }

// class _ScreenMonthlySummaryState extends ConsumerState<ScreenMonthlySummary> {
//   String selectedTab = 'sales'; // sales, purchases, expenses

//   @override
//   Widget build(BuildContext context) {
//     final monthlySummaryState = ref.watch(monthlySummaryProvider);
//     final summaries = monthlySummaryState.summaries;

//     return Scaffold(

//       appBar: AppBar(
//         title: const Text('Monthly Reports'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list),
//             onPressed: () {
//               // Implement filter action
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               ref.read(monthlySummaryProvider.notifier).loadMonthlySummaries();
//             },
//           ),
//         ],
//       ),

//       body: Column(
//         children: [
//           // Tabs for Sales / Purchases / Expenses
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
//             child: monthlySummaryState.isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : summaries.isEmpty
//                     ? const Center(child: Text('No reports found'))
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
//           side: BorderSide(color: Colors.black),
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

//   Widget _buildSummaryCard(MonthlySummary summary) {
//     // Depending on selectedTab, show relevant data
//     String title = '${summary.month} ${summary.year}';
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
//         balanceLabel = 'Balance';
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

//     // Currency format - simple version
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

//             // Received / Paid
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

//             // Balance / Pending
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
import 'package:my_new_project/application/monthlysummary/monthlysummary_provider.dart';
import 'package:my_new_project/core/models/monthlysummary.dart';

class ScreenMonthlySummary extends ConsumerStatefulWidget {
  const ScreenMonthlySummary({super.key});

  @override
  ConsumerState<ScreenMonthlySummary> createState() => _ScreenMonthlySummaryState();
}

class _ScreenMonthlySummaryState extends ConsumerState<ScreenMonthlySummary> {
  String selectedTab = 'sales'; // sales, purchases, expenses

  @override
  Widget build(BuildContext context) {
    final monthlySummaryState = ref.watch(monthlySummaryProvider);
    final summaries = monthlySummaryState.summaries;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Custom Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Square Back Button
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, size: 18),
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
                  const SizedBox(width: 12),
                  const Text(
                    'Monthly Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B1B3A),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Second Row: Tabs + Filter/Refresh
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Tabs
                  _buildTabButton('Sales'),
                  const SizedBox(width: 6),
                  _buildTabButton('Purchases'),
                  const SizedBox(width: 8),
                  _buildTabButton('Expenses'),

                  const Spacer(),

                  // Filter Button
                  _buildIconButton(Icons.filter_alt_outlined, () {
                    // TODO: Filter action
                  }),

                  // Refresh Button
                  _buildIconButton(Icons.refresh, () {
                    ref.read(monthlySummaryProvider.notifier).loadMonthlySummaries();
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Summary List
            Expanded(
              child: monthlySummaryState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : summaries.isEmpty
                      ? const Center(child: Text('No reports found'))
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

  /// 🔸 Reusable Tab Button
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


  /// 🔸 Reusable Icon Button (Square style)
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

  /// 🔸 Summary Card Builder
  Widget _buildSummaryCard(MonthlySummary summary) {
    final title = '${summary.month} ${summary.year}';
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
        balanceLabel = 'Balance';
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

            // Paid / Received
            Row(
              children: [
                Text('$paidLabel: ', style: const TextStyle(color: Colors.green)),
                Text(formatCurrency(paidAmount), style: const TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 4),

            // Balance / Pending
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
