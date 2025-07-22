import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';

class PurchaseCard extends StatelessWidget {
  final String id;
  final String vehicleId;
  final String name;
  final String phone;
  final String address;
  final String date;
  final String price;
  final String modeOfPayment;

   final VoidCallback? onTap;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  const PurchaseCard({
    super.key,
    required this.id,
    required this.vehicleId,
    required this.name,
    required this.phone,
    required this.address,
    required this.date,
    required this.price,
    required this.modeOfPayment,
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Row 1: Partner Name | Share % | Edit | Delete
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Vehicle ID: $vehicleId',//unique number
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    '$id',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  IconButton(onPressed: onEdit, icon: Icon(Icons.edit_square)),
                  KWidth12,
                  IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
                ],
              ),
              KHeight,

              /// Row 2: Contact Person
              Text(
                'Name: $name',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              KHeight,

              /// Row 3: Email
              Text(
                'Address: $address',
                style: TextStyle(fontSize: 16, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              KHeight,

              /// Row 4: Phone
              Text(
                'Phone: $phone',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              KHeight,

              /// Row 5: Vehicle ID | Start Date
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Price:$price',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Text(
                    'Date: $date',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  
                ],
              ),
               Text(
                    'Mode of Payment: $modeOfPayment',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

