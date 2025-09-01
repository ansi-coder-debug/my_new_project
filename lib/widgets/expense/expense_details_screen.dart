// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/core/models/expense.dart';

// class ExpenseDetailsScreen extends StatelessWidget {
//   final Expense expense;
//   final VoidCallback onBack;
//   final VoidCallback onEdit;

//   const ExpenseDetailsScreen({
//     super.key,
//     required this.expense,
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
//                    child: Text("Expense Details",
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
//                         'Edit Expenses',
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
//                   '${expense.title}',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   'Id:${expense.id}',
//                   style: TextStyle(color: Colors.grey, fontSize: 14),
//                 ),
//               ],
//             ),

//             SizedBox(height: 12),
//             // Text(vehicle.price, style: TextStyle(color: Colors.black)),
//             Column(
//               children: [
//                 Icon(
//                   expense.paymentMode == 'Card'?
//                   Icons.credit_card
//                   :expense.paymentMode == 'Cheque'
//                   ?Icons.receipt
//                   :Icons.attach_money,
//                   color: Colors.blue,
//                   size: 28,
//                 ),



              
//                 SizedBox(height: 8),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: Colors.grey.withOpacity(0.1),
//                   ),
//                   child: Text(
//                     expense.status,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                       color: Colors.black,
//                     ),
//                   ),
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
//                     'Expense Details',
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
//                                     'Category',
//                                     style: TextStyle(color: Colors.grey),
//                                   ),
//                                   SizedBox(height: 4),
//                                   Text(
//                                     expense.category,
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
//                                     'Date',
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                    expense.date,
//                                     style: TextStyle(color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),

//                         Text(
//                           'Amount',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           expense.amount,
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         SizedBox(height: 12),
//                         Text(
//                           'Description',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           expense.description ?? 'No description available.',
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
//                         'Expense Tasks',
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
//       ),
      





//     );
//   }
// }

//   // Text(
//                 //   '\$${expense.paymentMode}',
//                 //   style: TextStyle(
//                 //     fontSize: 24,
//                 //     color: Colors.blue,
//                 //     fontWeight: FontWeight.bold,
//                 //   ),
//                 // ),