import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SalesFilterRow extends StatelessWidget {
  final VoidCallback onEmployeesTap;
  final VoidCallback onExpenses;
  final VoidCallback onAddPressed;

  const SalesFilterRow({
    super.key,
    required this.onEmployeesTap,
    required this.onExpenses,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,
      ),
      child: Row(
        children: [
          GestureDetector(
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            
            child: Text('Employees',
            style: TextStyle(
              color: Colors.black
            ),),
              ),
              
            ),
      
          ),
      
          const SizedBox(width: 8),
        GestureDetector(
          child: Card(
            color: Colors.white,
            child: Padding(padding: 
            EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20
            ),
            child: 
            
            Text(
              'Expense',
              style: TextStyle(
                color: Colors.black
              ),
            ),
            ),
          ),
        ),
      
          const SizedBox(width: 8),
      
         ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Add'),
        onPressed: onAddPressed,
        style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
        ),
      ),
        ],
      ),
    );
  }
}
