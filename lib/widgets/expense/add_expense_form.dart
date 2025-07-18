import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/expense.dart';

class AddExpenseForm extends StatefulWidget {
  final VoidCallback? onCancel;
  final VoidCallback onAddComplete;
  final Expense? expenseToEdit;

  const AddExpenseForm({
    super.key,
    this.onCancel,
    required this.onAddComplete,
    this.expenseToEdit,
  });

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  String? selectedStatus;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _paymentModeController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _categoryController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _paymentModeController.dispose();
    _statusController.dispose();
    _descriptionController.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.expenseToEdit != null) {
      final exp = widget.expenseToEdit!;
      _idController.text = exp.id;
      _titleController.text = exp.title;
      _categoryController.text = exp.category;
      _amountController.text = exp.amount;
      _dateController.text = exp.date;
      _paymentModeController.text = exp.paymentMode;
      _statusController.text = exp.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Id", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _idController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight,
            Text("Title", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _titleController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight,
            Text("Category", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _categoryController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight,
            Text("Amount", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _amountController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight,
            Text("Date", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _dateController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight,
            Text("PaymentMode", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _paymentModeController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight,

            Text('Status', style: TextStyle(color: Colors.black)),
            DropdownButtonFormField<String>(
              // value: selectedStatus??widget.expenseToEdit?.status??'Pending',
              value:
                  [
                    'Paid',
                    'Unpaid',
                    'Pending',
                    'Overdue',
                  ].contains(selectedStatus ?? widget.expenseToEdit?.status)
                  ? selectedStatus ?? widget.expenseToEdit?.status
                  : 'Pending',
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: ['Paid', 'Unpaid', 'Pending', 'Overdue'].map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),

              onChanged: (expvalue) {
                setState(() {
                  selectedStatus = expvalue!;
                });
              },
            ),
            KHeight,

            Text("Description", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _descriptionController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onCancel?.call();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                SizedBox(width: 20),

                ElevatedButton(
                  onPressed: () async {
                    final box = Hive.box<Expense>('expenses');

                    final newExpense = Expense(
                      id: _idController.text,
                      title: _titleController.text,
                      category: _categoryController.text,
                      amount: _amountController.text,
                      date: _dateController.text,
                      paymentMode: _paymentModeController.text,
                      status: selectedStatus ?? 'Pending',
                      description: _descriptionController.text,
                      vehicleId: 'unLinked' //later change 
                      
                    );

                    //checking if we are editing or adding
                    if (widget.expenseToEdit != null) {
                      final Key = widget.expenseToEdit!.key;
                      await box.put(Key, newExpense);
                      print('Expense Updated');
                    } else {
                      await box.add(newExpense);
                      print('Expense Added');
                    }
                    widget.onAddComplete();
                  },

                  child: Text(
                    'Add Expense',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
