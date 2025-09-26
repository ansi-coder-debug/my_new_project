import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const KHeight = SizedBox(height: 10);
const KHeight20 = SizedBox(height: 20);
const KWidth12 = SizedBox(width: 12);
const KHeight30 = SizedBox(height: 30);
const KHeight16 = SizedBox(height: 16);
const Kblack = TextStyle(color: Colors.black);
const Kheight6 = SizedBox(height: 6);

const List<String> vehicleStatues = [
  'Available',
  'Pending Sale'
      'Sold',
  'In Maintaince',
];

//  const base url = 'http://192.168.29.29:5000/api/';
// const base url = 'http://192.168.29.29:5000/api/;
// final registration = url + '/register';
// class ApiConstants {
//   // static const String KbaseUrl = 'http://192.168.29.29:5000/api/';

// }

const String baseUrl = "http://192.168.29.29:5000/api/";
const String HbaseUrl = "http://localhost:5000/api/";

// Text('Status', style: TextStyle(color: Colors.black)),
//               DropdownButtonFormField<String>(
//                 value: _status,
//                 decoration: InputDecoration(border: OutlineInputBorder()),
//                 items:
//                     (vehicleToEdit != null
//                             ? [
//                                 'available',
//                                 'pending sale',
//                                 'sold',
//                                 'in maintenance',
//                               ]
//                             : ['available', 'pending sale', 'in maintenance'])
//                         .map(
//                           (status) => DropdownMenuItem(
//                             value: status,
//                             child: Text(
//                               status[0].toUpperCase() + status.substring(1),
//                             ), // Capitalize display
//                             // Text(status),
//                           ),
//                         )
//                         .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _status = value!;
//                     _showSalesForm = _status == 'sold';
//                   });
//                 },
//               ),

/// Common reusable input decoration
InputDecoration kCommonInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Colors.grey),
  ),
);

//add partnership
Widget buildTextField(TextEditingController controller, String label) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(color: Colors.black)),
      SizedBox(height: 4),
      TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 16),
    ],
  );
}


//add dialogs designs
InputDecoration buildInputDecoration(String hintText, {IconData? icon}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
    filled: true,
    fillColor: const Color(0xFFF5F6FA),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    suffixIcon: icon != null
        ? Icon(icon, size: 20, color: Colors.grey[700])
        : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), // Slightly less rounded
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)), // Light grey
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.black, width: 1.5), // Black focus
    ),
  );
}
