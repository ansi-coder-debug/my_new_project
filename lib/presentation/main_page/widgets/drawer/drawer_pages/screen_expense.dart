import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/expense/expense_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/widgets/expense/add_expense_dialog.dart';
// Import your vehicle provider

class ScreenExpense extends ConsumerStatefulWidget {
  const ScreenExpense({super.key});

  @override
  ConsumerState<ScreenExpense> createState() => _ScreenExpenseState();

  
}

class _ScreenExpenseState extends ConsumerState<ScreenExpense> {

  @override
  void initState() {
    super.initState();

    // Fetch expenses from API when screen opens
    Future.microtask(() {
      ref.read(expenseProvider.notifier).fetchExpenses();
    });
  }

  


@override
  Widget build(BuildContext context) {
    final vehicleState = ref.watch(vehicleProvider);
    final vehicles = vehicleState.vehicles;

    final expenseState = ref.watch(expenseProvider);
    final expenses = expenseState.expenses;

    return Scaffold(
      body: 
      expenses.isEmpty
    ? Center(
        child: Text(
          'No expense record found',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ):
          ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
               
                final vehicle = vehicles.where((v) => v.id == expense.vehicleId).isNotEmpty
    ? vehicles.firstWhere((v) => v.id == expense.vehicleId)
    : null;


                return Card(
  elevation: 2,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  margin: const EdgeInsets.symmetric(vertical: 8),
  color: Colors.white, // Ensure white background
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side: Expense info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expense.type.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              if (vehicle != null)
                Text(
                  "${vehicle.make} ${vehicle.model}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                "Paid via: ${expense.description ?? '-'}",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "₹${expense.amount}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('d/M/yyyy').format(DateTime.parse(expense.date)),
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ],
    ),
  ),
);

              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddExpenseDialog(
              vehicles: vehicles,
              onExpenseAdded: ()async {
                 await ref.read(expenseProvider.notifier).fetchExpenses();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
