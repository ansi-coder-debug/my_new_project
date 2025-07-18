import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/expense.dart';
import 'package:uuid/uuid.dart';

class AddExpenseFormFromVehicle extends StatefulWidget {
  final String vehicleId;
  final VoidCallback onCancel;
  final VoidCallback onAddComplete;

  const AddExpenseFormFromVehicle({
    super.key,
    required this.vehicleId,
    required this.onCancel,
    required this.onAddComplete,
  });

  @override
  State<AddExpenseFormFromVehicle> createState() =>
      _AddExpenseFormFromVehicleState();
}

class _AddExpenseFormFromVehicleState extends State<AddExpenseFormFromVehicle> {
  final _amountController = TextEditingController();

  //2. Default values for dropdowns
  String _selectedCategory = 'Service';
  String _selectedPaymentMode = 'Cash';
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // ✅ Your _saveExpense function goes here:
  Future<void> _saveExpense() async {
    //Basic validation
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please Enter An Amount')));
      return;
    }

    //Create new Expense object
    final newExpense = Expense(
      id: Uuid().v4(), // Generate unique ID (like a serial number)
      title: '${_selectedCategory} Expense',
      category: _selectedCategory,
      amount: _amountController.text,
      date: _selectedDate.toString(),
      paymentMode: _selectedPaymentMode,
      status: 'Pending', //Default Status
      vehicleId: widget.vehicleId, // Links expense to this vehicle
    );

    // Save to Hive database
    final expenseBox = Hive.box<Expense>('expenses');
    await expenseBox.put(newExpense.id, newExpense);

    // Close form and refresh parent
    widget.onAddComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _amountController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),

            keyboardType: TextInputType.number,
          ),
          KHeight,

          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedCategory = value;
                });
              }
            },
            items: ['Service', 'Maintenance', 'Fuel', 'Repair']
                .map(
                  (Category) =>
                      DropdownMenuItem(value: Category, child: Text(Category)),
                )
                .toList(),
          ),
          KHeight16,
          DropdownButtonFormField<String>(
            value: _selectedPaymentMode,
            decoration: const InputDecoration(
              labelText: 'PaymentMode',
              border: OutlineInputBorder(),
            ),

            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedPaymentMode = value;
                });
              }
            },
            items: ['Cash', 'Card', 'UPI', 'Bank Transfer']
                .map((mode) => DropdownMenuItem(value: mode, child: Text(mode)))
                .toList(),
          ),
          KHeight16,
          InkWell(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                firstDate: DateTime(2010),
                lastDate: DateTime.now(),
                initialDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
             
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
              child: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),

          SizedBox(height:20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: widget.onCancel,
               child:Text('Cancel'),
               ),
               SizedBox(width: 8),
               ElevatedButton(
                onPressed:_saveExpense, //  Calls our save function
                child: Text('Save Expense',
                style: TextStyle(
                  color: Colors.white,
                ),
                
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  )
                )
                )

            ],
          )





          
        ],
      ),
    );
  }
}

//  ElevatedButton(
          //   // onPressed: () async {
          //   //   final amountText = _amountController.text.trim();
          //   //   if (amountText.isEmpty) return;

          //   //   final amount = double.tryParse(amountText);
          //   //   if (amount == null) return;

          //   //   final expense = Expense(
          //   //     id: Uuid().v4(),
          //   //     vehicleId: widget.vehicleId,
          //   //     amount: amount,
          //   //     category: _selectedCategory,
          //   //     paymentMode: _selectedPaymentMode,
          //   //     date: _selectedDate,
          //   //   );
          //   //   final box = await Hive.openBox<Expense>('expenses');
          //   //   await box.put(expense.id, expense);
          //   //   widget.onAddComplete();
          //   // },
          //   child: Text('Save'),
            
          // ),