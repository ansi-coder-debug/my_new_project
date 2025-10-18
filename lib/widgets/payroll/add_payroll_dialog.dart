import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/employee/employee_provider.dart';
import 'package:my_new_project/application/employee/employee_state.dart';
import 'package:my_new_project/application/payroll/payroll_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/employee.dart';
import 'package:my_new_project/core/models/payroll.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class PayrollDialog extends ConsumerStatefulWidget {
  final Payroll? payroll;
  final bool isViewOnly;

  const PayrollDialog({
    super.key,
    this.payroll,
    this.isViewOnly = false,
  });

  @override
  ConsumerState<PayrollDialog> createState() => _PayrollDialogState();
}

class _PayrollDialogState extends ConsumerState<PayrollDialog> {
  bool isEdit = false;
  bool get isViewOnly => widget.isViewOnly;

  final _formKey = GlobalKey<FormState>();

  Employee? selectedEmployee;
  DateTime selectedDate = DateTime.now();

  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.payroll != null) {
      final p = widget.payroll!;
      _amountController.text = p.salary.toString();
      selectedDate = p.payDate;
      isEdit = !widget.isViewOnly;

      // Preselect employee when editing
      Future.delayed(Duration.zero, () {
        final employees = ref.read(employeeProvider).employees;
        setState(() {
          selectedEmployee =
              employees.firstWhere((emp) => emp.id == p.employeeId);
        });
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final payroll = Payroll(
        id: widget.payroll?.id,
        employeeId: selectedEmployee!.id!,
        salary: double.parse(_amountController.text.trim()),
        payDate: selectedDate,
      );

      final notifier = ref.read(payrollProvider.notifier);

      if (widget.payroll != null) {
        await notifier.updatePayroll(payroll);
      } else {
        await notifier.addPayroll(payroll);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.payroll != null
                ? 'Payroll updated'
                : 'Payroll added'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    }
  }

  Future<void> _deletePayroll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text(
            'Are you sure you want to delete this payroll record?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(payrollProvider.notifier).deletePayroll(widget.payroll!.id!);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payroll deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeState = ref.watch(employeeProvider);

    return CustomDialog(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.45,
      title: isViewOnly
          ? "View Payroll"
          : (widget.payroll != null ? "Edit Payroll" : "Add Payroll"),
      onSubmit: isViewOnly ? null : _submitForm,
      // onDelete: widget.payroll != null && !isViewOnly ? _deletePayroll : null,
      onCancel: () => Navigator.of(context).pop(),
      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Pay Date
              FractionallySizedBox(
                widthFactor: 0.5,
                child: TextFormField(
                  readOnly: true,
                  enabled: !isViewOnly,
                  controller: TextEditingController(
                    text: DateFormat('MM/dd/yyyy').format(selectedDate),
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  decoration: buildInputDecoration("Pay Date", icon: Icons.calendar_today),
                  onTap: isViewOnly
                      ? null
                      : () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                ),
              ),
              KHeight16,

              // Employee Dropdown
              employeeState.status == EmployeeStatus.loading
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<Employee>(
                      value: selectedEmployee,
                      isExpanded: true,
                      decoration: buildInputDecoration("Select Employee"),
                      items: employeeState.employees.map((emp) {
                        return DropdownMenuItem<Employee>(
                          value: emp,
                          child: Text(emp.name),
                        );
                      }).toList(),
                      onChanged: isViewOnly
                          ? null
                          : (val) => setState(() => selectedEmployee = val),
                      validator: (val) =>
                          val == null ? 'Please select an employee' : null,
                    ),
              KHeight16,

              // Salary
              TextFormField(
                controller: _amountController,
                enabled: !isViewOnly,
                style: const TextStyle(color: Colors.black),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: buildInputDecoration("Salary", icon: Icons.calculate_outlined),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter salary';
                  }
                  final amount = double.tryParse(val.trim());
                  if (amount == null || amount <= 0) {
                    return 'Enter valid salary';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
