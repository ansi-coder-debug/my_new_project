import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/employee/employee_provider.dart';
import 'package:my_new_project/application/attendance/attendance_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/attendance.dart';
import 'package:my_new_project/core/models/employee.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class AddAttendanceDialog extends ConsumerStatefulWidget {
  final Attendance? attendance;
  final bool isViewOnly;

  const AddAttendanceDialog({
    super.key,
    this.attendance,
    this.isViewOnly = false,
  });

  @override
  ConsumerState<AddAttendanceDialog> createState() =>
      _AddAttendanceDialogState();
}

class _AddAttendanceDialogState extends ConsumerState<AddAttendanceDialog> {
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  Employee? selectedEmployee;
  String? selectedStatus;
  bool isEdit = false;

   final List<String> statusOptions = ['Present', 'Absent', 'Late', 'Half Day'];
 
final Map<String, String> statusMapping = {
  'present': 'Present',
  'absent': 'Absent',
  'late': 'Late',
  'half_day': 'Half Day',
};


  bool get isViewOnly => widget.isViewOnly;

  @override
  void initState() {
    super.initState();

    if (widget.attendance != null) {
      final a = widget.attendance!;
      selectedDate = a.attendanceDate;


  final backendStatus = a.attendanceStatus.trim().toLowerCase();

selectedStatus = statusMapping[backendStatus] ?? statusOptions.first;

print('Backend: "${a.attendanceStatus}" | Matched: $selectedStatus');


      // load employee from provider based on ID
      Future.delayed(Duration.zero, () {
        final employees = ref.read(employeeProvider).employees;
        if (employees.isNotEmpty) {
          setState(() {
            selectedEmployee = employees.firstWhere(
              (e) => e.id == a.employeeId,
            
            ); // ✅ Safe fallback
          });
        }
      });

      isEdit = !widget.isViewOnly;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedEmployee == null || selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select employee and status')),
      );
      return;
    }

    final newAttendance = Attendance(
      id: widget.attendance?.id,
      employeeId: selectedEmployee!.id!,
      attendanceStatus: selectedStatus!,
      attendanceDate: selectedDate,
    );

    final notifier = ref.read(attendanceProvider.notifier);

    try {
      if (widget.attendance != null) {
        await notifier.updateAttendance(newAttendance);
      } else {
        await notifier.addAttendance(newAttendance);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.attendance != null
                  ? 'Attendance updated'
                  : 'Attendance added',
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

  Future<void> _deleteAttendance() async {
    if (widget.attendance?.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text(
          'Are you sure you want to delete this attendance record?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref
          .read(attendanceProvider.notifier)
          .deleteAttendance(widget.attendance!.id!);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Attendance deleted')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final employees = ref.watch(employeeProvider).employees;

    return CustomDialog(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.45,
      title: isViewOnly
          ? "View Attendance"
          : (widget.attendance != null ? "Edit Attendance" : "Add Attendance"),
      onSubmit: isViewOnly ? null : () => _submitForm(),
      onCancel: () => Navigator.of(context).pop(),
      bodyContent: Form(
        key: _formKey,
        child: Column(
          children: [
            // Date
            FractionallySizedBox(
              widthFactor: 0.5,
              child: TextFormField(
                readOnly: true,
                enabled: !isViewOnly,
                controller: TextEditingController(
                  text: DateFormat('MM/dd/yyyy').format(selectedDate),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 14),
                decoration: buildInputDecoration(
                  "Date",
                  icon: Icons.calendar_today,
                ),
                onTap: isViewOnly
                    ? null
                    : () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => selectedDate = picked);
                        }
                      },
              ),
            ),
            KHeight16,

            // Employee dropdown
            // DropdownButtonFormField<Employee>(
            //   value: selectedEmployee,
            //   decoration: buildInputDecoration("Select Employee"),
            //   items: employees
            //       .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
            //       .toList(),
            //   onChanged: isViewOnly
            //       ? null
            //       : (val) => setState(() => selectedEmployee = val),
            //   validator: (val) =>
            //       val == null ? 'Please select an employee' : null,
            // ),
            DropdownButtonFormField<Employee>(
              value: selectedEmployee,
              decoration: buildInputDecoration("Select Employee"),
              items: employees
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                  .toList(),
              onChanged: isViewOnly
                  ? null
                  : (val) => setState(() => selectedEmployee = val),
              validator: (val) =>
                  val == null ? 'Please select an employee' : null,
            ),

            KHeight16,

            // Status dropdown
            // DropdownButtonFormField<String>(
            //   value: selectedStatus,
            //   decoration: buildInputDecoration("Select Status"),
            //   items: statusOptions
            //       .map((status) =>
            //           DropdownMenuItem(value: status, child: Text(status)))
            //       .toList(),
            //   onChanged: isViewOnly
            //       ? null
            //       : (val) => setState(() => selectedStatus = val),
            //   validator: (val) => val == null ? 'Please select a status' : null,
            // ),
          DropdownButtonFormField<String>(
  value: selectedStatus,
  decoration: buildInputDecoration("Select Status"),
  items: statusOptions
      .map((status) => DropdownMenuItem(
            value: status,
            child: Text(status),
          ))
      .toList(),
  onChanged: isViewOnly
      ? null
      : (val) => setState(() => selectedStatus = val),
  validator: (val) => val == null ? 'Please select a status' : null,
)

          ],
        ),
      ),
    );
  }
}
