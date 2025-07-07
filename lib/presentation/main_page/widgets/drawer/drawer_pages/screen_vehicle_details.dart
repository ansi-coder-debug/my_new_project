import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/vehicle.dart';

class ScreenVehicleDetails extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onBack;


  const ScreenVehicleDetails
  (
    {
      super.key,
       required this.vehicle,
       required this.onBack
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            
            IconButton(
              onPressed: onBack,
             icon:Icon(Icons.arrow_back) 
             ),
          Image.file(File(vehicle.imageUrl)),
          SizedBox(height: 8),         //codeeeeeeeeeeeeeee
          Text(vehicle.title ),

          SizedBox(height: 8),
          Text(vehicle.year,
          style: TextStyle(
            color: Colors.black
          ),),

          SizedBox(height: 8),
          Text(vehicle.price,
          style: TextStyle(
            color: Colors.black
          ),),

          SizedBox(height: 8),
          Text(vehicle.mileage,style: TextStyle(
            color: Colors.black
          ),),
          SizedBox(height: 8),

          Text(vehicle.vin,style: TextStyle(
            color: Colors.black
          ),),
          SizedBox(height: 8),

          Text(vehicle.color,style: TextStyle(
            color: Colors.black
          ),),
          SizedBox(height: 8),
          
          Text(vehicle.status,style: TextStyle(
            color: Colors.black
          ),),
          SizedBox(height: 8),
          
          // Text(vehicle.description),
          //  SizedBox(height: 8)
        ],
        ),
        
      ),
    );
  }
}
