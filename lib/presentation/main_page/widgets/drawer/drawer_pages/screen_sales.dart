import 'package:flutter/material.dart';
import 'package:my_new_project/widgets/common_search_bar.dart';
import 'package:my_new_project/widgets/expense_card.dart';
import 'package:my_new_project/widgets/sales_filter_row.dart';

class ScreenSales extends StatefulWidget {
  const ScreenSales({super.key});

  @override
  State<ScreenSales> createState() => _ScreenSalesState();
}

class _ScreenSalesState extends State<ScreenSales> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: 
    ListView(
      children: [
        CommonSearchBar(
          labelText: 'Search   ', 
          hintText: 'Search Employees,Expense',
           onChanged: (sales){
            setState(() {
              //Optional: Add search functionality if you want
            });
           },
           ),
           SalesFilterRow(
            onEmployeesTap: (){},
            onExpenses:  (){},
             onAddPressed:  (){}
             ),
             ExpenseCard(
              initials: 'Aj',
               initialColor: Colors.blue, 
               title:'Vehicle Transportation' ,
                category: 'Logistics', 
                status: 'Approved', 
                statusColor: Colors.green,
                 amount:'\$25,000',
                  date: 'July 8,2024', 
                  onTap: (){}
                  ),
                    ExpenseCard(
              initials: 'Aj',
               initialColor: Colors.blue, 
               title:'Vehicle Transportation' ,
                category: 'Logistics', 
                status: 'Approved', 
                statusColor: Colors.green,
                 amount:'\$25,000',
                  date: 'July 8,2024', 
                  onTap: (){}
                  ),
                    ExpenseCard(
              initials: 'Aj',
               initialColor: Colors.blue, 
               title:'Vehicle Transportation' ,
                category: 'Logistics', 
                status: 'Approved', 
                statusColor: Colors.green,
                 amount:'\$25,000',
                  date: 'July 8,2024', 
                  onTap: (){}
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Text(
                    '+ View all expenses',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                    ),
                  )

             
      ],
    ),

       
       
       
    );
  }
}