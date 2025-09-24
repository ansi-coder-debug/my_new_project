// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:intl/intl.dart';
// // import 'package:my_new_project/application/expense/expense_provider.dart';
// // import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
// // import 'package:my_new_project/widgets/expense/add_expense_dialog.dart';
// // // Import your vehicle provider

// // class ScreenExpense extends ConsumerStatefulWidget {
// //   const ScreenExpense({super.key});

// //   @override
// //   ConsumerState<ScreenExpense> createState() => _ScreenExpenseState();

  
// // }

// // class _ScreenExpenseState extends ConsumerState<ScreenExpense> {

// //   @override
// //   void initState() {
// //     super.initState();

// //     // Fetch expenses from API when screen opens
// //     Future.microtask(() {
// //       ref.read(expenseProvider.notifier).fetchExpenses();
// //     });
// //   }

  


// // @override
// //   Widget build(BuildContext context) {
// //     final vehicleState = ref.watch(vehicleProvider);
// //     final vehicles = vehicleState.vehicles;

// //     final expenseState = ref.watch(expenseProvider);
// //     final expenses = expenseState.expenses;

// //     return Scaffold(
// //       body: 
// //       expenses.isEmpty
// //     ? Center(
// //         child: Text(
// //           'No expense record found',
// //           style: TextStyle(fontSize: 18, color: Colors.black),
// //         ),
// //       ):
// //           ListView.builder(
// //               padding: const EdgeInsets.all(12),
// //               itemCount: expenses.length,
// //               itemBuilder: (context, index) {
// //                 final expense = expenses[index];
               
// //                 final vehicle = vehicles.where((v) => v.id == expense.vehicleId).isNotEmpty
// //     ? vehicles.firstWhere((v) => v.id == expense.vehicleId)
// //     : null;


// //                 return Card(
// //   elevation: 2,
// //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //   margin: const EdgeInsets.symmetric(vertical: 8),
// //   color: Colors.white, // Ensure white background
// //   child: Padding(
// //     padding: const EdgeInsets.all(16),
// //     child: Row(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         // Left side: Expense info
// //         Expanded(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 expense.type.toUpperCase(),
// //                 style: const TextStyle(
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: 16,
// //                 ),
// //               ),
// //               const SizedBox(height: 4),
// //               if (vehicle != null)
// //                 Text(
// //                   "${vehicle.make} ${vehicle.model}",
// //                   style: const TextStyle(
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                 ),
// //               const SizedBox(height: 4),
// //               Text(
// //                 "Paid via: ${expense.description ?? '-'}",
// //                 style: TextStyle(color: Colors.grey[700]),
// //               ),
// //             ],
// //           ),
// //         ),
// //         Column(
// //           crossAxisAlignment: CrossAxisAlignment.end,
// //           children: [
// //             Text(
// //               "₹${expense.amount}",
// //               style: const TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 16,
// //               ),
// //             ),
// //             const SizedBox(height: 4),
// //             Text(
// //               DateFormat('d/M/yyyy').format(DateTime.parse(expense.date)),
// //               style: TextStyle(color: Colors.grey[700]),
// //             ),
// //           ],
// //         ),
// //       ],
// //     ),
// //   ),
// // );

// //               },
// //             ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           showModalBottomSheet(
// //             context: context,
// //             isScrollControlled: true,
// //             builder: (context) => AddExpenseDialog(
// //               vehicles: vehicles,
// //               onExpenseAdded: ()async {
// //                  await ref.read(expenseProvider.notifier).fetchExpenses();
// //               },
// //             ),
// //           );
// //         },
// //         child: const Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }

// // screen_expense.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:my_new_project/application/expense/expense_provider.dart';
// import 'package:my_new_project/application/expense/expense_state.dart';
// import 'package:my_new_project/application/expensetype/expensetype_provider.dart';
// import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
// import 'package:my_new_project/widgets/expense/add_expense_dialog.dart';

// class ScreenExpense extends ConsumerStatefulWidget {
//   const ScreenExpense({super.key});

//   @override
//   ConsumerState<ScreenExpense> createState() => _ScreenExpenseState();
// }

// class _ScreenExpenseState extends ConsumerState<ScreenExpense> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       ref.read(expenseProvider.notifier).fetchExpenses();
//       ref.read(expenseTypeProvider.notifier).loadExpenseTypes();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vehicleState = ref.watch(vehicleProvider);
//     final vehicles = vehicleState.vehicles;

//     final expenseTypeState = ref.watch(expenseTypeProvider);
//     final expenseTypes = expenseTypeState.expenseTypes;

//     final expenseState = ref.watch(expenseProvider);
//     final expenses = expenseState.expenses;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Expenses'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               showModalBottomSheet(
//                 context: context,
//                 isScrollControlled: true,
//                 builder: (context) => AddExpenseDialog(
//                   vehicles: vehicles,
                
//                   onExpenseAdded: () async {
//                     await ref.read(expenseProvider.notifier).fetchExpenses();
//                   },
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: expenseState.status == ExpenseStatus.loading
//           ? const Center(child: CircularProgressIndicator())
//           : expenses.isEmpty
//               ? const Center(child: Text("No expense record found"))
//               : ListView.builder(
//                   padding: const EdgeInsets.all(12),
//                   itemCount: expenses.length,
//                   itemBuilder: (context, index) {
//                     final expense = expenses[index];
//                     final vehicle = vehicles.firstWhere(
//                       (v) => v.id == expense.vehicleId,
                    
//                     );

//                     return Card(
//                       color: Colors.white,
//                       elevation: 3,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       margin: const EdgeInsets.only(bottom: 16),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Type + Menu
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     expense.type.toUpperCase(),
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                       color: Color(0xFF1B1B3A),
//                                     ),
//                                   ),
//                                 ),
//                                 PopupMenuButton<String>(
//                                   onSelected: (value) {
//                                     if (value == 'edit') {
//                                       // TODO: Implement edit logic
//                                     } else if (value == 'delete') {
//                                       // TODO: Implement delete logic
//                                     }
//                                   },
//                                   itemBuilder: (context) => const [
//                                     PopupMenuItem(
//                                       value: 'edit',
//                                       child: Text('Edit'),
//                                     ),
//                                     PopupMenuItem(
//                                       value: 'delete',
//                                       child: Text('Delete'),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             if (vehicle != null)
//                               Text(
//                                 "${vehicle.make} ${vehicle.model} • ${vehicle.registrationId}",
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             const SizedBox(height: 6),
//                             Text(
//                               expense.description?.trim().isNotEmpty == true
//                                   ? expense.description!
//                                   : "No description",
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             // Amount + Date
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "₹${expense.amount.toString()}",
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 Text(
//                                   DateFormat('d/M/yyyy')
//                                       .format(DateTime.parse(expense.date)),
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/expense/expense_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/expense/add_expense_dialog.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';

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
      body:SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "Expense",
               onBack: (){
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
              onAdd:(){
                showDialog(
                  context: context,
                   builder:(_) =>AddExpenseDialog(),
                    );
              }    
            ),
            KHeight,

            Expanded(
              child:expenseState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : expenses.isEmpty
              ? const Center(child: Text("No expenses found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    final date = DateFormat('d/M/y').format(expense.date);

                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    expense.expenseTypeName?.toUpperCase() ?? "UNKNOWN",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF1B1B3A),
                                    ),
                                  ),
                                ),
                                Text(
                                  expense.amount.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    // TODO: Add edit/delete functionality
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
                              expense.accountName ?? 'No Account',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            Text(
                              "${expense.paymentStatus} - $date",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Paid: ${expense.expensePaid.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
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
}
