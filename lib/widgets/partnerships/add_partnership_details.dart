// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_new_project/application/partnership/partnership_provider.dart';
// import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/core/models/partnership.dart';
// import 'package:uuid/uuid.dart';

// class AddPartnershipDetails extends ConsumerStatefulWidget {
//   final List<String> partners;

//   const AddPartnershipDetails(BuildContext context,
//    {Key? key, required this.partners}) : super(key: key);

//   @override
//   ConsumerState<AddPartnershipDetails> createState() => _AddPartnershipDetailsState();
// }

// class _AddPartnershipDetailsState extends ConsumerState<AddPartnershipDetails> {
//   final _formKey = GlobalKey<FormState>();

//   String? selectedPartner;
//   final TextEditingController contributionController = TextEditingController();
//   final TextEditingController profitShareController = TextEditingController();
//   String? paymentMode;
//   String? contributionStatus;
//   String? profitShareStatus;

//   final List<String> paymentModes = ['Cash', 'Bank Transfer'];
//   final List<String> contributionStatuses = ['Paid', 'Pending', 'Partial'];
//   final List<String> profitShareStatuses = ['Paid', 'Pending', 'Partial'];

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:
//           EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//       child: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Add Partnership Details',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                       color: Colors.black87),
//                 ),
//                 const SizedBox(height: 16),

//                 // Select Partner Dropdown
//                 DropdownButtonFormField<String>(
//                   value: selectedPartner,
//                   decoration: InputDecoration(
//                     labelText: 'Select a Partner',
//                     border: OutlineInputBorder(),
//                   ),
//                   items: widget.partners
//                       .map((partner) => DropdownMenuItem<String>(
//                             value: partner,
//                             child: Text(partner),
//                           ))
//                       .toList(),
//                   onChanged: (val) {
//                     setState(() {
//                       selectedPartner = val;
//                     });
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please select a partner';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 12),

//                 // Partner Contribution INR
//                 TextFormField(
//                   controller: contributionController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: 'Partner Contribution (INR)',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (val) {
//                     if (val == null || val.trim().isEmpty) {
//                       return 'Please enter contribution amount';
//                     }
//                     if (double.tryParse(val.trim()) == null) {
//                       return 'Please enter a valid number';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 12),

//                 // Partner Profit Share Amount
//                 TextFormField(
//                   controller: profitShareController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: 'Partner Profit Share Amount',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (val) {
//                     if (val == null || val.trim().isEmpty) {
//                       return 'Please enter profit share amount';
//                     }
//                     if (double.tryParse(val.trim()) == null) {
//                       return 'Please enter a valid number';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 12),

//                 // Partner Payment Mode Dropdown
//                 DropdownButtonFormField<String>(
//                   value: paymentMode,
//                   decoration: InputDecoration(
//                     labelText: 'Partner Payment Mode',
//                     border: OutlineInputBorder(),
//                   ),
//                   items: paymentModes
//                       .map((mode) => DropdownMenuItem<String>(
//                             value: mode,
//                             child: Text(mode),
//                           ))
//                       .toList(),
//                   onChanged: (val) {
//                     setState(() {
//                       paymentMode = val;
//                     });
//                   },
//                   validator: (val) =>
//                       val == null || val.isEmpty ? 'Please select payment mode' : null,
//                 ),
//                 const SizedBox(height: 12),

//                 // Contribution Status Dropdown
//                 DropdownButtonFormField<String>(
//                   value: contributionStatus,
//                   decoration: InputDecoration(
//                     labelText: 'Contribution Status',
//                     border: OutlineInputBorder(),
//                   ),
//                   items: contributionStatuses
//                       .map((status) => DropdownMenuItem<String>(
//                             value: status,
//                             child: Text(status),
//                           ))
//                       .toList(),
//                   onChanged: (val) {
//                     setState(() {
//                       contributionStatus = val;
//                     });
//                   },
//                   validator: (val) =>
//                       val == null || val.isEmpty ? 'Please select contribution status' : null,
//                 ),
//                 const SizedBox(height: 12),

//                 // Profit Share Status Dropdown
//                 DropdownButtonFormField<String>(
//                   value: profitShareStatus,
//                   decoration: InputDecoration(
//                     labelText: 'Profit Share Status',
//                     border: OutlineInputBorder(),
//                   ),
//                   items: profitShareStatuses
//                       .map((status) => DropdownMenuItem<String>(
//                             value: status,
//                             child: Text(status),
//                           ))
//                       .toList(),
//                   onChanged: (val) {
//                     setState(() {
//                       profitShareStatus = val;
//                     });
//                   },
//                   validator: (val) =>
//                       val == null || val.isEmpty ? 'Please select profit share status' : null,
//                 ),
//                 const SizedBox(height: 20),

