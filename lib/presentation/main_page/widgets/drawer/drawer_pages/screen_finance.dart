import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/application/finance/finance_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/finance.dart';
import 'package:my_new_project/widgets/finance/finance_dialog.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class ScreenFinance extends ConsumerWidget {
  const ScreenFinance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(financeProvider);
    final List<Finance> finances = state.finances;
    final account = ref.watch(accountProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: 'Finance',
              onFilter: () {
                // TODO: Open filter dialog
              },
              onRefresh: () {
                ref.read(financeProvider.notifier).loadFinances();
              },
              onSearch: () {
                // TODO: Implement search
              },
              showAdd: false,
            ),
            KHeight,
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : finances.isEmpty
                  ? const Center(child: Text('No finance records found.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: finances.length,
                      itemBuilder: (context, index) {
                        final finance = finances[index];
                        final vehicleName =
                            finance.vehicle?.name ?? 'Unknown Vehicle';
                        final financierName =
                            finance.financier?.companyName ??
                            'Unknown Financier';
                        final amount = finance.amount;
                        final received = finance.receivedPrice;
                        final paymentMode = finance.toAccount ?? 'Unknown';
                        final status = finance.paymentStatus ?? 'unknown';

                        return OutputCard(
                          title: vehicleName.toUpperCase(),
                          subtitle: financierName,
                          amount: amount,
                          received: received,
                          balance: null,
                          receivedLabel: 'Received',
                          // paymentMode: paymentMode,
                          status: status,
                          receivedLabelColor: Colors.green,
                          showBalanceBelowPaid: true,
                          showMenu: true,
                       onView: () {
  showDialog(
    context: context,
    builder: (context) => AddFinanceDialog(
      finance: finance,         // pass current finance data
      isViewOnly: true,         // makes fields readonly
    ),
  );
},

onEdit: () {
  showDialog(
    context: context,
    builder: (context) => AddFinanceDialog(
      finance: finance,         // pass current finance data
      isViewOnly: false,        // allows editing
    ),
  );
},

onDelete: () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text('Are you sure you want to delete this finance entry?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    // Access your provider and call delete
    final notifier = ref.read(financeProvider.notifier);
    await notifier.deleteFinance(finance.id); // or whatever your delete method is

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Finance deleted')),
    );
  }
},

                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}




/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/finance/finance_provider.dart';
import 'package:my_new_project/core/models/finance.dart';
import 'package:my_new_project/core/models/vehicle.dart'; // if you have vehicle in finance

class ScreenFinance extends ConsumerWidget {
  const ScreenFinance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(financeProvider);

    final List<Finance> finances = state.finances;
    print('🧾 UI received finances: ${finances.length}');

    return Scaffold(
      appBar: AppBar(title: const Text('Finance')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : finances.isEmpty
          ? const Center(child: Text('No finance records found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: finances.length,
              itemBuilder: (context, index) {
                final finance = finances[index];

                final vehicleName = finance.vehicle?.make ?? 'Unknown Vehicle';
                final financierName =
                    finance.financier?.companyName ?? 'Unknown Financier';
                final amount = finance.amount;
                final received = finance.receivedPrice;
                final paymentMode = finance.toAccount;
                final status = finance.paymentStatus;

                return Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vehicle name + menu
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                vehicleName.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF1B1B3A),
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  // TODO: Handle edit
                                } else if (value == 'delete') {
                                  // TODO: Handle delete
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Financier company name
                        Text(
                          financierName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Payment mode
                        Text(
                          'Paid via: $paymentMode',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Amount
                        Text(
                          amount.toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Received amount
                        Text(
                          'Received: $received',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Status
                        Text(
                          'Status: $status',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
*/