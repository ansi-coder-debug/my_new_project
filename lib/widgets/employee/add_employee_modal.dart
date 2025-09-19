import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/employee/employee_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/employee.dart';

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
        id:null , // backend will assign it
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

//Design 
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
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Employee',
                   style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B1B3A),
                  ),
                  ),
                  IconButton(
                     icon: const Icon(Icons.close, color: Color(0xFF1B1B3A)),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            KHeight16,

              /// Name
              TextFormField(
                controller: _nameCtrl,
                decoration: _inputDecoration("Employee Name"),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
             KHeight16,

              /// Email
              TextFormField(
                controller: _emailCtrl,
                 decoration: _inputDecoration("Email"),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
               KHeight16,

              /// Phone
              TextFormField(
                controller: _phoneCtrl,
                  decoration: _inputDecoration("Phone"),
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
                 decoration: _inputDecoration("Address"),
                maxLines: 2,
              ),
               KHeight16,

              /// Position Dropdown
              DropdownButtonFormField<String>(
                 decoration: _inputDecoration("Select Position"),
                value: _selectedPosition,
                items: _positions
                    .map((pos) =>
                        DropdownMenuItem(value: pos, child: Text(pos)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedPosition = val),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
               KHeight16,

              /// Salary
              TextFormField(
                controller: _salaryCtrl,
                 decoration: _inputDecoration("Salary"),
                keyboardType: TextInputType.number,
              ),
               KHeight16,

              /// Hire Date Picker
              InkWell(
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
  decoration: _inputDecoration('Hire Date').copyWith(
    labelText: 'Hire Date',
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(DateFormat('MM/dd/yyyy').format(_selectedDate)),
      const Icon(Icons.calendar_today, size: 18),
    ],
  ),
),

              ),

              const SizedBox(height: 20),

              /// Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                          style: TextStyle(color: Color(0xFF1B1B3A), fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                       style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A0A33),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
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
