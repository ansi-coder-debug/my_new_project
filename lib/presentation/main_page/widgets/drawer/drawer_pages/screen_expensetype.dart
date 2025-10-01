import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/expensetype/expensetype_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';

import 'package:my_new_project/widgets/expensetype/add_expensetype_dialog.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class ScreenExpenseTypes extends ConsumerWidget {
  const ScreenExpenseTypes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseTypeState = ref.watch(expenseTypeProvider);
    final expenseTypes = expenseTypeState.expenseTypes;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "Expense Types",
              onBack: () {
                //last index wanna do at later
              },
              onFilter: () {
                // TODO: Open filter
              },
              onRefresh: () {
                ref.read(expenseTypeProvider.notifier).loadExpenseTypes();
              },
              onSearch: () {
                // TODO: Open search
              },
              showAdd: true,
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (_) => AddExpenseTypeDialog(),
                );
              },
            ),
            KHeight,

            Expanded(
              child: expenseTypeState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : expenseTypes.isEmpty
                  ? const Center(child: Text("No expense types found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: expenseTypes.length,
                      itemBuilder: (context, index) {
                        final type = expenseTypes[index];

                        return OutputCard(
                          title: type.name.toUpperCase(),
                          subtitle: '', // you can add description if exists
                          amount:0 , // no amount here, so keep 0
                          received: 0, // no received amount here
                          receivedLabel: '',
                          showMenu: true,
                          onView: () {
                            // You can show a dialog or navigate to a detail screen
                          },
                          onEdit: () {
                            //////
                          },
                          onDelete: () {
                            //
                          },
                          showAmount: false,
                          titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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




                    // return Card(
                    //   color: Colors.white,
                    //   elevation: 3,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   margin: const EdgeInsets.only(bottom: 16),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(16),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Expanded(
                    //           child: Text(
                    //             type.name.toUpperCase(),
                    //             style: const TextStyle(
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 16,
                    //               color: Color(0xFF1B1B3A),
                    //             ),
                    //           ),
                    //         ),
                    //         PopupMenuButton<String>(
                    //           onSelected: (value) async {
                    //             if (value == 'edit') {
                    //               // TODO: Add edit dialog
                    //             } else if (value == 'delete') {
                    //               final confirm = await showDialog<bool>(
                    //                 context: context,
                    //                 builder: (context) => AlertDialog(
                    //                   title: const Text('Confirm Delete'),
                    //                   content: Text('Delete "${type.name}"?'),
                    //                   actions: [
                    //                     TextButton(
                    //                       onPressed: () => Navigator.pop(context, false),
                    //                       child: const Text('Cancel'),
                    //                     ),
                    //                     ElevatedButton(
                    //                       onPressed: () => Navigator.pop(context, true),
                    //                       child: const Text('Delete'),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               );

                    //               if (confirm == true) {
                    //                 try {
                    //                   await ref
                    //                       .read(expenseTypeProvider.notifier)
                    //                       .deleteExpenseType(type.id!);
                    //                   ScaffoldMessenger.of(context).showSnackBar(
                    //                     const SnackBar(content: Text("Deleted successfully")),
                    //                   );
                    //                 } catch (e) {
                    //                   ScaffoldMessenger.of(context).showSnackBar(
                    //                     SnackBar(content: Text("Error deleting: $e")),
                    //                   );
                    //                 }
                    //               }
                    //             }
                    //           },
                    //           itemBuilder: (context) => const [
                    //             PopupMenuItem(value: 'edit', child: Text('Edit')),
                    //             PopupMenuItem(value: 'delete', child: Text('Delete')),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // );


