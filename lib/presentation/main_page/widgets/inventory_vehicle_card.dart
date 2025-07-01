import 'package:flutter/material.dart';
import 'package:my_new_project/core/constant.dart';

class InventoryVehicleCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String price;
  final String mileage;
  final String color;
  final String vin;
  final String task;
  final String status;
  

  const InventoryVehicleCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.mileage,
    required this.color,
    required this.vin,
    required this.task,
    required this.status
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Column(
        //card column
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: 
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: 
                  Text(status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ))
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
                  //title row
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    Spacer(),
                    Icon(Icons.edit_square),
                    KWidth12,
                    Icon(Icons.delete),
                  ],
                ), //end of title row
                KHeight, // Spacer between Title Row and Price

                Text(
                  '\$$price',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ), //end of price text

                KHeight, //  Spacer between Price and Mileage Row

                Row(
                  children: [
                    Text(
                      'Mileage: $mileage',
                      style: TextStyle(color: Colors.black),
                    ),

                    SizedBox(width: 60),
                    Text(
                      'Color: $color',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ), // end of mileage Row

                Row(
                  // VIN & Tasks Row
                  children: [
                    Text('VIN: $vin', style: TextStyle(color: Colors.black)),

                    Spacer(),
                    Text(' tasks:$task', style: TextStyle(color: Colors.black)),
                  ],
                ), //  END of VIN Row
              ],
            ), //  END of the inner Column inside Padding
          ), //  END of the Padding
        ],
      ), //  END of Card's Column
    );
  }
}
