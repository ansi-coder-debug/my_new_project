// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/core/models/expense.dart';
// import 'package:uuid/uuid.dart';

// class AddExpenseFormFromVehicle extends StatefulWidget {
//   final String vehicleId;
//   final VoidCallback onCancel;
//   final VoidCallback onAddComplete;

//   const AddExpenseFormFromVehicle({
//     super.key,
//     required this.vehicleId,
//     required this.onCancel,
//     required this.onAddComplete,
//   });

//   @override
//   State<AddExpenseFormFromVehicle> createState() =>
//       _AddExpenseFormFromVehicleState();
// }

// class _AddExpenseFormFromVehicleState extends State<AddExpenseFormFromVehicle> {
//   final _amountController = TextEditingController();

//   //2. Default values for dropdowns
//   String _selectedCategory = 'Service';
//   String _selectedPaymentMode = 'Cash';
//   DateTime _selectedDate = DateTime.now();

//   @override
//   void dispose() {
//     _amountController.dispose();
//     super.dispose();
//   }

//   // ✅ Your _saveExpense function goes here:
//   Future<void> _saveExpense() async {
//     //Basic validation
//     if (_amountController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Please Enter An Amount')));
//       return;
//     }

//     //Create new Expense object
//     final newExpense = Expense(
//       id: Uuid().v4(), // Generate unique ID (like a serial number)
//       title: '${_selectedCategory} Expense',
//       category: _selectedCategory,
//       amount: _amountController.text,
//       date: _selectedDate.toString(),
//       paymentMode: _selectedPaymentMode,
//       status: 'Pending', //Default Status
//       vehicleId: widget.vehicleId, // Links expense to this vehicle
//     );

//     // Save to Hive database
//     final expenseBox = Hive.box<Expense>('expenses');
//     await expenseBox.put(newExpense.id, newExpense);

//     // Close form and refresh parent
//     widget.onAddComplete();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: _amountController,
//             style: TextStyle(color: Colors.black),
//             decoration: InputDecoration(
//               labelText: 'Amount',
//               border: OutlineInputBorder(),
//             ),

//             keyboardType: TextInputType.number,
//           ),
//           KHeight,

//           DropdownButtonFormField<String>(
//             value: _selectedCategory,
//             decoration: const InputDecoration(
//               labelText: 'Category',
//               border: OutlineInputBorder(),
//             ),
//             onChanged: (value) {
//               if (value != null) {
//                 setState(() {
//                   _selectedCategory = value;
//                 });
//               }
//             },
//             items: ['Service', 'Maintenance', 'Fuel', 'Repair']
//                 .map(
//                   (Category) =>
//                       DropdownMenuItem(value: Category, child: Text(Category)),
//                 )
//                 .toList(),
//           ),
//           KHeight16,
//           DropdownButtonFormField<String>(
//             value: _selectedPaymentMode,
//             decoration: const InputDecoration(
//               labelText: 'PaymentMode',
//               border: OutlineInputBorder(),
//             ),

//             onChanged: (value) {
//               if (value != null) {
//                 setState(() {
//                   _selectedPaymentMode = value;
//                 });
//               }
//             },
//             items: ['Cash', 'Card', 'UPI', 'Bank Transfer']
//                 .map((mode) => DropdownMenuItem(value: mode, child: Text(mode)))
//                 .toList(),
//           ),
//           KHeight16,
//           InkWell(
//             onTap: () async {
//               final pickedDate = await showDatePicker(
//                 context: context,
//                 firstDate: DateTime(2010),
//                 lastDate: DateTime.now(),
//                 initialDate: DateTime.now(),
//               );
//               if (pickedDate != null) {
//                 setState(() {
//                   _selectedDate = pickedDate;
//                 });
//               }
//             },

//             child: InputDecorator(
//               decoration: const InputDecoration(
//                 labelText: 'Date',
//                 border: OutlineInputBorder(),
//               ),
//               child: Text(
//                 '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
//                 style: TextStyle(color: Colors.black),
//               ),
//             ),
//           ),

//           SizedBox(height:20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               TextButton(onPressed: widget.onCancel,
//                child:Text('Cancel'),
//                ),
//                SizedBox(width: 8),
//                ElevatedButton(
//                 onPressed:_saveExpense, //  Calls our save function
//                 child: Text('Save Expense',
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),

//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.zero,
//                   )
//                 )
//                 )

//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

/*
import 'package:flutter/material.dart';
import 'package:my_new_project/core/models/vehicle.dart';

class AddExpenseFormFromVehicle extends StatefulWidget {
  final Vehicle vehicle;
  final Function(Map<String, String>) onSubmit;

  const AddExpenseFormFromVehicle({
    super.key,
    required this.vehicle,
    required this.onSubmit,
  });

  @override
  State<AddExpenseFormFromVehicle> createState() =>
      _AddExpenseFormFromVehicleState();
}

class _AddExpenseFormFromVehicleState extends State<AddExpenseFormFromVehicle> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedCategory;
 
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Expense"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
  value: _selectedCategory,
  decoration: const InputDecoration(labelText: "Select Vehicle Expense Type"),
  items: [
    "Vehicle Acquisition Cost",
    "Vehicle Maintaince",
    "Polishing",
    "Spare Parts",
    "Painting",
    "Brokerage",
    "Tyre",
    "Other",
  ].map((category) {
    return DropdownMenuItem<String>(
      value: category,
      child: Text(category),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      _selectedCategory = value;
    });
  },
),
              // Vehicle name prefilled
              TextFormField(
                initialValue: "${widget.vehicle.make} ${widget.vehicle.model} ${widget.vehicle.registrationId}",
                decoration: InputDecoration(labelText: "Vehicle Name"),
                readOnly: true,
              ),
               TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
              ),
      

              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: "Description"),
              ),

        TextFormField(
  controller: _dateController,
  readOnly: true, // prevent typing
  decoration: const InputDecoration(labelText: "Date"),
  onTap: () async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // earliest date allowed
      lastDate: DateTime(2100), // latest date allowed
    );

    if (pickedDate != null) {
      // Format the date (optional: use intl package for better formatting)
      final formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      _dateController.text = formattedDate;
    }
  },
),
           
            ],
          ),
        ),
      ),
      actions: [
         ElevatedButton(
    onPressed: () {
      if (_formKey.currentState!.validate() && _selectedCategory != null) {
        final expenseData = {
          "vehicle": "${widget.vehicle.make} ${widget.vehicle.model} ${widget.vehicle.registrationId}",
          "amount": _amountController.text,
          "date": _dateController.text,
          "category": _selectedCategory!,
          "note": _noteController.text,
        };

        widget.onSubmit(expenseData); // 🔗 callback to parent
        Navigator.pop(context); // close dialog
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all required fields")),
        );
      }
    },
    child: const Text("Submit"),
  ),
      ],
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/vehicle.dart';

class AddExpenseDialog extends StatefulWidget {
  final Vehicle vehicle;
  final Function(Map<String, String>) onSubmit;

  const AddExpenseDialog({
    super.key,
    required this.vehicle,
    required this.onSubmit,
  });

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedExpenseType;
  final _vehicleNumberController = TextEditingController();
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense submitted successfully!')),
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
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          spreadRadius: 2,
        )
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
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _selectedExpenseType = value),
              validator: (value) =>
                  value == null ? 'Please select an expense type' : null,
            ),
            const SizedBox(height: 16),

            // Vehicle Number
            TextFormField(
              controller: _vehicleNumberController,
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
