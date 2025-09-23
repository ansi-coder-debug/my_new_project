// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:intl/intl.dart';
// // import 'package:my_new_project/application/expense/expense_provider.dart';
// // import 'package:my_new_project/core/constants/constant.dart';
// // import 'package:my_new_project/core/models/vehicle.dart';

// // class AddExpenseDialog extends ConsumerStatefulWidget {
// //  final Vehicle? vehicle; // optional now
// // final List<Vehicle>? vehicles; // optional list of vehicles for selection

// //   final VoidCallback? onExpenseAdded; // Optional callback

// //   // final Function(Map<String, String>) onSubmit;
// // const AddExpenseDialog({
// //   super.key,
// //   this.vehicle,
// //   this.vehicles,
// //   this.onExpenseAdded,
// // });


// //   @override
// //   ConsumerState<AddExpenseDialog> createState() => _AddExpenseDialogState();
// // }

// // class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
// //   final _formKey = GlobalKey<FormState>();
// //   String? _selectedExpenseType;
// //   final _vehicleNameController = TextEditingController();
// //   final _amountController = TextEditingController();
// //   final _descriptionController = TextEditingController();
// //   DateTime _selectedDate = DateTime.now();
// //   Vehicle? _selectedVehicle;


// //   final List<String> _expenseTypes = [
// //     "Vehicle Acquisition Cost",
// //     "Vehicle Maintenance",
// //     "Polishing",
// //     "Spare Parts",
// //     "Painting",
// //     "Brokerage",
// //     "Tyre",
// //   ];

// //   @override
// // void initState() {
// //   super.initState();
// //   if (widget.vehicle != null) {
// //     _selectedVehicle = widget.vehicle;
// //     _vehicleNameController.text =
// //         "${widget.vehicle!.make} ${widget.vehicle!.model} ";
// //   } else {
// //     _vehicleNameController.text = "";
// //   }
// // }


// //   void _submitForm() {
// //     if (_formKey.currentState!.validate()) {
// //       if (_selectedExpenseType == null) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Please select an expense type')),
// //         );
// //         return;
// //       }
// //       ref.read(expenseProvider.notifier).addExpense(
// //         amount: _amountController.text,
// //         description: _descriptionController.text,
// //         date: _selectedDate.toIso8601String(),
// //         vehicleId: _selectedVehicle!.id,
// //         type: _selectedExpenseType!,
// //         //  expenseType: _selectedExpenseType!,
// //       );

// //        Navigator.pop(context);
// //       if (widget.onExpenseAdded != null) widget.onExpenseAdded!();

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Expense added successfully')),
// //       );



// //     }
// //   }

  

// //   Future<void> _pickDate() async {
// //     final picked = await showDatePicker(
// //       context: context,
// //       initialDate: _selectedDate,
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime(2100),
// //     );
// //     if (picked != null) {
// //       setState(() => _selectedDate = picked);
// //     }
// //   }

// //   InputDecoration _inputDecoration(String hint) {
// //     return InputDecoration(
// //       hintText: hint,
// //       hintStyle: const TextStyle(fontSize: 14, color: Colors.black54),
// //       border: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(6),
// //         borderSide: const BorderSide(color: Colors.black12),
// //       ),
// //       enabledBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(6),
// //         borderSide: const BorderSide(color: Colors.black26),
// //       ),
// //       focusedBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(6),
// //         borderSide: const BorderSide(color: Color(0xFF5B8EFF)),
// //       ),
// //       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //       filled: true,
// //       fillColor: Colors.white,
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: const BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //         boxShadow: [
// //           BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
// //         ],
// //       ),
// //       padding: EdgeInsets.only(
// //         bottom: MediaQuery.of(context).viewInsets.bottom,
// //         left: 20,
// //         right: 20,
// //         top: 24,
// //       ),
// //       child: SingleChildScrollView(
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Header
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: const [
// //                   Text(
// //                     "Add Expense",
// //                     style: TextStyle(
// //                       fontSize: 20,
// //                       fontWeight: FontWeight.w700,
// //                       color: Colors.black87,
// //                     ),
// //                   ),
// //                   Text(
// //                     "View Report",
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.black,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 24),

