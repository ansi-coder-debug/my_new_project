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
const String HbaseUrl = "http://localhost:5000/api";

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


  Widget _buildIconButton(IconData icon, VoidCallback? onPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: SizedBox(
        width: 36,
        height: 36,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            padding: EdgeInsets.zero,
            iconSize: 18,
          ),
        ),
      ),
    );
  }



/*ADD Vehicle Form Constant button style etcc */

const Color kPrimaryBlue = Color(0xFF3366FF);
const Color kLightGreyBackground = Color(0xFFF7F9FC);
const Color kInputFillColor = Color(0xFFF0F2F5);
const Color kInputBorderColor = Color(0xFFE0E0E0);
const Color kDarkText = Color(0xFF333333);
const Color kLightText = Color(0xFF666666);
const Color kErrorRed = Color(0xFFE57373); // A standard error red

// --- Input Decoration ---
final InputDecoration kInputDecoration = InputDecoration(
  filled: true,
  fillColor: kInputFillColor,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: kInputBorderColor, width: 1),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: kInputBorderColor, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(color: kPrimaryBlue, width: 1), // Blue focus border
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(color: kErrorRed, width: 1),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(color: kErrorRed, width: 1),
  ),
  hintStyle: const TextStyle(color: kLightText, fontSize: 15),
  labelStyle: const TextStyle(color: kDarkText, fontSize: 15),
  floatingLabelBehavior: FloatingLabelBehavior.never, // Labels don't float for this design
);

// --- Button Styles ---
final ButtonStyle kPrimaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: kPrimaryBlue,
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
  ),
  elevation: 0, // Flat button
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
);

final ButtonStyle kSecondaryButtonStyle = TextButton.styleFrom(
  backgroundColor: const Color(0xFFE6E8EA), // Light grey for secondary buttons
  foregroundColor: kDarkText,
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  textStyle: const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  ),
);