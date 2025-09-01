import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/expense/expense_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/vehicle.dart';

class AddExpenseDialog extends ConsumerStatefulWidget {
  final Vehicle vehicle;
  final VoidCallback? onExpenseAdded; // Optional callback

  // final Function(Map<String, String>) onSubmit;

  const AddExpenseDialog({
    super.key,
    required this.vehicle,
    this.onExpenseAdded,
    // required this.onSubmit,
  });

  @override
  ConsumerState<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedExpenseType;
  final _vehicleNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  final List<String> _expenseTypes = [
    "Vehicle Acquisition Cost",
    "Vehicle Maintenance",
    "Polishing",
    "Spare Parts",
    "Painting",
    "Brokerage",
    "Tyre",
  ];

  @override
  void initState() {
    super.initState();
    _vehicleNameController.text =
        "${widget.vehicle.make} ${widget.vehicle.model} ";
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedExpenseType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an expense type')),
        );
        return;
      }
      ref.read(expenseProvider.notifier).addExpense(
        amount: _amountController.text,
        description: _descriptionController.text,
        date: _selectedDate.toIso8601String(),
        vehicleId: widget.vehicle.id,
        //  expenseType: _selectedExpenseType!,
      );

       Navigator.pop(context);
      if (widget.onExpenseAdded != null) widget.onExpenseAdded!();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully')),
      );



    }
  }

  

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF5B8EFF)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Add Expense",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "View Report",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Dropdown
              DropdownButtonFormField<String>(
                value: _selectedExpenseType,
                decoration: _inputDecoration("Select Vehicle Expense Type"),
                items: _expenseTypes
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedExpenseType = value),
                validator: (value) =>
                    value == null ? 'Please select an expense type' : null,
              ),
              const SizedBox(height: 16),

              // Vehicle Number
              TextFormField(
                controller: _vehicleNameController,
                readOnly: true,
                decoration: _inputDecoration("Vehicle Number"),
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Amount"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Amount is required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration("Description"),
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),

              // Date
              const Text("Date", style: TextStyle(color: Colors.black87)),
              const SizedBox(height: 6),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: _inputDecoration("Select date"),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MM/dd/yyyy').format(_selectedDate),
                        style: const TextStyle(color: Colors.black87),
                      ),
                      const Icon(Icons.calendar_today, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B8EFF),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              KHeight16,
            ],
          ),
        ),
      ),
    );
  }
}