// //               // Dropdown
// //               DropdownButtonFormField<String>(
// //                 value: _selectedExpenseType,
// //                 decoration: _inputDecoration("Select Vehicle Expense Type"),
// //                 items: _expenseTypes
// //                     .map(
// //                       (type) => DropdownMenuItem(
// //                         value: type,
// //                         child: Text(type, overflow: TextOverflow.ellipsis),
// //                       ),
// //                     )
// //                     .toList(),
// //                 onChanged: (value) =>
// //                     setState(() => _selectedExpenseType = value),
// //                 validator: (value) =>
// //                     value == null ? 'Please select an expense type' : null,
// //               ),
// //               const SizedBox(height: 16),


// //               // If vehicle is passed (Details page), just show read-only vehicle name
// // if (widget.vehicle != null) 
// //   TextFormField(
// //     controller: _vehicleNameController,
// //     readOnly: true,
// //     decoration: _inputDecoration("Vehicle Number"),
// //     style: TextStyle(color: Colors.black),
// //   )

// // // Otherwise (ScreenExpense), show vehicle dropdown only if expense type selected
// // else if (_selectedExpenseType != null)
// //   (widget.vehicles != null && widget.vehicles!.isNotEmpty)
// //     ? DropdownButtonFormField<Vehicle>(
// //         decoration: _inputDecoration("Select Vehicle"),
// //         items: widget.vehicles!
// //             .where((v) => v.status == "available" || v.status == "maintenance")
// //             .map(
// //               (v) => DropdownMenuItem(
// //                 value: v,
// //                 child: Text("${v.make} ${v.model}"),
// //               ),
// //             )
// //             .toList(),
// //         onChanged: (v) {
// //           setState(() {
// //             _selectedVehicle = v;
// //             _vehicleNameController.text = v != null ? "${v.make} ${v.model}" : "";
// //           });
// //         },
// //         validator: (v) => v == null ? "Please select a vehicle" : null,
// //       )
// //     : SizedBox.shrink()
// // else
// //   SizedBox.shrink(),



              

// //               // Vehicle Number
// //   //             _selectedExpenseType == null
// //   // ? SizedBox.shrink()  // If no expense type selected, show nothing
// //   // : (
// //   //     _selectedVehicle != null
// //   //       ? TextFormField(
// //   //           controller: _vehicleNameController,
// //   //           readOnly: true,
// //   //           decoration: _inputDecoration("Vehicle Number"),
// //   //           style: TextStyle(color: Colors.black),
// //   //         )
// //   //       : (widget.vehicles != null && widget.vehicles!.isNotEmpty)
// //   //           ? DropdownButtonFormField<Vehicle>(
// //   //               decoration: _inputDecoration("Select Vehicle"),
// //   //               items: widget.vehicles!
// //   //                 .where((v) => v.status == "available" || v.status == "maintenance")
// //   //                 .map(
// //   //                   (v) => DropdownMenuItem(
// //   //                     value: v,
// //   //                     child: Text("${v.make} ${v.model}"),
// //   //                   ),
// //   //                 )
// //   //                 .toList(),
// //   //               onChanged: (v) {
// //   //                 setState(() {
// //   //                   _selectedVehicle = v;
// //   //                   _vehicleNameController.text = v != null ? "${v.make} ${v.model}" : "";
// //   //                 });
// //   //               },
// //   //               validator: (v) => v == null ? "Please select a vehicle" : null,
// //   //             )
// //   //           : SizedBox.shrink()
// //   //   ),




   


// //               KHeight16,

