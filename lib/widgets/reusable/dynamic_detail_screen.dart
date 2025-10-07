// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:my_new_project/core/constants/constant.dart';

// class DynamicDetailEditScreen extends StatefulWidget {
//   final String title;
//   final Map<String, dynamic> data;
//   final bool isEditMode;
//   final Function(Map<String, dynamic>) onSave;
//   //sales
//   final String? date;

//   const DynamicDetailEditScreen({
//     Key? key,
//     required this.title,
//     required this.data,
//     required this.isEditMode,
//     required this.onSave,
//     this.date,
//   }) : super(key: key);

//   @override
//   State<DynamicDetailEditScreen> createState() =>
//       _DynamicDetailEditScreenState();
// }

// class _DynamicDetailEditScreenState extends State<DynamicDetailEditScreen> {
//   late Map<String, TextEditingController> _controllers;
//   late List<String> _fieldOrder;

//   @override
//   void initState() {
//     super.initState();

//     // _controllers = {
//     //   for (var entry in widget.data.entries)
//     //     entry.key: TextEditingController(text: entry.value?.toString() ?? ''),
//     // };

//     // // Optional: define field order (fallback is map order)
//     // _fieldOrder = widget.data.keys.toList();

//    final allowedFields = [
//   'name',
//   'phone',
//   'address',
//   'date',
//   'price',
//   'received_price',
//   'payment_status',
//   'account_name',
//   'reg_no',
// ];


// final filteredData = Map.fromEntries(
//   widget.data.entries.where((entry) => allowedFields.contains(entry.key))
// );

// _controllers = {
//   for (var entry in filteredData.entries)
//     entry.key: TextEditingController(text: entry.value?.toString() ?? ''),
// };

// _fieldOrder = filteredData.keys.toList();


// for (var key in _controllers.keys) {
//   if (key.toLowerCase().contains('date')) {
//     try {
//       final date = DateTime.parse(_controllers[key]!.text);
//       _controllers[key]!.text = DateFormat('dd MMM yyyy').format(date);
//     } catch (_) {}
//   }

//   if (key == 'price' || key == 'received_price') {
//     try {
//       final double amount = double.parse(_controllers[key]!.text);
//       _controllers[key]!.text = '₹${amount.toStringAsFixed(2)}';
//     } catch (_) {}
//   }
// }


//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

  

//   void _saveForm() {
//     final updatedData = {
//       for (var entry in _controllers.entries) entry.key: entry.value.text,
//     };

//     widget.onSave(updatedData);
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEditable = widget.isEditMode;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Back + Title
//               Row(
//                 children: [
//                   KHeight30,
//                 _buildIconButton(
//                   Icons.arrow_back,
//              /*onBack*/()=>Navigator.pop(context),
//                    ),
//                   const SizedBox(width: 14),
//                   Text(
//                     widget.title,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black
//                     ),
//                   ),
//                 ],
//               ),
//               KHeight20,

//               // Form Fields
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: _fieldOrder.map((fieldKey) {
//                       final controller = _controllers[fieldKey]!;

//                       final isDateField = fieldKey.toLowerCase().contains(
//                         'date',
//                       );

//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 16),
//                         child:
//                       TextFormField(
//   controller: controller,
//   readOnly: !isEditable || isDateField,
//   style: TextStyle(
//     color: Colors.black87,
//     fontSize: 16,
//     fontWeight: FontWeight.w500,
//   ),
//   decoration: InputDecoration(
//     labelText: _beautifyFieldName(fieldKey),
//     labelStyle: TextStyle(
//       color: Colors.grey[800],
//       fontWeight: FontWeight.w600,
//     ),
//     suffixIcon: isDateField
//         ? const Icon(Icons.calendar_today_outlined, size: 20)
//         : null,
//     filled: true,
//     fillColor: Colors.grey[100],
//     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide(color: Colors.grey.shade300),
//     ),
//   ),
// ),




//                       );
//                     }).toList(),

                    
//                   ),
//                 ),
//               ),

//               // Update Button
//               if (isEditable)
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _saveForm,
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'Update',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//  String _beautifyFieldName(String key) {
//   const customLabels = {
//     'name': 'Name',
//     'phone': 'Phone',
//     'address': 'Address',
//     'date': 'Date',
//     'price': 'Price',
//     'received_price': 'Received Amount',
//     'payment_status': 'Payment Status',
//     'account_name': 'Paid to Account',
//     'reg_no': 'Vehicle Reg. No',
//   };

//   return customLabels[key] ?? key;
// }


//   Widget _buildIconButton(IconData icon, VoidCallback? onPressed) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 8),
//       child: SizedBox(
//         width: 36,
//         height: 36,
//         child: IconButton(
//           onPressed: onPressed,
//           icon: Icon(icon, size: 18),
//           style: IconButton.styleFrom(
//             backgroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//               side: BorderSide(color: Colors.grey.shade300),
//             ),
//             padding: EdgeInsets.zero,
//             iconSize: 18,
//           ),
//         ),
//       ),
//     );
//   }
// }
