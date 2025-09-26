// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_new_project/application/accounts/account_provider.dart';
// import 'package:my_new_project/application/expense/expense_provider.dart';
// import 'package:my_new_project/application/expensetype/expensetype_provider.dart';
// import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
// import 'package:my_new_project/core/models/account.dart';
// import 'package:my_new_project/core/models/expense.dart';
// import 'package:my_new_project/core/models/expensetype.dart';
// import 'package:my_new_project/core/models/vehicle.dart';

// class AddExpenseDialog extends ConsumerStatefulWidget {
//   final Vehicle? vehicle;
//   const AddExpenseDialog({super.key, this.vehicle});

//   @override
//   ConsumerState<AddExpenseDialog> createState() => _AddExpenseDialogState();
// }

// class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
//   final _formKey = GlobalKey<FormState>();

//   ExpenseType? selectedExpenseType;
//   Vehicle? selectedVehicle;
//   Account? selectedAccount;
//   DateTime selectedDate = DateTime.now();

//   final _amountController = TextEditingController();
//   final _paidAmountController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     selectedVehicle = widget.vehicle;
//   }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     _paidAmountController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   InputDecoration _inputDecoration(String hintText, {IconData? icon}) {
//     return InputDecoration(
//       hintText: hintText,
//       hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
//       filled: true,
//       fillColor: const Color(0xFFF5F6FA),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       suffixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//     );
//   }

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     try {
//       final double amount = double.parse(_amountController.text.trim());
//       final double paid = double.parse(_paidAmountController.text.trim());

//       final String paymentStatus =
//           paid == amount ? 'paid' : (paid == 0 ? 'pending' : 'partial');

//       final newExpense = Expense(
//         id: null,
//         userId: 0,
//         expenseTypeId: selectedExpenseType!.id!,
//         vehicleId: int.tryParse(selectedVehicle!.id),
//         fromAccount: int.parse(selectedAccount!.id!),
//         amount: amount,
//         description: _descriptionController.text.trim(),
//         paymentStatus: paymentStatus,
//         expensePaid: paid,
//         date: selectedDate,
//         employeeId: null,
//       );

//       await ref.read(expenseProvider.notifier).addExpense(newExpense);

//       if (mounted) {
//         Navigator.of(context).pop();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Expense added successfully')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to add expense: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final expenseTypeState = ref.watch(expenseTypeProvider);
//     final vehicleState = ref.watch(vehicleProvider);
//     final accountState = ref.watch(accountProvider);

//     final availableVehicles =
//         vehicleState.vehicles.where((v) => v.status == 'available').toList();

//     return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Title + Close
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Add Expense",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF1B1B3A),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close, color: Color(0xFF1B1B3A)),
//                   onPressed: () => Navigator.of(context).pop(),
//                 )
//               ],
//             ),
//             const SizedBox(height: 16),

//             Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // Date
//                     TextFormField(
//                       readOnly: true,
//                       decoration: _inputDecoration("Date", icon: Icons.calendar_today),
//                       controller: TextEditingController(
//                         text: "${selectedDate.toLocal()}".split(' ')[0],
//                       ),
//                       onTap: () async {
//                         final picked = await showDatePicker(
//                           context: context,
//                           initialDate: selectedDate,
//                           firstDate: DateTime(2020),
//                           lastDate: DateTime.now(),
//                         );
//                         if (picked != null) {
//                           setState(() => selectedDate = picked);
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // Expense Type
//                     DropdownButtonFormField<ExpenseType>(
//                       value: selectedExpenseType,
//                       decoration: _inputDecoration("Select Expense Type"),
//                       items: expenseTypeState.expenseTypes.map((type) {
//                         return DropdownMenuItem(
//                           value: type,
//                           child: Text(type.name),
//                         );
//                       }).toList(),
//                       onChanged: (val) => setState(() => selectedExpenseType = val),
//                       validator: (val) => val == null ? 'Please select expense type' : null,
//                     ),
//                     const SizedBox(height: 16),

//                     // Vehicle
//                     DropdownButtonFormField<Vehicle>(
//                       value: selectedVehicle,
//                       decoration: _inputDecoration("Select Vehicle"),
//                       items: availableVehicles.map((vehicle) {
//                         return DropdownMenuItem(
//                           value: vehicle,
//                           child: Text('${vehicle.model} - ${vehicle.registrationId}'),
//                         );
//                       }).toList(),
//                       onChanged: widget.vehicle == null
//                           ? (val) => setState(() => selectedVehicle = val)
//                           : null,
//                       validator: (val) => val == null ? 'Please select a vehicle' : null,
//                     ),
//                     const SizedBox(height: 16),

//                     // Amount
//                     TextFormField(
//                       controller: _amountController,
//                       keyboardType: TextInputType.number,
//                       decoration: _inputDecoration("Amount", icon: Icons.calculate),
//                       validator: (val) =>
//                           val == null || val.isEmpty ? 'Enter amount' : null,
//                     ),
//                     const SizedBox(height: 16),

//                     // Paid Amount
//                     TextFormField(
//                       controller: _paidAmountController,
//                       keyboardType: TextInputType.number,
//                       decoration: _inputDecoration("Paid Amount", icon: Icons.calculate),
//                       validator: (val) =>
//                           val == null || val.isEmpty ? 'Enter paid amount' : null,
//                     ),
//                     const SizedBox(height: 16),

//                     // Account
//                     DropdownButtonFormField<Account>(
//                       value: selectedAccount,
//                       decoration: _inputDecoration("From Account"),
//                       items: accountState.accounts.map((account) {
//                         return DropdownMenuItem(
//                           value: account,
//                           child: Text(account.name),
//                         );
//                       }).toList(),
//                       onChanged: (val) => setState(() => selectedAccount = val),
//                       validator: (val) => val == null ? 'Please select account' : null,
//                     ),
//                     const SizedBox(height: 16),

//                     // Description
//                     TextFormField(
//                       controller: _descriptionController,
//                       maxLines: 2,
//                       decoration: _inputDecoration("Description (Optional)"),
//                     ),
//                     const SizedBox(height: 24),

//                     // Buttons
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         OutlinedButton(
//                           onPressed: () => Navigator.of(context).pop(),
//                           style: OutlinedButton.styleFrom(
//                             side: const BorderSide(color: Color(0xFF1B1B3A)),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 12),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8)),
//                           ),
//                           child: const Text(
//                             "Cancel",
//                             style: TextStyle(
//                               color: Color(0xFF1B1B3A),
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         ElevatedButton(
//                           onPressed: _submitForm,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF0A0A33),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 24, vertical: 12),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8)),
//                           ),
//                           child: const Text(
//                             "Submit",
//                             style: TextStyle(
//                                 color: Colors.white, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/application/expense/expense_provider.dart';
import 'package:my_new_project/application/expensetype/expensetype_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/core/models/expense.dart';
import 'package:my_new_project/core/models/expensetype.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class AddExpenseDialog extends ConsumerStatefulWidget {
  final Vehicle? vehicle;
  const AddExpenseDialog({super.key, this.vehicle});

  @override
  ConsumerState<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();

  ExpenseType? selectedExpenseType;
  Vehicle? selectedVehicle;
  Account? selectedAccount;
  DateTime selectedDate = DateTime.now();

  final _amountController = TextEditingController();
  final _paidAmountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedVehicle = widget.vehicle;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _paidAmountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final double amount = double.parse(_amountController.text.trim());
      final double paid = double.parse(_paidAmountController.text.trim());

      final String paymentStatus = paid == amount
          ? 'paid'
          : (paid == 0 ? 'pending' : 'partial');

      final newExpense = Expense(
        id: null,
        userId: 0,
        expenseTypeId: selectedExpenseType!.id!,
        vehicleId: int.tryParse(selectedVehicle!.id),
        fromAccount: int.parse(selectedAccount!.id!),
        amount: amount,
        description: _descriptionController.text.trim(),
        paymentStatus: paymentStatus,
        expensePaid: paid,
        date: selectedDate,
        employeeId: null,
      );

      await ref.read(expenseProvider.notifier).addExpense(newExpense);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense added successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add expense: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseTypeState = ref.watch(expenseTypeProvider);
    final vehicleState = ref.watch(vehicleProvider);
    final accountState = ref.watch(accountProvider);

    final availableVehicles = vehicleState.vehicles
        .where((v) => v.status == 'available')
        .toList();

    return CustomDialog(
      // width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
      width: MediaQuery.of(context).size.width,
      title: "Add Expense",
      onSubmit: _submitForm,
      onCancel: () => Navigator.of(context).pop(),
      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Date
     FractionallySizedBox(
  widthFactor: 0.5, // 50% width
  child: TextFormField(
    readOnly: true,
    controller: TextEditingController(
      text: "${selectedDate.month.toString().padLeft(2, '0')}/"
          "${selectedDate.day.toString().padLeft(2, '0')}/"
          "${selectedDate.year}",
    ),
    style: const TextStyle(color: Colors.black, fontSize: 14),
    decoration: buildInputDecoration(
      "Date",
      icon: Icons.calendar_today,
    ),
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        setState(() => selectedDate = picked);
      }
    },
  ),
),



              KHeight16,

              // Expense Type Dropdown
              DropdownButtonFormField<ExpenseType>(
                value: selectedExpenseType,
                decoration: buildInputDecoration("Select Expense Type"),
                items: expenseTypeState.expenseTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type.name));
                }).toList(),
                onChanged: (val) => setState(() => selectedExpenseType = val),
                validator: (val) =>
                    val == null ? 'Please select expense type' : null,
              ),
              const SizedBox(height: 16),

              // Vehicle Dropdown
              DropdownButtonFormField<Vehicle>(
                value: selectedVehicle,
                decoration: buildInputDecoration("Select Vehicle"),
                items: availableVehicles.map((vehicle) {
                  return DropdownMenuItem(
                    value: vehicle,
                    child: Text('${vehicle.model} - ${vehicle.registrationId}'),
                  );
                }).toList(),
                onChanged: widget.vehicle == null
                    ? (val) => setState(() => selectedVehicle = val)
                    : null,
                validator: (val) =>
                    val == null ? 'Please select a vehicle' : null,
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: buildInputDecoration(
                  "Amount",
                  icon: Icons.calculate,
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter amount' : null,
              ),
              const SizedBox(height: 16),

              // Paid Amount
              TextFormField(
                controller: _paidAmountController,
                keyboardType: TextInputType.number,
                decoration: buildInputDecoration(
                  "Paid Amount",
                  icon: Icons.calculate,
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter paid amount' : null,
              ),
              const SizedBox(height: 16),

              // Account Dropdown
              DropdownButtonFormField<Account>(
                value: selectedAccount,
                decoration: buildInputDecoration("From Account"),
                items: accountState.accounts.map((account) {
                  return DropdownMenuItem(
                    value: account,
                    child: Text(account.name),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedAccount = val),
                validator: (val) =>
                    val == null ? 'Please select account' : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: buildInputDecoration("Description (Optional)"),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
