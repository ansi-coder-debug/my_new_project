import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/common_search_bar.dart';
import 'package:my_new_project/widgets/employes_card.dart';
import 'package:my_new_project/widgets/expense_card.dart';
import 'package:my_new_project/widgets/common_filter_row.dart';

class ScreenSales extends StatefulWidget {
  const ScreenSales({super.key});

  @override
  State<ScreenSales> createState() => _ScreenSalesState();
}

class _ScreenSalesState extends State<ScreenSales> {
  String selectedSection = 'all';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          CommonSearchBar(
            labelText: 'Search   ',
            hintText: 'Search Employees,Expense',
            onChanged: (sales) {
              setState(() {
                //Optional: Add search functionality if you want
              });
            },
          ),



          // sales page code only here the current code in this page is wrong because it got mixed up these 
          // these codes will be used in employees and expense page





          // SalesFilterRow(
          //   selectedSection: selectedSection,
          //   onSectionChanged: (value) {
          //     setState(() {
          //       selectedSection = value ?? 'all ';
          //     });
          //   },
          //   onAddPressed: () {
          //     //page route
          //   },
          // ),
          
  //  if(selectedSection == 'all' || selectedSection == 'expense')
  //         Card(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           elevation: 2,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(16),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Text('💰 ', style: TextStyle(fontSize: 20)),
  //                         Text(
  //                           'Expense',
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 25,
  //                           ),
  //                         ),
  //                       ],
  //                       //
  //                     ),
  //                     Text(
  //                       '8',
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               ExpenseCard(
  //                 initials: 'Aj',
  //                 initialColor: Colors.blue,
  //                 title: 'Vehicle Transportation',
  //                 category: 'Logistics',
  //                 status: 'Approved',
  //                 statusColor: Colors.green,
  //                 amount: '\$25,000',
  //                 date: 'July 8,2024',
  //                 onTap: () {},
  //               ),
  //               ExpenseCard(
  //                 initials: 'Aj',
  //                 initialColor: Colors.blue,
  //                 title: 'Vehicle Transportation',
  //                 category: 'Logistics',
  //                 status: 'Approved',
  //                 statusColor: Colors.green,
  //                 amount: '\$25,000',
  //                 date: 'July 8,2024',
  //                 onTap: () {},
  //               ),
  //               ExpenseCard(
  //                 initials: 'Aj',
  //                 initialColor: Colors.blue,
  //                 title: 'Vehicle Transportation',
  //                 category: 'Logistics',
  //                 status: 'Approved',
  //                 statusColor: Colors.green,
  //                 amount: '\$25,000',
  //                 date: 'July 8,2024',
  //                 onTap: () {},
  //               ),
  //               Card(
  //                 color: Colors.white,
  //                 margin: const EdgeInsets.symmetric(
  //                   vertical: 8,
  //                   horizontal: 16,
  //                 ),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: InkWell(
  //                   onTap: () {},
  //                   borderRadius: BorderRadius.circular(8),
  //                   child: Padding(
  //                     padding: EdgeInsets.symmetric(vertical: 12),

  //                     child: Center(
  //                       child: Text(
  //                         '+ View all expenses',
  //                         style: TextStyle(
  //                           color: Colors.grey,
  //                           fontSize: 12,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),

  //                 //
  //               ),
  //             ],
  //           ),
  //         ),

  //         KHeight,


  //         if(selectedSection == 'all' || selectedSection == 'employees')
  //         Card(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           elevation: 2,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(16),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Icon(Icons.person),

  //                           Text(
  //                             'Employees',
  //                             style: TextStyle(
  //                               color: Colors.black,
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 25,
  //                             ),
  //                           ),
  //                         ],
  //                         //
  //                       ),
  //                       Text(
  //                         '80',
  //                         style: TextStyle(
  //                           fontSize: 16,
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(height: 10),
  //                 EmployesCard(
  //                   avatarColor: Colors.red,
  //                   department: 'Software Development',
  //                   employeeId: 'EMP-001',
  //                   initials: 'TC',
  //                   joinedDate: 'Joined June 15,2023',
  //                   name: 'Tom Cruise',
  //                   onTap: () {},
  //                   status: 'Active',
  //                   statusColor: Colors.green,
  //                 ),
  //                 SizedBox(height: 8),

  //                 EmployesCard(
  //                   avatarColor: Colors.blueAccent,
  //                   department: 'Software Develepment',
  //                   employeeId: 'EMP-001',
  //                   initials: 'TC',
  //                   joinedDate: 'Joined June 15, 2023',
  //                   name: 'Tom Cruise',
  //                   onTap: () {},
  //                   status: 'Active',
  //                   statusColor: Colors.green,
  //                 ),
  //                 SizedBox(height: 8),

  //                 EmployesCard(
  //                   avatarColor: Colors.green,
  //                   department: 'Software Develepment',
  //                   employeeId: 'EMP-001',
  //                   initials: 'TC',
  //                   joinedDate: 'Joined June 15,2023',
  //                   name: 'Tom Cruise',
  //                   onTap: () {},
  //                   status: 'Active',
  //                   statusColor: Colors.green,
  //                 ),
  //                 SizedBox(height: 8),
  //                 Card(
  //                   color: Colors.white,
  //                   margin: const EdgeInsets.symmetric(
  //                     vertical: 8,
  //                     horizontal: 16,
  //                   ),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                   child: InkWell(
  //                     onTap: () {},
  //                     borderRadius: BorderRadius.circular(8),
  //                     child: Padding(
  //                       padding: EdgeInsets.symmetric(vertical: 12),

  //                       child: Center(
  //                         child: Text(
  //                           '+ View all All Employees',
  //                           style: TextStyle(
  //                             color: Colors.grey,
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
        ],
      ),
    );
  }
}
