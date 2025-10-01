import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/cashbook/cashbook_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/cashbook.dart';
import 'package:my_new_project/widgets/cashbook/add_cashbook_dialog.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';
// Import your AddCashBookEntryDialog here

class ScreenCashbook extends ConsumerWidget {
  const ScreenCashbook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("Raw cashbook entry JSON: ${json.toString()}");

    final cashBookState = ref.watch(cashBookProvider);
    final entries = cashBookState.entries;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "Cash Book",
              onBack: () {
                //last index wanna do at later
              },
              onFilter: () {
                // TODO: Open filter
              },
              onRefresh: () {
                ref.read(cashBookProvider.notifier).loadCashBookEntries();
              },
              onSearch: () {
                // TODO: Open search
              },
              showAdd: true,
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (_) => AddCashBookDialog(),
                );
              },
            ),
            KHeight,

            Expanded(
              child: cashBookState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : entries.isEmpty
                  ? const Center(child: Text('No cashbook entries found'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];

                        return OutputCard(
                          title: entry.accountName ?? entry.accountId,
                          subtitle: entry.vehicle != null
                              ? 'Expense Of: ${entry.vehicle!.name}'
                              : '',

                          phone: entry.vehicle?.regNo ?? '',

                          amount:
                              (entry.debit ?? entry.credit ?? 0) *
                              (entry.debit != null ? -1 : 1),
                              isCashBook: true,
                          onView: () {
                            // TODO: Handle view
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

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
