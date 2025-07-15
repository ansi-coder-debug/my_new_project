import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmployeeFilterRow extends StatelessWidget {
  final String selectedStatus;
   final String selectedSort;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onSortingChanged;
  final VoidCallback onAddPressed;

  const EmployeeFilterRow({
   super.key,
   required this.selectedStatus,
    required this.selectedSort,
    required this.onStatusChanged,
    required this.onSortingChanged,
    required this.onAddPressed,

  });
  
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: selectedStatus,
              decoration: const InputDecoration(
                // labelText: 'Status',
                border: OutlineInputBorder(),
              ),

              items:
                  [
                    'All Status',   
                    'Active',
                    'Inactive',
                    'Onleave',
                    
                  ].map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),

              onChanged: (value) {
                onStatusChanged(value);
              },
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: selectedSort,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items:
                  [
                    'Newest First',
                    'Oldest First',
                    'Salary High to Low',
                    'Salary Low to High',
                  ].map((sortOption) {
                    return DropdownMenuItem(
                      value: sortOption,
                      child: Text(sortOption),
                    );
                  }).toList(),
              onChanged: (value) {
                onSortingChanged(value);
              },
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add'),
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
