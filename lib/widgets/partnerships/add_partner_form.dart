// // new code
// import 'package:flutter/material.dart';

// class AddPartnershipDialog extends StatefulWidget {
//   const AddPartnershipDialog({Key? key}) : super(key: key);

//   @override
//   State<AddPartnershipDialog> createState() => _AddPartnershipDialogState();
// }

// class _AddPartnershipDialogState extends State<AddPartnershipDialog> {
//   final _formKey = GlobalKey<FormState>();

//   String? selectedPartner;
//   String? paymentMode;
//   final contributionController = TextEditingController();
//   final profitShareController = TextEditingController();
//   String? status1;
//   String? status2;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Text(
//                     "Add Partnership",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.indigo,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 /// Select a Partner
//                 DropdownButtonFormField<String>(
//                   value: selectedPartner,
//                   decoration: InputDecoration(
//                     labelText: "Select a Partner",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   items: ["Partner A", "Partner B", "Partner C"]
//                       .map((e) => DropdownMenuItem(
//                             value: e,
//                             child: Text(e),
//                           ))
//                       .toList(),
//                   onChanged: (value) => setState(() {
//                     selectedPartner = value;
//                   }),
//                   validator: (value) =>
//                       value == null ? "Please select a partner" : null,
//                 ),
//                 const SizedBox(height: 12),

//                 /// Partner Contribution
//                 TextFormField(
//                   controller: contributionController,
//                   decoration: InputDecoration(
//                     labelText: "Partner Contribution (INR)",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) =>
//                       value!.isEmpty ? "Enter contribution amount" : null,
//                 ),
//                 const SizedBox(height: 12),

//                 /// Partner Profit Share Amount
//                 TextFormField(
//                   controller: profitShareController,
//                   decoration: InputDecoration(
//                     labelText: "Partner Profit Share Amount",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) =>
//                       value!.isEmpty ? "Enter profit share" : null,
//                 ),
//                 const SizedBox(height: 12),

//                 /// Payment Mode
//                 DropdownButtonFormField<String>(
//                   value: paymentMode,
//                   decoration: InputDecoration(
//                     labelText: "Select Payment Mode",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   items: ["Cash", "Bank Transfer", "UPI"]
//                       .map((e) => DropdownMenuItem(
//                             value: e,
//                             child: Text(e),
//                           ))
//                       .toList(),
//                   onChanged: (value) => setState(() {
//                     paymentMode = value;
//                   }),
//                   validator: (value) =>
//                       value == null ? "Please select a payment mode" : null,
//                 ),
//                 const SizedBox(height: 12),

//                 /// Status Dropdown 1
//                 DropdownButtonFormField<String>(
//                   value: status1,
//                   decoration: InputDecoration(
//                     labelText: "Pending",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   items: ["Pending", "Paid", "Partial"]
//                       .map((e) => DropdownMenuItem(
//                             value: e,
//                             child: Text(e),
//                           ))
//                       .toList(),
//                   onChanged: (value) => setState(() {
//                     status1 = value;
//                   }),
//                 ),
//                 const SizedBox(height: 12),

//                 /// Status Dropdown 2
//                 DropdownButtonFormField<String>(
//                   value: status2,
//                   decoration: InputDecoration(
//                     labelText: "Pending",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   items: ["Pending", "Paid", "Partial"]
//                       .map((e) => DropdownMenuItem(
//                             value: e,
//                             child: Text(e),
//                           ))
//                       .toList(),
//                   onChanged: (value) => setState(() {
//                     status2 = value;
//                   }),
//                 ),
//                 const SizedBox(height: 20),

//                 /// Submit Button
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         Navigator.pop(context); // close dialog after submit
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.indigo,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text("Submit"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // /// Example usage:
// // void showAddPartnershipDialog(BuildContext context) {
// //   showDialog(
// //     context: context,
// //     barrierDismissible: false,
// //     builder: (context) => const AddPartnershipDialog(),
// //   );
// // }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/partner/partner_provider.dart';
import 'package:my_new_project/application/partnership/partnership_provider.dart';
import 'package:my_new_project/core/models/partner.dart';
import 'package:my_new_project/core/models/partnership.dart';

class AddPartnerForm extends ConsumerStatefulWidget {
  @override
  _AddPartnerFormState createState() => _AddPartnerFormState();
}

class _AddPartnerFormState extends ConsumerState<AddPartnerForm> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedPartner;
  String? _contactPhone;
  String? _address; // optional, no need to save in model

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Partner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Partner Detail',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Partner Name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter partner name';
                  }
                  return null;
                },
                onSaved: (value) => _selectedPartner = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contact Phone',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                ),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _contactPhone = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                ),
                maxLines: 3,
                onSaved: (value) =>
                    _address = value, // optional, won't save in model
              ),
              SizedBox(height: 24),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // Create Partnership object without address (optional)
                      final newPartner = Partner(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _selectedPartner!,
                        email: '', // or collect from a field
                        phone: _contactPhone ?? '',
                      );

                      // Add partner to provider
                      ref.read(partnerProvider.notifier).addPartner(newPartner);

                      // Close form or show success message
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
