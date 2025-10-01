import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/monthlysummary/monthlysummary_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/monthlysummary.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class ScreenMonthlySummary extends ConsumerStatefulWidget {
  const ScreenMonthlySummary({super.key});

  @override
  ConsumerState<ScreenMonthlySummary> createState() => _ScreenMonthlySummaryState();
}

class _ScreenMonthlySummaryState extends ConsumerState<ScreenMonthlySummary> {
  String selectedTab = 'sales';

  @override
  Widget build(BuildContext context) {
    final monthlySummaryState = ref.watch(monthlySummaryProvider);
    final summaries = monthlySummaryState.summaries;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Reuse your CustomHeader exactly like Cashbook
            CustomHeader(
              title: 'Monthly Summary',
              onBack: () => Navigator.pop(context),
              // We can reuse customActions if needed
              customActions: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    _buildIconButton(Icons.filter_alt_outlined, () {
                      // TODO: Open filters
                    }),
                    _buildIconButton(Icons.refresh, () {
                      ref.read(monthlySummaryProvider.notifier).loadMonthlySummaries();
                    }),
                  ],
                ),
              ),
            ),

            // Tabs like Cashbook has buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTabButton('Sales'),
                  const SizedBox(width: 6),
                  _buildTabButton('Purchases'),
                  const SizedBox(width: 6),
                  _buildTabButton('Expenses'),
                ],
              ),
            ),

            KHeight16,

            Expanded(
              child: monthlySummaryState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : summaries.isEmpty
                      ? const Center(child: Text('No monthly reports found'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: summaries.length,
                          itemBuilder: (context, index) {
                            final summary = summaries[index];
                            return _buildOutputCard(summary);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildOutputCard(MonthlySummary summary) {
    // Parse month-year string like "YYYY-MM" safely
    DateTime date;
    try {
      date = DateTime.parse('${summary.month}-01');
    } catch (_) {
      date = DateTime.now();
    }

    final title = '${_monthName(date.month)} ${date.year}';

    // Map data based on selectedTab
    String subtitle = '';
    double amount = 0;
    double? received;
    double? balance;
    String receivedLabel = 'Received';
    Color? receivedLabelColor = Colors.green;
    bool showBalanceBelowPaid = true;

    switch (selectedTab) {
      case 'sales':
        subtitle = 'Sales Count: ${summary.saleCount}';
        amount = summary.saleReceived + summary.salePending;
        received = summary.saleReceived;
        balance = summary.salePending;
        receivedLabel = 'Received';
        break;
      case 'purchases':
        subtitle = 'Purchases Count: ${summary.purchaseCount}';
        amount = summary.purchasePaid + summary.purchasePending;
        received = summary.purchasePaid;
        balance = summary.purchasePending;
        receivedLabel = 'Paid';
        break;
      case 'expenses':
        subtitle = 'Expenses Count: ${summary.expenseCount}';
        amount = summary.expenseAmount;
        received = summary.expensePaid;
        balance = summary.expenseBalance;
        receivedLabel = 'Paid';
        break;
    }

    return OutputCard(
      title: title,
      subtitle: subtitle,
      amount: amount,
      received: received,
      balance: balance,
      receivedLabel: receivedLabel,
      receivedLabelColor: receivedLabelColor,
      showBalanceBelowPaid: showBalanceBelowPaid,
      showMenu: false,
      onView: () {
        // TODO: Implement detail view if needed
      },
    );
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
