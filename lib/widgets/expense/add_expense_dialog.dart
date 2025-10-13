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
  final Expense? expense; 
  final bool isViewOnly;

  const AddExpenseDialog({
    super.key,
    this.vehicle,
    this.expense,
    this.isViewOnly = false,
  });

  @override
  ConsumerState<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
  bool isEdit = false;
  bool get isViewOnly => widget.isViewOnly;

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

    if (widget.expense != null) {
      final e = widget.expense!;
      _amountController.text = e.amount.toString();
      _paidAmountController.text = e.expensePaid.toString();
      _descriptionController.text = e.description ?? '';
      selectedDate = e.date;
      isEdit = !widget.isViewOnly;

      // Load related dropdown selections (optional - depends on data source)
      Future.delayed(Duration.zero, () {
        final vehicles = ref.read(vehicleProvider).vehicles;
        final accounts = ref.read(accountProvider).accounts;
        final types = ref.read(expenseTypeProvider).expenseTypes;

        setState(() {
          selectedVehicle = vehicles.firstWhere(
            (v) => v.id == e.vehicleId.toString(),
          );
          selectedAccount = accounts.firstWhere(
            (a) => a.id == e.fromAccount.toString(),
          );
          selectedExpenseType = types.firstWhere(
            (t) => t.id == e.expenseTypeId,
          );
        });
      });
    }
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

      final expense = Expense(
        id: widget.expense?.id,
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

      final notifier = ref.read(expenseProvider.notifier);

      if (widget.expense != null) {
        await notifier.updateExpense(expense);
      } else {
        await notifier.addExpense(expense);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.expense != null ? 'Expense updated' : 'Expense added',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
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
      title: isViewOnly
          ? "View Expense"
          : (widget.expense != null ? "Edit Expense" : "Add Expense"),
      // onSubmit: _submitForm,
    onSubmit: isViewOnly ? null : () => _submitForm(),


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
                  enabled: !isViewOnly,

                  controller: TextEditingController(
                    text:
                        "${selectedDate.month.toString().padLeft(2, '0')}/"
                        "${selectedDate.day.toString().padLeft(2, '0')}/"
                        "${selectedDate.year}",
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  decoration: buildInputDecoration(
                    "Date",
                    icon: Icons.calendar_today,
                  ),
                  onTap: isViewOnly
                      ? null // Disable tap if view only
                      : () async {
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
                onChanged: isViewOnly
                    ? null
                    : (val) => setState(() => selectedExpenseType = val),
                validator: (val) =>
                    val == null ? 'Please select expense type' : null,
              ),
              KHeight16,

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
                onChanged: isViewOnly
                    ? null
                    : (val) => setState(() => selectedVehicle = val),

                validator: (val) =>
                    val == null ? 'Please select a vehicle' : null,
              ),
              KHeight16,

              // Amount
              TextFormField(
                controller: _amountController,
                style: TextStyle(color: Colors.black),
                enabled: !isViewOnly,
                keyboardType: TextInputType.number,
                decoration: buildInputDecoration(
                  "Amount",
                  icon: Icons.calculate,
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter amount' : null,
              ),
              KHeight16,

              // Paid Amount
              TextFormField(
                controller: _paidAmountController,
                enabled: !isViewOnly,
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                decoration: buildInputDecoration(
                  "Paid Amount",
                  icon: Icons.calculate,
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter paid amount' : null,
              ),
              KHeight16,

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
                onChanged: isViewOnly
                    ? null
                    : (val) => setState(() => selectedAccount = val),
                validator: (val) =>
                    val == null ? 'Please select account' : null,
              ),
              KHeight16,

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





















/*

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
              KHeight16,

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
              KHeight16,

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
              KHeight16,

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
              KHeight16,

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
               KHeight16,


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
*/