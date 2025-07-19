import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_new_project/core/models/employee.dart';
import 'package:my_new_project/core/models/expense.dart';
import 'package:my_new_project/widgets/common_search_bar.dart';
import 'package:my_new_project/widgets/expense/add_expense_form.dart';
import 'package:my_new_project/widgets/expense/expense_card.dart';
import 'package:my_new_project/widgets/expense/expense_details_screen.dart';
import 'package:my_new_project/widgets/expense/expense_filter_row.dart';

class ScreenExpense extends StatefulWidget {
  const ScreenExpense({super.key});

  @override
  State<ScreenExpense> createState() => _ScreenExpenseState();
}

class _ScreenExpenseState extends State<ScreenExpense> {
  String selectedStatus = 'All Status';
  String selectedSort = 'Newest First';
  bool showAddExpenseForm = false;
  Expense? expenseToEdit;

  //details page
  bool showExpenseDetails = false;
  Expense? selectedExpense;

  final Box<Expense> expenseBox = Hive.box<Expense>('expenses');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showAddExpenseForm
          ?
            // If true, show the Add Expense Form instead of the list
            AddExpenseForm(
              onCancel: () {
                // 👉 When user clicks 'Cancel' inside the form:
                // Close the form and show the list again
                setState(() {
                  showAddExpenseForm = false;
                });
              },
              onAddComplete: () {
                // 👉 When user completes adding a new expense:
                // Close the form and show the list again
                setState(() {
                  showAddExpenseForm = false;
                });
              },
              expenseToEdit: expenseToEdit,

              // ✅ If false, show the normal Expense List page UI
            )

            
          : showExpenseDetails && selectedExpense != null
          ? ExpenseDetailsScreen(
              expense: selectedExpense!,
              onBack: () {
                setState(() {
                  showAddExpenseForm = false;
                  selectedExpense = null;
                });
              },
              onEdit: () {
                setState(() {
                  expenseToEdit = selectedExpense;
                  showExpenseDetails = false;
                  showAddExpenseForm = true;
                });
              },
            )
          : ValueListenableBuilder(
              valueListenable: Hive.box<Expense>('expenses').listenable(),
              builder: (context, box, _) {
                //getting details of all employees
                List<Expense> expenses = box.values.toList();

                List<dynamic> Keys = box.keys
                    .toList(); //Get all keys as numbers in a list

                // Apply status filter
                // ✅ 2️⃣ UPDATED: FIX TRIM & LOWERCASE
                if (selectedStatus != 'All Status') {
                  expenses = expenses.where((e) {
                    final expenseStatus = e.status.trim().toLowerCase();
                    final filterStatus = selectedStatus.trim().toLowerCase();
                    return expenseStatus == filterStatus;
                  }).toList();
                }

                /*apply by fiter */
                expenses.sort((a, b) {
                  switch (selectedSort) {
                    case 'Newest First':
                      return b.date.compareTo(a.date);
                    case 'Oldest First':
                      return a.date.compareTo(b.date);
                    case 'Amount High to Low':
                      return double.parse(
                        b.amount.replaceAll(',', ''),
                      ).compareTo(double.parse(a.amount.replaceAll(',', '')));
                    case 'Amount Low to High':
                      return double.parse(
                        a.amount.replaceAll(',', ''),
                      ).compareTo(double.parse(b.amount.replaceAll(',', '')));
                    default:
                      return 0;
                  }
                });

                return Column(
                  children: [
                    CommonSearchBar(
                      labelText: 'Expenses Page',
                      hintText: 'Expenses',
                      onChanged: (p0) {},
                    ),
                    ExpenseFilterRow(
                      selectedStatus: selectedStatus,
                      selectedSort: selectedSort,

                      onStatusChanged: (newStatus) {
                        setState(() {
                          selectedStatus = newStatus!;
                        });
                      },

                      onSortingChanged: (sortOption) {
                        setState(() {
                          selectedSort = sortOption!;
                        });
                      },

                      onAddPressed: () {
                        setState(() {
                          expenseToEdit = null;
                          showAddExpenseForm = true;
                        });
                      },
                    ),

                    //         required this.id,
                    // required this.title,
                    // required this.category,
                    // required this.amount,
                    // required this.date,
                    // required this.paymentMode,
                    // required this.status,
                    // this.description
                    Expanded(
                      child: expenses.isEmpty
                          ? Center(child: Text('No Emlpyees Found'))
                          : ListView.builder(
                              itemCount: expenses.length,
                              itemBuilder: (context, index) {
                                final Expense = expenses[index];
                                return ExpenseCard(
                                  id: Expense.id,
                                  title: Expense.title,
                                  category: Expense.category,
                                  amount: Expense.amount,
                                  date: Expense.date,
                                  paymentMode: Expense.paymentMode,
                                  status: Expense.status,

                                  onDelete: () async {
                                    await expenses[index].delete();
                                  },
                                  onEdit: () {
                                    setState(() {
                                      expenseToEdit = Expense;
                                      showAddExpenseForm = true;
                                    });
                                  },
                                  onTap: () {
                                    setState(() {
                                      selectedExpense = Expense;
                                      showExpenseDetails = true;
                                    });
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
