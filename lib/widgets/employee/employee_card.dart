import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_new_project/core/constants/constant.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String designation;
  final String salary;
  final String phone;
  final String joiningYear;
  final String status;
  final String imageUrl;
  final VoidCallback? onTap;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  const EmployeeCard({
    super.key,
    required this.name,
    required this.designation,
    required this.salary,
    required this.phone,
    required this.joiningYear,
    required this.status,
    required this.imageUrl,
    required this.onDelete,
    required this.onEdit,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl.startsWith('/')
                      ? Image.file(
                          File(imageUrl),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              //start of padding below texts
              padding: const EdgeInsets.all(16),

              child: Column(
                //stacks all rows
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    //name Row
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      Spacer(),

                      // Icon(Icons.edit_square),
                      IconButton(
                        onPressed: onEdit,
                        icon: Icon(Icons.edit_square),
                      ),

                      KWidth12,
                      // Icon(Icons.delete),
                      IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
                    ],
                  ), //end of name row
                  KHeight,
                  // Spacer between name Row and salary
                  Text(
                    '\$$salary',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                    overflow: TextOverflow.ellipsis,
                  ), //end of salary text

                  KHeight,

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Designation:$designation',
                          style: TextStyle(color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 60),
                      Text(
                        'Joining Year:$joiningYear',
                        style: TextStyle(color: Colors.black),
                        // overflow: TextOverflow.ellipsis,
                      ),
                     
                    ],

                  ),
                   Text(
                    'Phone:$phone',
                    style: TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
