// import 'package:flutter/material.dart';
// import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/core/models/partnership.dart';

// class PartnershipDetailsScreen extends StatelessWidget {
//   final Partnership partnership;
//   final VoidCallback onBack;
//   final VoidCallback onEdit;

//   const PartnershipDetailsScreen({
//     super.key,
//     required this.partnership,
//     required this.onBack,
//     required this.onEdit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//        body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start, //align all left
//           children: [
//             Container(
//               height: 120,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.grey,
//               ),

//               child: Stack(
//                 children: [
//                  Center(
//                    child: Text("Partnership Details",
//                    style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 24
//                    ),),
//                  ),
//                   Positioned(
//                     top: 8,
//                     left: 8,
//                     child: CircleAvatar(
//                       backgroundColor: Colors.white,
//                       child: IconButton(
//                         onPressed: onBack,
//                         icon: Icon(Icons.arrow_back, color: Colors.black),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: TextButton(
//                       onPressed: onEdit,
//                       style: TextButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Text(
//                         'Edit Partnership',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 12),
//             // Text(vehicle.year, style: TextStyle(color: Colors.black)),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(width: 10),
//                 Text(
//                   '${partnership.partnerName}',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   'Id:${partnership.id}',
//                   style: TextStyle(color: Colors.grey, fontSize: 14),
//                 ),
//               ],
//             ),

            
            
          

//             SizedBox(height: 16),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Partnership Details',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Contact Person',
//                                     style: TextStyle(color: Colors.grey),
//                                   ),
//                                   SizedBox(height: 4),
//                                   Text(
//                                     partnership.contactPerson,
//                                     style: TextStyle(color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             KWidth12,
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Email',
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                    partnership.email,
//                                     style: TextStyle(color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),

//                         Text(
//                           'Phone',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           partnership.phone,
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         SizedBox(height: 12),
//                         Text(
//                           'Share Percentage',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           partnership.sharePercentage??'No Percentage Available',
//                           // expense.description ?? 'No description available.',
//                           style: TextStyle(color: Colors.black),
//                         ),

//                         SizedBox(height: 12),

//                         Text(
//                           'Date',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           partnership.startDate,
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         SizedBox(height: 12),

//                         Text(
//                           'Vehicle Id',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           partnership.vehicleId ??'No Vehicle Id',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 16),

//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,

//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.assignment),
//                       KWidth12,
//                       Text(
//                         'Add Tasks',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Tasks',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               '0/2 Completed',
//                               style: TextStyle(color: Colors.black),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 8),
//                         TextFormField(
//                           decoration: InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(
//                               vertical: 8,
//                               horizontal: 12,
//                             ),
//                             border: OutlineInputBorder(),
//                             labelText: 'Add A New Task....',
//                             suffixIcon: Container(
//                               margin: EdgeInsets.all(6),
//                               decoration: BoxDecoration(
//                                 color: Colors.blue,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child:  IconButton(onPressed: (){},
//                                          icon: Icon(Icons.add,
//                                          color: Colors.white,)),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       )

//     );
//   }
// }
