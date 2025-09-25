// lib/presentation/financiers/screen_financiers.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/financier/financier_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/financier.dart';
import 'package:my_new_project/widgets/financier/add_financier_dialog.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';

class ScreenFinanciers extends ConsumerWidget {
  const ScreenFinanciers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financierState = ref.watch(financierProvider);
    final financiers = financierState.financiers;

   
      // appBar: AppBar(
      //   title: const Text('Financiers'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.add),
      //       onPressed: () {
      //         showDialog(
      //           context: context,
      //           builder: (_) => const AddFinancierDialog(),
      //         );
      //       },
      //     ),
      //   ],
      // ),

     return Scaffold(
      body:SafeArea(
        child:Column(
          children: [
            CustomHeader(
              title:"Financiers",
              onBack: () {
                // Optional back action
              },
               onFilter: () {
                // TODO: Open filter
              },
              onRefresh: () {
                ref.read(financierProvider.notifier).loadFinanciers();
              },
              onSearch: () {
                // TODO: Open search
              },
              showAdd: true,
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (_) => const AddFinancierDialog(),
                );
              },
               ),
               KHeight,
      
      Expanded(
        child:
      financierState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : financiers.isEmpty
          ? const Center(child: Text("No financiers found"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: financiers.length,
              itemBuilder: (context, index) {
                final financier = financiers[index];

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
                        // Title + Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                financier.companyName,
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
                                  // TODO: Show edit dialog
                                } else if (value == 'delete') {
                                  _confirmDelete(context, ref, financier);
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
                          "Contact Person: ${financier.contactPerson}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Text(
                          "Phone: ${financier.contactNumber}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Text(
                          financier.address.trim().isNotEmpty
                              ? financier.address
                              : "No address",
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

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Financier financier,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text(
          'Are you sure you want to delete ${financier.companyName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (financier.id != null) {
        await ref
            .read(financierProvider.notifier)
            .deleteFinancier(financier.id!);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Financier deleted')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Financier ID is missing. Cannot delete.'),
          ),
        );
      }
    }
  }
}
