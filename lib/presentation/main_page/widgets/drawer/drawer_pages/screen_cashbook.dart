import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/cashbook/cashbook_provider.dart';
import 'package:my_new_project/core/models/cashbook.dart';
import 'package:my_new_project/widgets/cashbook/add_cashbook_dialog.dart';
// Import your AddCashBookEntryDialog here

class  ScreenCashbook extends ConsumerWidget {
  const  ScreenCashbook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cashBookState = ref.watch(cashBookProvider);
    final entries = cashBookState.entries;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash Book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Show a dialog to add new cashbook entry
              showDialog(
                context: context,
                builder: (_) => const AddCashBookDialog(),
              );
            },
          )
        ],
      ),
      body: cashBookState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : entries.isEmpty
              ? const Center(child: Text('No cashbook entries found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];

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
                            // Account name + menu
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.accountName?.toUpperCase() ?? entry.accountId,
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
                                      // TODO: implement edit
                                    } else if (value == 'delete') {
                                      // TODO: implement delete
                                    }
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            Text(
                              "Transaction: ${capitalize(entry.transactionType)}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 6),

                            Text(
                              entry.description?.trim().isNotEmpty == true
                                  ? entry.description!
                                  : "No description",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'Debit: ${entry.debit?.toStringAsFixed(2) ?? '-'} | Credit: ${entry.credit?.toStringAsFixed(2) ?? '-'}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'Date: ${entry.createdAt != null ? formatDate(entry.createdAt!) : 'Unknown'}',
                              style: const TextStyle(
                                fontSize: 12,
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

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
