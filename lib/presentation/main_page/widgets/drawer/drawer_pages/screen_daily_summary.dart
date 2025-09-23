import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/dailysummary/dailysummary_provider.dart';
import 'package:my_new_project/core/models/dailysummary.dart';

class ScreenDailySummary extends ConsumerStatefulWidget {
  const ScreenDailySummary({super.key});

  @override
  ConsumerState<ScreenDailySummary> createState() => _ScreenDailySummaryState();
}

class _ScreenDailySummaryState extends ConsumerState<ScreenDailySummary> {
  String selectedTab = 'sales'; // sales, purchases, expenses

  @override
  Widget build(BuildContext context) {
    final dailySummaryState = ref.watch(dailySummaryProvider);
    final summaries = dailySummaryState.summaries;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Reports'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filters
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(dailySummaryProvider.notifier).loadDailySummaries();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton('Sales'),
                _buildTabButton('Purchases'),
                _buildTabButton('Expenses'),
              ],
            ),
          ),
          Expanded(
            child: dailySummaryState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : summaries.isEmpty
                    ? const Center(child: Text('No daily reports found'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: summaries.length,
                        itemBuilder: (context, index) {
                          final summary = summaries[index];
                          return _buildSummaryCard(summary);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tabName) {
    final isSelected = selectedTab == tabName.toLowerCase();
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Colors.black : Colors.transparent,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {
          setState(() {
            selectedTab = tabName.toLowerCase();
          });
        },
        child: Text(tabName),
      ),
    );
  }

  Widget _buildSummaryCard(DailySummary summary) {
    // Format date (e.g., 2025-09-21 → 21 Sep 2025)
    final date = DateTime.parse(summary.date);
    final title = '${date.day}-${date.month}-${date.year}';

    String countText = '';
    double amount = 0;
    String receivedOrPaidLabel = '';
    double receivedOrPaidAmount = 0;
    String balanceLabel = '';
    double balanceAmount = 0;

    switch (selectedTab) {
      case 'sales':
        countText = 'Sales: ${summary.saleCount}';
        amount = summary.saleReceived + summary.salePending;
        receivedOrPaidLabel = 'Received';
        receivedOrPaidAmount = summary.saleReceived;
        balanceLabel = 'Pending';
        balanceAmount = summary.salePending;
        break;

      case 'purchases':
        countText = 'Purchases: ${summary.purchaseCount}';
        amount = summary.purchasePaid + summary.purchasePending;
        receivedOrPaidLabel = 'Paid';
        receivedOrPaidAmount = summary.purchasePaid;
        balanceLabel = 'Pending';
        balanceAmount = summary.purchasePending;
        break;

      case 'expenses':
        countText = 'Expenses: ${summary.expenseCount}';
        amount = summary.expenseAmount;
        receivedOrPaidLabel = 'Paid';
        receivedOrPaidAmount = summary.expensePaid;
        balanceLabel = 'Balance';
        balanceAmount = summary.expenseBalance;
        break;
    }

    String formatCurrency(double val) => '₹${val.toStringAsFixed(2)}';

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              formatCurrency(amount),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              countText,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '$receivedOrPaidLabel: ',
                  style: const TextStyle(fontSize: 14, color: Colors.green),
                ),
                Text(
                  formatCurrency(receivedOrPaidAmount),
                  style: const TextStyle(fontSize: 14, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '$balanceLabel: ',
                  style: const TextStyle(fontSize: 14, color: Colors.red),
                ),
                Text(
                  formatCurrency(balanceAmount),
                  style: const TextStyle(fontSize: 14, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