// //               // Amount
// //               TextFormField(
// //                 controller: _amountController,
// //                 keyboardType: TextInputType.number,
// //                 decoration: _inputDecoration("Amount"),
// //                 validator: (value) {
// //                   if (value == null || value.trim().isEmpty) {
// //                     return 'Amount is required';
// //                   }
// //                   if (double.tryParse(value) == null) {
// //                     return 'Enter a valid number';
// //                   }
// //                   return null;
// //                 },
// //                 style: TextStyle(color: Colors.black),
// //               ),
// //               const SizedBox(height: 16),

// //               // Description
// //               TextFormField(
// //                 controller: _descriptionController,
// //                 decoration: _inputDecoration("Description"),
// //                 style: TextStyle(color: Colors.black),
// //               ),
// //               const SizedBox(height: 16),

// //               // Date
// //               const Text("Date", style: TextStyle(color: Colors.black87)),
// //               const SizedBox(height: 6),
// //               InkWell(
// //                 onTap: _pickDate,
// //                 child: InputDecorator(
// //                   decoration: _inputDecoration("Select date"),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Text(
// //                         DateFormat('MM/dd/yyyy').format(_selectedDate),
// //                         style: const TextStyle(color: Colors.black87),
// //                       ),
// //                       const Icon(Icons.calendar_today, size: 18),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 24),

// //               // Submit Button
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   onPressed: _submitForm,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: const Color(0xFF5B8EFF),
// //                     padding: const EdgeInsets.symmetric(vertical: 18),
// //                     textStyle: const TextStyle(fontSize: 16),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(6),
// //                     ),
// //                   ),
// //                   child: const Text(
// //                     "Submit",
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               KHeight16,
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// // add_expense_dialog.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:my_new_project/application/expense/expense_provider.dart';
// import 'package:my_new_project/application/expensetype/expensetype_provider.dart';
// import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
// import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/core/models/expensetype.dart';
// import 'package:my_new_project/core/models/vehicle.dart';

// class AddExpenseDialog extends ConsumerStatefulWidget {
//   final Vehicle? vehicle; // optional vehicle for pre‑selection
//   final List<Vehicle>? vehicles;
//   final VoidCallback? onExpenseAdded;

//   const AddExpenseDialog({
//     super.key,
//     this.vehicle,
//     this.vehicles,
//     this.onExpenseAdded,
//   });

//   @override
//   ConsumerState<AddExpenseDialog> createState() => _AddExpenseDialogState();
// }

// class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
//   final _formKey = GlobalKey<FormState>();

//   ExpenseType? _selectedExpenseType;
//   Vehicle? _selectedVehicle;
//   final _amountController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   DateTime _selectedDate = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     // Preselect vehicle if passed
//     if (widget.vehicle != null) {
//       _selectedVehicle = widget.vehicle;
//     }
//     // Also trigger load of expense types
//     Future.microtask(() {
//       ref.read(expenseTypeProvider.notifier).loadExpenseTypes();
//     });
//   }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   void _submitForm() {
//     if (!_formKey.currentState!.validate()) return;

//     if (_selectedExpenseType == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select an expense type')),
//       );
//       return;
//     }
//     if (_selectedVehicle == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a vehicle')),
//       );
//       return;
//     }

//     // assuming addExpense takes these parameters
//     ref.read(expenseProvider.notifier).addExpense(
//       amount: _amountController.text.trim(),
//       description: _descriptionController.text.trim(),
//       date: _selectedDate.toIso8601String(),
//       vehicleId: _selectedVehicle!.id,
//       type: _selectedExpenseType!.name,
//     );

//     Navigator.of(context).pop();
//     if (widget.onExpenseAdded != null) widget.onExpenseAdded!();

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Expense added successfully')),
//     );
//   }

