

// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/core/models/partnership.dart';

// class AddPartnershipForm extends StatefulWidget {
//   final VoidCallback? onCancel;
//   final VoidCallback onAddComplete;
//   final Partnership? partnershipToEdit;

//   const AddPartnershipForm({
//     super.key,
//     this.onCancel,
//     this.partnershipToEdit,
//     required this.onAddComplete,
//   });

//   @override
//   State<AddPartnershipForm> createState() => _AddPartnershipFormState();
// }

// class _AddPartnershipFormState extends State<AddPartnershipForm> {
//   final TextEditingController _partnerNameController = TextEditingController();
//   final TextEditingController _contactPersonController =
//       TextEditingController();
//   final TextEditingController _contactEmailController = TextEditingController();
//   final TextEditingController _contactPhoneController = TextEditingController();
//   final TextEditingController _sharePercentageController =
//       TextEditingController();
//   final TextEditingController _startDateController = TextEditingController();
//   final TextEditingController _idController = TextEditingController();

//   @override
//   void dispose() {
//     _partnerNameController.dispose();
//     _contactPersonController.dispose();
//     _contactEmailController.dispose();
//     _contactPhoneController.dispose();
//     _sharePercentageController.dispose();
//     _startDateController.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();

//     if (widget.partnershipToEdit != null) {
//       final ptp = widget.partnershipToEdit!;
//       _partnerNameController.text = ptp.partnerName;
//       _contactPersonController.text = ptp.contactPerson;
//       _contactEmailController.text = ptp.email;
//       _contactPhoneController.text = ptp.phone;
//       _sharePercentageController.text = ptp.sharePercentage;
//       _startDateController.text = ptp.startDate;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             Text("Partner Name", style: TextStyle(color: Colors.black)),
//             TextFormField(
//               controller: _partnerNameController,
//               style: TextStyle(color: Colors.black),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(
//                   vertical: 8,
//                   horizontal: 12,
//                 ),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             KHeight,
//             Text("Contact Person", style: TextStyle(color: Colors.black)),
//             TextFormField(
//               controller: _contactPersonController,
//               style: TextStyle(color: Colors.black),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(
//                   vertical: 8,
//                   horizontal: 12,
//                 ),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             KHeight,
//             Text("Contact Email", style: TextStyle(color: Colors.black)),
//             TextFormField(
//               controller: _contactEmailController,
//               style: TextStyle(color: Colors.black),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(
//                   vertical: 8,
//                   horizontal: 12,
//                 ),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             KHeight,
//             Text("Contact Phone", style: TextStyle(color: Colors.black)),
//             TextFormField(
//               controller: _contactPhoneController,
//               style: TextStyle(color: Colors.black),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(
//                   vertical: 8,
//                   horizontal: 12,
//                 ),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             KHeight,
//             Text("Share Percentage", style: TextStyle(color: Colors.black)),
//             TextFormField(
//               controller: _sharePercentageController,
//               style: TextStyle(color: Colors.black),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(
//                   vertical: 8,
//                   horizontal: 12,
//                 ),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             KHeight,
//             Text("StartDate", style: TextStyle(color: Colors.black)),
//             TextFormField(
//               controller: _startDateController,
//               style: TextStyle(color: Colors.black),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(
//                   vertical: 8,
//                   horizontal: 12,
//                 ),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             KHeight,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     widget.onCancel?.call();
//                   },
//                   child: Text('Cancel', style: TextStyle(color: Colors.black)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.zero,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final box = Hive.box<Partnership>('partnerships');

//                     final newPartnership = Partnership(
//                       id: _idController.text,
//                       partnerName: _partnerNameController.text,
//                       contactPerson: _contactPersonController.text,
//                       email: _contactEmailController.text,
//                       phone: _contactPhoneController.text,
//                       sharePercentage: _sharePercentageController.text,
//                       vehicleId: 'unLinked',
//                       startDate: _startDateController.text,
//                     );

//                     if (widget.partnershipToEdit != null) {
//                       final Key = widget.partnershipToEdit!.key;
//                       await box.put(Key, newPartnership);
//                       print('Partnership Updated');
//                     } else {
//                       await box.add(newPartnership);
//                       print('Partnership Added');
//                     }
//                     widget.onAddComplete();
//                   },

//                   child: Text(
//                     'Add Partnership',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.zero,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// new code 
import 'package:flutter/material.dart';

class AddPartnershipDialog extends StatefulWidget {
  const AddPartnershipDialog({Key? key}) : super(key: key);

  @override
  State<AddPartnershipDialog> createState() => _AddPartnershipDialogState();
}

class _AddPartnershipDialogState extends State<AddPartnershipDialog> {
  final _formKey = GlobalKey<FormState>();

  String? selectedPartner;
  String? paymentMode;
  final contributionController = TextEditingController();
  final profitShareController = TextEditingController();
  String? status1;
  String? status2;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Add Partnership",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                /// Select a Partner
                DropdownButtonFormField<String>(
                  value: selectedPartner,
                  decoration: InputDecoration(
                    labelText: "Select a Partner",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: ["Partner A", "Partner B", "Partner C"]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    selectedPartner = value;
                  }),
                  validator: (value) =>
                      value == null ? "Please select a partner" : null,
                ),
                const SizedBox(height: 12),

                /// Partner Contribution
                TextFormField(
                  controller: contributionController,
                  decoration: InputDecoration(
                    labelText: "Partner Contribution (INR)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Enter contribution amount" : null,
                ),
                const SizedBox(height: 12),

                /// Partner Profit Share Amount
                TextFormField(
                  controller: profitShareController,
                  decoration: InputDecoration(
                    labelText: "Partner Profit Share Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Enter profit share" : null,
                ),
                const SizedBox(height: 12),

                /// Payment Mode
                DropdownButtonFormField<String>(
                  value: paymentMode,
                  decoration: InputDecoration(
                    labelText: "Select Payment Mode",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: ["Cash", "Bank Transfer", "UPI"]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    paymentMode = value;
                  }),
                  validator: (value) =>
                      value == null ? "Please select a payment mode" : null,
                ),
                const SizedBox(height: 12),

                /// Status Dropdown 1
                DropdownButtonFormField<String>(
                  value: status1,
                  decoration: InputDecoration(
                    labelText: "Pending",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: ["Pending", "Paid", "Partial"]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    status1 = value;
                  }),
                ),
                const SizedBox(height: 12),

                /// Status Dropdown 2
                DropdownButtonFormField<String>(
                  value: status2,
                  decoration: InputDecoration(
                    labelText: "Pending",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: ["Pending", "Paid", "Partial"]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    status2 = value;
                  }),
                ),
                const SizedBox(height: 20),

                /// Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context); // close dialog after submit
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// /// Example usage:
// void showAddPartnershipDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) => const AddPartnershipDialog(),
//   );
// }
