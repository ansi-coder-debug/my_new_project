import 'package:flutter/material.dart';
import 'package:my_new_project/widgets/common_search_bar.dart';

class ScreenExpense extends StatelessWidget {
  const ScreenExpense({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: ListView(
        children: [
          CommonSearchBar(
            labelText: 'Expense Page',
           hintText: 'Expense',
           onChanged: (p0) {
             
           },
            )
        ],
      ),

    );
  }
}