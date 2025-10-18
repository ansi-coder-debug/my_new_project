/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/employee/employee_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/employee.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class AddEmployeeModal extends ConsumerStatefulWidget {
  const AddEmployeeModal({super.key});

  @override
  ConsumerState<AddEmployeeModal> createState() => _AddEmployeeModalState();
}

class _AddEmployeeModalState extends ConsumerState<AddEmployeeModal> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _salaryCtrl = TextEditingController();

  String? _selectedPosition;
  DateTime _selectedDate = DateTime.now();

  final List<String> _positions = [
    'Manager',
    'Sales Executive',
    'Accountant',
    'Technician',
  ];

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final employee = Employee(
        id: null, // backend will assign it
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        position: _selectedPosition!,
        salary: double.tryParse(_salaryCtrl.text.trim()) ?? 0,
        hireDate: _selectedDate.toIso8601String(),
      );

      await ref.read(employeeProvider.notifier).addEmployee(employee);
      Navigator.of(context).pop(); // Close modal
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
       height: MediaQuery.of(context).size.height * 0.65,
      title: "Add Employee",
      onSubmit: _submit,
      onCancel: () => Navigator.of(context).pop(),
      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Kheight6,
              FractionallySizedBox(
                widthFactor: 0.5, // 50% of the available width
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
                    decoration: buildInputDecoration(
                      'Hire Date',
                    ).copyWith(labelText: 'Hire Date'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MM/dd/yyyy').format(_selectedDate),
                           style: const TextStyle(color: Colors.black, fontSize: 14),// Adjust font size if necessary
                        ),
                        const Icon(Icons.calendar_today, size: 18),
                      ],
                    ),
                  ),
                ),
              ),

              KHeight16,

              /// Name
              TextFormField(
                controller: _nameCtrl,
                decoration: buildInputDecoration("Employee Name"),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              KHeight16,

              /// Email
              TextFormField(
                controller: _emailCtrl,
                decoration: buildInputDecoration("Email"),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              KHeight16,

              /// Phone
              TextFormField(
                controller: _phoneCtrl,
                decoration: buildInputDecoration("Phone"),
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  if (val.length != 10) return 'Must be 10 digits';
                  return null;
                },
              ),
              KHeight16,

              /// Address
              TextFormField(
                controller: _addressCtrl,
                decoration: buildInputDecoration("Address"),
                maxLines: 2,
              ),
              KHeight16,

              /// Position Dropdown
              DropdownButtonFormField<String>(
                decoration: buildInputDecoration("Select Position"),
                value: _selectedPosition,
                items: _positions
                    .map(
                      (pos) => DropdownMenuItem(value: pos, child: Text(pos)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedPosition = val),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              KHeight16,

              /// Salary
              TextFormField(
                controller: _salaryCtrl,
                decoration: buildInputDecoration("Salary"),
                keyboardType: TextInputType.number,
              ),
              KHeight16,
            ],
          ),
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/employee/employee_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/employee.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class EmployeeDialog extends ConsumerStatefulWidget {
  final Employee employee;
  final bool isViewOnly;

  const EmployeeDialog({
    super.key,
    required this.employee,
    this.isViewOnly = false,
  });

  @override
  ConsumerState<EmployeeDialog> createState() => _EmployeeDialogState();
}

class _EmployeeDialogState extends ConsumerState<EmployeeDialog> {
  bool isEdit = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _salaryCtrl = TextEditingController();
  String? _selectedPosition;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateCtrl = TextEditingController();


  final List<String> _positions = [
    'Manager',
    'Sales Executive',
    'Accountant',
    'Technician',
  ];

  @override
  void initState() {
    super.initState();
    isEdit = !widget.isViewOnly;

    _nameCtrl.text = widget.employee.name;
    _emailCtrl.text = widget.employee.email;
    _phoneCtrl.text = widget.employee.phone;
    _addressCtrl.text = widget.employee.address;
    _salaryCtrl.text = widget.employee.salary.toString();
    _selectedPosition = widget.employee.position;
// Initialize date controller with formatted string
  _dateCtrl.text = DateFormat('MM/dd/yyyy').format(_selectedDate);  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _salaryCtrl.dispose();
     _dateCtrl.dispose(); // dispose the date controller
    super.dispose();
  }

  Future<void> _updateEmployee() async {
    final updated = Employee(
      id: widget.employee.id,
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      position: _selectedPosition!,
      salary: double.tryParse(_salaryCtrl.text.trim()) ?? 0,
      hireDate: _selectedDate.toIso8601String(),
    );

    await ref.read(employeeProvider.notifier).updateEmployeeOnBackend(updated);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Employee updated')));
    }
  }

  Future<void> _deleteEmployee() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this employee?'),
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
          .read(employeeProvider.notifier)
          .deleteEmployee(widget.employee.id!);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Employee deleted')));
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (isEdit) {
      await _updateEmployee();
    } else {
      final employee = Employee(
        id: null,
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        position: _selectedPosition!,
        salary: double.tryParse(_salaryCtrl.text.trim()) ?? 0,
hireDate: _selectedDate.toIso8601String(),
      );

      await ref.read(employeeProvider.notifier).addEmployee(employee);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Employee added')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      title: widget.isViewOnly
          ? 'View Employee'
          : isEdit
          ? 'Edit Employee'
          : 'Add Employee',
      onCancel: () => Navigator.of(context).pop(),
      onSubmit: isEdit || !widget.isViewOnly ? _submit : null,
      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              KHeight16,
              // Hire Date
             FractionallySizedBox(
  widthFactor: 0.5,
  child: TextFormField(

    readOnly: true,
    enabled: !widget.isViewOnly,
    controller: _dateCtrl,
    style: const TextStyle(color: Colors.black, fontSize: 14),
    decoration: buildInputDecoration(
      "Hire Date",
      icon: Icons.calendar_today,
    ),
    onTap: widget.isViewOnly
        ? null
        : () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                _selectedDate = picked;
                _dateCtrl.text = DateFormat('MM/dd/yyyy').format(picked);
              });
            }
          },
  ),
),


              KHeight16,
              // Name
              TextFormField(
                style: TextStyle(color: Colors.black),
                controller: _nameCtrl,
                decoration: buildInputDecoration("Employee Name"),
                readOnly: widget.isViewOnly ? true : !isEdit,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              KHeight16,
              // Email
              TextFormField(
                 style: TextStyle(color: Colors.black),
                controller: _emailCtrl,
                decoration: buildInputDecoration("Email"),
                readOnly: widget.isViewOnly ? true : !isEdit,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              KHeight16,
              // Phone
              TextFormField(
                 style: TextStyle(color: Colors.black),
                controller: _phoneCtrl,
                decoration: buildInputDecoration("Phone"),
                keyboardType: TextInputType.number,
                maxLength: 10,
                readOnly: widget.isViewOnly ? true : !isEdit,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  if (val.length != 10) return 'Must be 10 digits';
                  return null;
                },
              ),
              KHeight16,
              // Address
              TextFormField(
                 style: TextStyle(color: Colors.black),
                controller: _addressCtrl,
                decoration: buildInputDecoration("Address"),
                readOnly: widget.isViewOnly ? true : !isEdit,
                maxLines: 2,
              ),
              KHeight16,
              // Position
              DropdownButtonFormField<String>(
                 style: TextStyle(color: Colors.black),
                decoration: buildInputDecoration("Select Position"),
                value: _selectedPosition,
                items: _positions
                    .map(
                      (pos) => DropdownMenuItem(value: pos, child: Text(pos)),
                    )
                    .toList(),
                onChanged: widget.isViewOnly
                    ? null
                    : (val) => setState(() => _selectedPosition = val),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              KHeight16,
              // Salary
              TextFormField(
                 style: TextStyle(color: Colors.black),
                controller: _salaryCtrl,
                decoration: buildInputDecoration("Salary"),
                keyboardType: TextInputType.number,
                readOnly: widget.isViewOnly ? true : !isEdit,
              ),
              KHeight16,
              // Show Delete & Update buttons if editable
              if (isEdit)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: _deleteEmployee,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _updateEmployee,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A0A33),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
