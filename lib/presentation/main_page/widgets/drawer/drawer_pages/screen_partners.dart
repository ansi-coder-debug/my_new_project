// // import 'package:flutter/material.dart';
// // import 'package:flutter/widgets.dart';
// // import 'package:hive_flutter/adapters.dart';
// // import 'package:my_new_project/core/models/partnership.dart';
// // import 'package:my_new_project/widgets/common_search_bar.dart';
// // import 'package:my_new_project/widgets/partnerships/add_partnership_form.dart';
// // import 'package:my_new_project/widgets/partnerships/partnership_card.dart';
// // import 'package:my_new_project/widgets/partnerships/partnership_details_screen.dart';
// // import 'package:my_new_project/widgets/partnerships/partnership_filter_row.dart';

// // class ScreenPartnerships extends StatefulWidget {
// //   const ScreenPartnerships({super.key});

// //   @override
// //   State<ScreenPartnerships> createState() => _ScreenPartnershipsState();
// // }

// // class _ScreenPartnershipsState extends State<ScreenPartnerships> {
// //   bool showAddPartnershipForm = false;
// //   Partnership? partnershipToEdit;

// //   //details page
// //   bool showPartnershipDetails = false;
// //   Partnership? selectedPartnership;

// //   //delete from bothpages
  

// //   final Box<Partnership> partnershipBox = Hive.box<Partnership>('partnerships');

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: showAddPartnershipForm
// //           ?
// //             // If true, show the Add Expense Form instead of the list
// //             AddPartnershipDialog(
// //               onCancel: () {
// //                 // 👉 When user clicks 'Cancel' inside the form:
// //                 // Close the form and show the list again
// //                 setState(() {
// //                   showAddPartnershipForm = false;
// //                 });
// //               },
// //               onAddComplete: () {
// //                 // 👉 When user completes adding a new expense:
// //                 // Close the form and show the list again
// //                 setState(() {
// //                   showAddPartnershipForm = false;
// //                 });
// //               },
// //               partnershipToEdit: partnershipToEdit,

// //               // ✅ If false, show the normal Expense List page UI
// //             )
// //           : showPartnershipDetails && selectedPartnership != null
// //           ? PartnershipDetailsScreen(
// //               partnership: selectedPartnership!,
// //               onBack: () {
// //                 setState(() {
// //                   showAddPartnershipForm = false;
// //                   selectedPartnership = null;
// //                 });
// //               },
// //               onEdit: () {
// //                 setState(() {
// //                   partnershipToEdit = selectedPartnership;
// //                   showPartnershipDetails = false;
// //                   showAddPartnershipForm = true;
// //                 });
// //               },
// //             )
// //           : ValueListenableBuilder(
// //               valueListenable: Hive.box<Partnership>(
// //                 'partnerships',
// //               ).listenable(),
// //               builder: (context, box, _) {
// //                 //getting details of partnerships
// //                 List<Partnership> partnerships = box.values.toList();
// //                 //Get all keys as numbers in a list
// //                 List<dynamic> keys = box.keys.toList();

// //                 return Column(
// //                   children: [
// //                     CommonSearchBar(
// //                       labelText: "Partnership Page",
// //                       hintText: 'Partnership',
// //                       onChanged: (p0) {},
// //                     ),
// //                     PartnershipFilterRow(
// //                       onAddPressed: () {
// //                         setState(() {
// //                           partnershipToEdit = null;
// //                           showAddPartnershipForm = true;
// //                         });
// //                       },
// //                     ),
// //                     Expanded(
// //                       child: ListView.builder(
// //                         itemCount: partnerships.length,
// //                         itemBuilder: (context, index) {
// //                           final Partnership = partnerships[index];
// //                           return PartnershipCard(
// //                             id: Partnership.id,
// //                             partnerName: Partnership.partnerName,
// //                             contactPerson: Partnership.contactPerson,
// //                             email: Partnership.email,
// //                             phone: Partnership.phone,
// //                             sharePercentage: Partnership.sharePercentage,
// //                             vehicleId: Partnership.vehicleId,
// //                             startDate: Partnership.startDate,
// //                             onDelete: () async {
// //                               await partnerships[index].delete();
// //                             },
// //                             onEdit: () {
// //                               setState(() {
// //                                 partnershipToEdit = Partnership;
// //                                 showAddPartnershipForm = true;
// //                               });
// //                             },
// //                             onTap: () {
// //                               setState(() {
// //                                 selectedPartnership = Partnership;
// //                                 showPartnershipDetails = true;
// //                               });
// //                             },
// //                           );
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //     );
// //   }
// // }
// //  // children: [
// //       //   
// //       //   PartnershipFilterRow(
// //       //     onAddPressed: () {
// //       //       setState(() {
// //       //         showAddPartnershipForm = true;
// //       //       });
// //       //     },
// //       //   ),
// //       // ],
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
















// latest code 


// class ScreenPartnerships extends ConsumerStatefulWidget {
//   const ScreenPartnerships({super.key});

//   @override
//   ConsumerState<ScreenPartnerships> createState() => _ScreenPartnershipsState();
// }

// class _ScreenPartnershipsState extends ConsumerState<ScreenPartnerships> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5FB), // Light bluish background
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title and Buttons Container
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFF1F5FB),
//                 border: Border(
//                   bottom: BorderSide(color: Colors.black12),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Partners',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF00113B),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       _iconButton(Icons.filter_list, onTap: () {
//                         // TODO: Filter action
//                       }),
//                       const SizedBox(width: 8),
//                       _iconButton(Icons.refresh, onTap: () {
//                         // TODO: Refresh action
//                       }),
//                       const SizedBox(width: 8),
//                       _iconButton(Icons.search, onTap: () {
//                         // TODO: Search action
//                       }),
//                       const SizedBox(width: 8),
//                       _iconButton(Icons.add, iconColor: Colors.blue, onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const AddPartnershipForm(),
//                           ),
//                         );
//                       }),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // No Partners Message
//             const Expanded(
//               child: Center(
//                 child: Text(
//                   "No Partner found.",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _iconButton(IconData icon,
//       {VoidCallback? onTap, Color iconColor = Colors.black}) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         width: 36,
//         height: 36,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(
//           icon,
//           size: 20,
//           color: iconColor,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/partner/partner_provider.dart';
import 'package:my_new_project/application/partnership/partnership_provider.dart';
import 'package:my_new_project/widgets/partnerships/add_partner_form.dart';

class PartnersPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partners = ref.watch(partnerProvider);

    // final partnershipState = ref.watch(partnershipProvider);
    // final partners = partnershipState.partnerships;

    return Scaffold(
      appBar: AppBar(title: Text('Partners')),
      body: ListView.builder(
        itemCount: partners.length,
        itemBuilder: (context, index) {
          final partner = partners[index];
          return ListTile(
            title: Text(partner.name??''), // partner name
            subtitle: Text(partner.phone ?? ''), // assuming phone field exists
            // You can add buttons here for edit/delete if needed
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddPartnerForm(),
      ),
    );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
