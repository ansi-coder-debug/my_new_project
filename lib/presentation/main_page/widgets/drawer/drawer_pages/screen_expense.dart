import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/expense/expense_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/expense/add_expense_dialog.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class ScreenExpense extends ConsumerWidget {
  const ScreenExpense({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseState = ref.watch(expenseProvider);
    final expenses = expenseState.expenses;

    // appBar: AppBar(
    //   title: const Text('Expenses'),
    //   actions: [
    //     IconButton(
    //       icon: const Icon(Icons.add),
    //       onPressed: () {
    //         // Open your AddExpenseDialog as a dialog (like your AddAccountDialog)
    //         showDialog(
    //           context: context,
    //           builder: (_) => const AddExpenseDialog(),
    //         );
    //       },
    //     ),
    //   ],
    // ),
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "Expense",
              onBack: () {
                //last index wanna do at later
              },
              onFilter: () {
                // TODO: Open filter
              },
              onRefresh: () {
                ref.read(expenseProvider.notifier).loadExpenses();
              },
              onSearch: () {
                // TODO: Open search
              },
              showAdd: true,
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (_) => AddExpenseDialog(),
                );
              },
            ),
            KHeight,

            Expanded(
              child: expenseState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : expenses.isEmpty
                  ? const Center(child: Text("No expenses found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        final date = DateFormat('d/M/y').format(expense.date);

                       

                        // return Card(
                        //   color: Colors.white,
                        //   elevation: 2,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        //   margin: const EdgeInsets.only(bottom: 16),
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(16),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Expanded(
                        //               child: Text(
                        //                 expense.expenseTypeName?.toUpperCase() ?? "UNKNOWN",
                        //                 style: const TextStyle(
                        //                   fontWeight: FontWeight.bold,
                        //                   fontSize: 16,
                        //                   color: Color(0xFF1B1B3A),
                        //                 ),
                        //               ),
                        //             ),
                        //             Text(
                        //               expense.amount.toStringAsFixed(2),
                        //               style: const TextStyle(
                        //                 fontWeight: FontWeight.bold,
                        //                 fontSize: 16,
                        //               ),
                        //             ),
                        //             PopupMenuButton<String>(
                        //               onSelected: (value) {
                        //                 // TODO: Add edit/delete functionality
                        //               },
                        //               itemBuilder: (context) => const [
                        //                 PopupMenuItem(value: 'edit', child: Text('Edit')),
                        //                 PopupMenuItem(value: 'delete', child: Text('Delete')),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //         const SizedBox(height: 8),
                        //         Text(
                        //           expense.accountName ?? 'No Account',
                        //           style: TextStyle(color: Colors.grey[700]),
                        //         ),
                        //         Text(
                        //           "${expense.paymentStatus} - $date",
                        //           style: TextStyle(color: Colors.grey[600]),
                        //         ),
                        //         const SizedBox(height: 8),
                        //         Text(
                        //           "Paid: ${expense.expensePaid.toStringAsFixed(2)}",
                        //           style: const TextStyle(
                        //             color: Colors.green,
                        //             fontWeight: FontWeight.w600,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // );
                        return OutputCard(
                              title: expense.expenseTypeName?.toUpperCase() ?? "UNKNOWN",
                              subtitle: 
                              "${expense.accountName ?? "No Account"} - ${expense.paymentStatus} - $date",
                              amount: expense.amount,
                              received: expense.expensePaid,
                              receivedLabel:'Paid' ,
                              showMenu: true,
                             
                              onView: () {
                                debugPrint("Viewing ${expense.expenseTypeName}");
                              },
                              onEdit: () {
                                debugPrint("Editing ${expense.expenseTypeName}");
                              },
                              onDelete: () {
                                debugPrint("Deleting ${expense.expenseTypeName}");
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
