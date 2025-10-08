import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/expense/expense_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/widgets/expense/add_expense_dialog.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';

class ScreenExpense extends ConsumerWidget {
  const ScreenExpense({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseState = ref.watch(expenseProvider);
    final expenses = expenseState.expenses;
    final vehicleState = ref.watch(vehicleProvider);
    final allVehicles = vehicleState.vehicles;

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

                        String getVehicleNameForExpense(
                          int? vehicleId,
                          List<Vehicle> vehicles,
                        ) {
                          try {
                            final vehicle = vehicles.firstWhere(
                              (v) => v.id == vehicleId?.toString(),
                            );
                            return "${vehicle.make} ${vehicle.model}";
                          } catch (_) {
                            return "Unknown Vehicle";
                          }
                        }

                        final vehicleName = getVehicleNameForExpense(
                          expense.vehicleId,
                          allVehicles,
                        );

                        return OutputCard(
                          title:
                              expense.expenseTypeName?.toUpperCase() ??
                              "UNKNOWN",
                          subtitle:
                              "$vehicleName\n${expense.paymentStatus} - $date",
                          amount: expense.amount,
                          received: expense.expensePaid,
                          receivedLabel: "Paid",
                          showMenu: true,
                          onView: () {
                            showDialog(
                              context: context,
                              builder: (_) =>
                                  AddExpenseDialog(expense: expense,
                                  isViewOnly: true,
                                  // readOnly: true,
                                  ),
                            );
                          },
                          onEdit: () {
                            showDialog(
                              context: context,
                              builder: (_) =>
                                  AddExpenseDialog(expense: expense,
                                  isViewOnly: false,
                                  
                                  // readOnly: false,
                                  ),
                            );
                          },
                          onDelete: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                  'Are you sure you want to delete this expense?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await ref
                                  .read(expenseProvider.notifier)
                                  .deleteExpense(expense.id!);
                              ref.read(expenseProvider.notifier).loadExpenses();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Expense deleted"),
                                  ),
                                );
                              }
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









