import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';

class SalesCard extends StatelessWidget {
  final String date;
  final String name;
  final String phone;
  final String address;
  final String modeOfPayment;
  final String vehicleId;
  final VoidCallback? onTap;

  SalesCard({
    super.key,
    required this.date,
    required this.name,
    required this.phone,
    required this.address,
    required this.modeOfPayment,
    required this.vehicleId,
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
                    flex: 2,
                    child: Text(
                      'Vehicle ID: $vehicleId', //unique number
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                
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