//                 // Buttons Row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       style: TextButton.styleFrom(
//                         foregroundColor: Colors.black,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: Text('Cancel'),
//                     ),
//                    KHeight16,
//                     ElevatedButton(
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
//                       // onPressed: () {
//                       //   if (_formKey.currentState!.validate()) {
//                       //     // All validations passed, handle saving partner here
//                       //     Navigator.of(context).pop({
//                       //       'partner': selectedPartner,
//                       //       'contribution': contributionController.text.trim(),
//                       //       'profitShare': profitShareController.text.trim(),
//                       //       'paymentMode': paymentMode,
//                       //       'contributionStatus': contributionStatus,
//                       //       'profitShareStatus': profitShareStatus,
//                       //     });
//                       //   }
//                       // },
//                       // child: Text('Save Partner'),


//                       onPressed: () {
//   if (_formKey.currentState!.validate()) {
//     final newPartnership = Partnership(
//       id: const Uuid().v4(),
//       partner: selectedPartner,
//       contribution: contributionController.text.trim(),
//       profitShare: profitShareController.text.trim(),
//       paymentMode: paymentMode,
//       contributionStatus: contributionStatus,
//       profitShareStatus: profitShareStatus,
      
      
//     );

//     // Add to provider
//     ref.read(partnershipProvider.notifier).addPartnership(newPartnership);

//     // Go back to AddVehicleForm (you already do this)
//     Navigator.of(context).pop();
//   }
// }, child: Text('Save Partner'), 


//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// //Add vehicle screen 


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/partner/partner_provider.dart';
import 'package:my_new_project/application/partnership/partnership_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/partner.dart';
import 'package:uuid/uuid.dart';

class AddPartnershipDetails extends ConsumerStatefulWidget {
  const AddPartnershipDetails({Key? key}) : super(key: key);

  @override
  ConsumerState<AddPartnershipDetails> createState() => _AddPartnershipDetailsState();
}

class _AddPartnershipDetailsState extends ConsumerState<AddPartnershipDetails> {
  final _formKey = GlobalKey<FormState>();

  Partner? selectedPartner;
  final TextEditingController contributionController = TextEditingController();
  final TextEditingController profitShareController = TextEditingController();
  String? paymentMode;
  String? contributionStatus;
  String? profitShareStatus;

  final List<String> paymentModes = ['Cash', 'Bank Transfer'];
  final List<String> contributionStatuses = ['Paid', 'Pending', 'Partial'];
  final List<String> profitShareStatuses = ['Paid', 'Pending', 'Partial'];

  @override
  Widget build(BuildContext context) {
    final partners = ref.watch(partnerProvider);
    print('Partners List: $partners');


    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Partnership Details',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black87),
                ),
                const SizedBox(height: 16),

                // Partner Dropdown
                DropdownButtonFormField<Partner>(
                  value: selectedPartner,
                  decoration: InputDecoration(
                    labelText: 'Select a Partner',
                    border: OutlineInputBorder(),
                  ),
                  items: partners.map((partner) {
                    return DropdownMenuItem<Partner>(
                      value: partner,
                      child: Text(partner.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPartner = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a partner';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Contribution
                TextFormField(
                  controller: contributionController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Partner Contribution (INR)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter contribution amount';
                    }
                    if (double.tryParse(val.trim()) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

               
                

                // Payment Mode
                DropdownButtonFormField<String>(
                  value: paymentMode,
                  decoration: InputDecoration(
                    labelText: 'Partner Payment Mode',
                    border: OutlineInputBorder(),
                  ),
                  items: paymentModes
                      .map((mode) => DropdownMenuItem<String>(
                            value: mode,
                            child: Text(mode),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      paymentMode = val;
                    });
                  },
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Please select payment mode' : null,
                ),
                const SizedBox(height: 12),

                // Contribution Status
                DropdownButtonFormField<String>(
                  value: contributionStatus,
                  decoration: InputDecoration(
                    labelText: 'Contribution Status',
                    border: OutlineInputBorder(),
                  ),
                  items: contributionStatuses
                      .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      contributionStatus = val;
                    });
                  },
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Please select contribution status' : null,
                ),
                const SizedBox(height: 12),

                

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    KHeight16,
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final newPartnership = Partnership(
                            id: const Uuid().v4(),
                            partner: selectedPartner!.name,
                            contribution: contributionController.text.trim(),
 
                            paymentMode: paymentMode!,
                            contributionStatus: contributionStatus!,
                           
                          );

                          // Add to provider
                          ref.read(partnershipProvider.notifier).addPartnership(newPartnership);

                          // Return the new partnership to the parent screen
                          Navigator.of(context).pop(newPartnership);
                        }
                      },
                      child: Text('Save Partner'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


