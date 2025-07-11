import 'package:flutter/material.dart';
import 'package:my_new_project/widgets/common_search_bar.dart';

class ScreenEmployees extends StatelessWidget {
  const ScreenEmployees({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          CommonSearchBar(
            labelText: 'Employees Page',
           hintText: 'Employees',
           onChanged: (p0) {
             
           },
            )
        ],
      ),
      
    );
  }
}