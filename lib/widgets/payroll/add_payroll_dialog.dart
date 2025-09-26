import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/employee/employee_state.dart';
import 'package:my_new_project/application/payroll/payroll_provider.dart';
import 'package:my_new_project/application/employee/employee_provider.dart';
import 'package:my_new_project/core/models/payroll.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class AddPayrollDialog extends ConsumerStatefulWidget {
  const AddPayrollDialog({super.key});

  @override
  ConsumerState<AddPayrollDialog> createState() => _AddPayrollDialogState();
}

class _AddPayrollDialogState extends ConsumerState<AddPayrollDialog> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedEmployeeId;
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final payroll = Payroll(
        employeeId: _selectedEmployeeId!,
        salary: double.parse(_amountController.text.trim()),
        payDate: _selectedDate,
      );

      await ref.read(payrollProvider.notifier).addPayroll(payroll);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payroll record added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add payroll: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeState = ref.watch(employeeProvider);

    return CustomDialog(
       height: MediaQuery.of(context).size.height * 0.42,
      title: "Add Payroll Record",
      onSubmit: _submitForm,
      onCancel: () => Navigator.of(context).pop(),
      bodyContent:Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Pay Date Picker
              Kheight6,
          FractionallySizedBox(
  widthFactor: 0.5, // 50% width
  child: Align(
    alignment: Alignment.centerLeft, // Align left inside half width
    child: InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: buildInputDecoration('Pay Date').copyWith(
          labelText: 'Pay Date',
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,  // shrink row width to content width
          children: [
            Text(
              DateFormat('MM/dd/yyyy').format(_selectedDate),
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            const SizedBox(width: 8), // spacing between text and icon
            const Icon(Icons.calendar_today, size: 18, color: Colors.black),
          ],
        ),
      ),
    ),
  ),
),



          
              KHeight16,
          
              // Employee Dropdown
              employeeState.status == EmployeeStatus.loading
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<int>(
                      isExpanded: true,
                      value: _selectedEmployeeId,
                      decoration: buildInputDecoration("Select Employee"),
                      items: employeeState.employees.map((emp) {
                        return DropdownMenuItem<int>(
                          value: emp.id!,
                          child: Text(emp.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => _selectedEmployeeId = val);
                      },
                      validator: (val) =>
                          val == null ? 'Please select an employee' : null,
                    ),
          
              KHeight16,
          
              // Show Amount field only if employee selected
              if (_selectedEmployeeId != null) ...[
                TextFormField(
                  controller: _amountController,
                  decoration: buildInputDecoration("Amount"),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter amount';
                    }
                    final amount = double.tryParse(val.trim());
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                KHeight16,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