//   InputDecoration _inputDecoration(String hint) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: const TextStyle(fontSize: 14, color: Colors.black54),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(6),
//         borderSide: const BorderSide(color: Colors.black12),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(6),
//         borderSide: const BorderSide(color: Colors.black26),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(6),
//         borderSide: const BorderSide(color: Color(0xFF5B8EFF)),
//       ),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       filled: true,
//       fillColor: Colors.white,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vehicleState = ref.watch(vehicleProvider);
//     final vehicles = widget.vehicles ?? vehicleState.vehicles;

//     final expenseTypeState = ref.watch(expenseTypeProvider);
//     final expenseTypes = expenseTypeState.expenseTypes;

//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
//         ],
//       ),
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//         left: 20,
//         right: 20,
//         top: 24,
//       ),
//       child: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text(
//                     "Add Expense",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   // you can remove "View Report" if not needed
//                   // Text(
//                   //   "View Report",
//                   //   style: TextStyle(
//                   //     fontSize: 14,
//                   //     fontWeight: FontWeight.bold,
//                   //     color: Colors.black,
//                   //   ),
//                   // ),
//                 ],
//               ),
//               const SizedBox(height: 24),

//               // Expense Type Dropdown
//               expenseTypeState.isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : DropdownButtonFormField<ExpenseType>(
//                       value: _selectedExpenseType,
//                       decoration: _inputDecoration("Select Expense Type"),
//                       items: expenseTypes
//                           .map(
//                             (et) => DropdownMenuItem<ExpenseType>(
//                               value: et,
//                               child: Text(et.name),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (val) {
//                         setState(() {
//                           _selectedExpenseType = val;
//                         });
//                       },
//                       validator: (val) => val == null ? 'Please select expense type' : null,
//                     ),
//               const SizedBox(height: 16),

//               // Vehicle selection: if a vehicle was passed, show read-only, otherwise dropdown
//               widget.vehicle != null
//                   ? TextFormField(
//                       readOnly: true,
//                       decoration: _inputDecoration("Vehicle"),
//                       initialValue: "${widget.vehicle!.make} ${widget.vehicle!.model}",
//                     )
//                   : DropdownButtonFormField<Vehicle>(
//                       value: _selectedVehicle,
//                       decoration: _inputDecoration("Select Vehicle"),
//                       items: vehicles
//                           .where((v) => v.status == "available" || v.status == "maintenance")
//                           .map((v) => DropdownMenuItem<Vehicle>(
//                                 value: v,
//                                 child: Text("${v.make} ${v.model}"),
//                               ))
//                           .toList(),
//                       onChanged: (val) {
//                         setState(() {
//                           _selectedVehicle = val;
//                         });
//                       },
//                       validator: (v) => v == null ? "Please select a vehicle" : null,
//                     ),
//               const SizedBox(height: 16),

//               // Amount
//               TextFormField(
//                 controller: _amountController,
//                 keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                 decoration: _inputDecoration("Amount"),
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return 'Amount is required';
//                   }
//                   if (double.tryParse(value.trim()) == null) {
//                     return 'Enter a valid number';
//                   }
//                   return null;
//                 },
//                 style: const TextStyle(color: Colors.black),
//               ),
//               const SizedBox(height: 16),

//               // Description
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: _inputDecoration("Description"),
//                 style: const TextStyle(color: Colors.black),
//               ),
//               const SizedBox(height: 16),

//               // Date Picker
//               const Text("Date", style: TextStyle(color: Colors.black87)),
//               const SizedBox(height: 6),
//               InkWell(
//                 onTap: _pickDate,
//                 child: InputDecorator(
//                   decoration: _inputDecoration("Select date"),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         DateFormat('MM/dd/yyyy').format(_selectedDate),
//                         style: const TextStyle(color: Colors.black87),
//                       ),
//                       const Icon(Icons.calendar_today, size: 18),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Submit Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _submitForm,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF5B8EFF),
//                     padding: const EdgeInsets.symmetric(vertical: 18),
//                     textStyle: const TextStyle(fontSize: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                   ),
//                   child: const Text(
//                     "Submit",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               KHeight16,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/application/expense/expense_provider.dart';
import 'package:my_new_project/application/expensetype/expensetype_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/core/models/expense.dart';
import 'package:my_new_project/core/models/expensetype.dart';
import 'package:my_new_project/core/models/vehicle.dart';

