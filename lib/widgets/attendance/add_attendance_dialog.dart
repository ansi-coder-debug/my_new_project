import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/employee/employee_provider.dart';

import 'package:my_new_project/core/models/attendance.dart';
import 'package:my_new_project/core/models/employee.dart';
import 'package:my_new_project/application/attendance/attendance_provider.dart';


class AddAttendanceDialog extends ConsumerStatefulWidget {
  const AddAttendanceDialog({super.key});

  @override
  ConsumerState<AddAttendanceDialog> createState() => _AddAttendanceDialogState();
}

class _AddAttendanceDialogState extends ConsumerState<AddAttendanceDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  Employee? _selectedEmployee;
  String? _selectedStatus;

  final List<String> _statusOptions = ['Present', 'Absent', 'Late', 'Half Day'];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedEmployee == null || _selectedStatus == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select both employee and status')),
        );
        return;
      }

      final newAttendance = Attendance(
        employeeId: _selectedEmployee!.id!,
        attendanceStatus: _selectedStatus!,
        attendanceDate: _selectedDate,
      );

      try {
        await ref.read(attendanceProvider.notifier).addAttendance(newAttendance);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add attendance: $e')),
        );
      }
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

  @override
  Widget build(BuildContext context) {
    final employees = ref.watch(employeeProvider).employees;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Add Attendance",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1B1B3A)),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF1B1B3A)),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
            const SizedBox(height: 16),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Date picker
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: _inputDecoration('Date'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat('MM/dd/yyyy').format(_selectedDate)),
                          const Icon(Icons.calendar_today, size: 18)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Employee dropdown
                  DropdownButtonFormField<Employee>(
                    value: _selectedEmployee,
                    decoration: _inputDecoration("Select Employee"),
                    items: employees
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _selectedEmployee = value),
                    validator: (val) => val == null ? 'Please select an employee' : null,
                  ),
                  const SizedBox(height: 16),

                  // Status dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: _inputDecoration("Select Status"),
                    items: _statusOptions
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _selectedStatus = value),
                    validator: (val) => val == null ? 'Please select a status' : null,
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF1B1B3A)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Cancel", style: TextStyle(color: Color(0xFF1B1B3A))),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A0A33),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Submit", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
