import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/widgets/accounts/add_account_dialog.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class ScreenAccounts extends ConsumerWidget {
  const ScreenAccounts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(accountProvider);
    final accounts = accountState.accounts;
    print('👀 Accounts in UI: ${accounts.map((a) => a.name).toList()}');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "Accounts",
              onBack: () {
                //last index wanna do at later
              },
              showAdd: true,
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (_) => AddAccountDialog(),
                );
              },
            ),
            KHeight,

            Expanded(
              child: accountState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : accounts.isEmpty
                  ? const Center(child: Text("No accounts found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        final account = accounts[index];

                        return OutputCard(
                          title: account.name,
                          subtitle: "Type: ${capitalize(account.type)}",
                          phone:
                              (account.description != null &&
                                  account.description!.trim().isNotEmpty)
                              ? account.description
                              : "No description",

                          showAmount: false,
                          onView: () {},
                          onEdit: () {},
                          onDelete: () {},
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
}


/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/widgets/accounts/add_account_dialog.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';

class ScreenAccounts extends ConsumerWidget {
  const ScreenAccounts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(accountProvider);
    final accounts = accountState.accounts;
    print('👀 Accounts in UI: ${accounts.map((a) => a.name).toList()}');

    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "Accounts",
              onBack: () {
                //last index wanna do at later
              },
              showAdd: true,
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (_) => AddAccountDialog(),
                );
              },
            ),
            KHeight,

            Expanded(
              child: accountState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : accounts.isEmpty
                  ? const Center(child: Text("No accounts found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        final account = accounts[index];

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
                                // Name + Menu
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        account.name.toUpperCase(),
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
                                          // TODO: Edit
                                        } else if (value == 'delete') {
                                          // TODO: Delete
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

                                Text(
                                  "Type: ${capitalize(account.type)}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                Text(
                                  account.description?.trim().isNotEmpty == true
                                      ? account.description!
                                      : "No description",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
}
*/