class AddExpenseDialog extends ConsumerStatefulWidget {
  final Vehicle? vehicle;
  const AddExpenseDialog({super.key, this.vehicle});

  @override
  ConsumerState<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();

  ExpenseType? selectedExpenseType;
  Vehicle? selectedVehicle;
  Account? selectedAccount;
  DateTime selectedDate = DateTime.now();

  final _amountController = TextEditingController();
  final _paidAmountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedVehicle = widget.vehicle;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _paidAmountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hintText, {IconData? icon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF5F6FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final double amount = double.parse(_amountController.text.trim());
      final double paid = double.parse(_paidAmountController.text.trim());

      final String paymentStatus =
          paid == amount ? 'paid' : (paid == 0 ? 'pending' : 'partial');

      final newExpense = Expense(
        id: null,
        userId: 0,
        expenseTypeId: selectedExpenseType!.id!,
        vehicleId: int.tryParse(selectedVehicle!.id),
        fromAccount: int.parse(selectedAccount!.id!),
        amount: amount,
        description: _descriptionController.text.trim(),
        paymentStatus: paymentStatus,
        expensePaid: paid,
        date: selectedDate,
        employeeId: null,
      );

      await ref.read(expenseProvider.notifier).addExpense(newExpense);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense added successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add expense: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseTypeState = ref.watch(expenseTypeProvider);
    final vehicleState = ref.watch(vehicleProvider);
    final accountState = ref.watch(accountProvider);

    final availableVehicles =
        vehicleState.vehicles.where((v) => v.status == 'available').toList();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title + Close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Add Expense",
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
            const SizedBox(height: 16),

            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Date
                    TextFormField(
                      readOnly: true,
                      decoration: _inputDecoration("Date", icon: Icons.calendar_today),
                      controller: TextEditingController(
                        text: "${selectedDate.toLocal()}".split(' ')[0],
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => selectedDate = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Expense Type
                    DropdownButtonFormField<ExpenseType>(
                      value: selectedExpenseType,
                      decoration: _inputDecoration("Select Expense Type"),
                      items: expenseTypeState.expenseTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.name),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => selectedExpenseType = val),
                      validator: (val) => val == null ? 'Please select expense type' : null,
                    ),
                    const SizedBox(height: 16),

                    // Vehicle
                    DropdownButtonFormField<Vehicle>(
                      value: selectedVehicle,
                      decoration: _inputDecoration("Select Vehicle"),
                      items: availableVehicles.map((vehicle) {
                        return DropdownMenuItem(
                          value: vehicle,
                          child: Text('${vehicle.model} - ${vehicle.registrationId}'),
                        );
                      }).toList(),
                      onChanged: widget.vehicle == null
                          ? (val) => setState(() => selectedVehicle = val)
                          : null,
                      validator: (val) => val == null ? 'Please select a vehicle' : null,
                    ),
                    const SizedBox(height: 16),

                    // Amount
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("Amount", icon: Icons.calculate),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Enter amount' : null,
                    ),
                    const SizedBox(height: 16),

                    // Paid Amount
                    TextFormField(
                      controller: _paidAmountController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("Paid Amount", icon: Icons.calculate),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Enter paid amount' : null,
                    ),
                    const SizedBox(height: 16),

                    // Account
                    DropdownButtonFormField<Account>(
                      value: selectedAccount,
                      decoration: _inputDecoration("From Account"),
                      items: accountState.accounts.map((account) {
                        return DropdownMenuItem(
                          value: account,
                          child: Text(account.name),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => selectedAccount = val),
                      validator: (val) => val == null ? 'Please select account' : null,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 2,
                      decoration: _inputDecoration("Description (Optional)"),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
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
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
