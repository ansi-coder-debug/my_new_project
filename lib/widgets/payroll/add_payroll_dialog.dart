import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/employee/employee_state.dart';
import 'package:my_new_project/application/payroll/payroll_provider.dart';
import 'package:my_new_project/application/employee/employee_provider.dart';
import 'package:my_new_project/core/models/payroll.dart';
import 'package:my_new_project/core/constants/constant.dart';

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

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF5F6FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add payroll: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeState = ref.watch(employeeProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title and close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Payroll Record",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B1B3A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF1B1B3A)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Pay Date Picker
                    InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: _inputDecoration("Pay Date"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_selectedDate.toLocal()}".split(' ')[0],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Employee Dropdown
                    employeeState.status == EmployeeStatus.loading
                        ? const CircularProgressIndicator()
                        : DropdownButtonFormField<int>(
                            isExpanded: true,
                            value: _selectedEmployeeId,
                            decoration: _inputDecoration("Select Employee"),
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

                    const SizedBox(height: 16),

                    // Show Amount field only if employee selected
                    if (_selectedEmployeeId != null) ...[
                      TextFormField(
                        controller: _amountController,
                        decoration: _inputDecoration("Amount"),
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
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
                      const SizedBox(height: 24),
                    ],

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1B1B3A)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Color(0xFF1B1B3A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A0A33),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
