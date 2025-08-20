import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/vehicle.dart';

class InventoryVehicleCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String price;
  final String registrationId;
  final String color;
  final String vin;
  final String task;
  final String status;
  final String year;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback? onTap;

  const InventoryVehicleCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.registrationId,
    required this.color,
    required this.vin,
    required this.task,
    required this.status,
    required this.year,
    required this.onDelete,
    required this.onEdit,
    this.onTap,
  });

 Widget _buildVehicleImage() {
  if (imageUrl.isEmpty) {
    return const Placeholder(
      fallbackHeight: 200,
      fallbackWidth: double.infinity,
    );
  }
  
  // Handle network images (HTTP/HTTPS)
  if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  // Handle local files (for when you're adding new images)
  if (!kIsWeb) {
    return Image.file(
      File(imageUrl),
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
    );
  }

  // Web fallback for local paths
  return Container(
    height: 200,
    width: double.infinity,
    color: Colors.grey[200],
    child: const Icon(Icons.car_repair, size: 50),
  );
}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      child: Card(
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
                  child:_buildVehicleImage(),
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

                      // Icon(Icons.edit_square),
                      IconButton(
                        onPressed: onEdit,
                        icon: Icon(Icons.edit_square),
                      ),

                      KWidth12,
                      // Icon(Icons.delete),
                      IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
                    ],
                  ), //end of title row
                  KHeight,

                  // Spacer between Title Row and Price

                  // Text('year:$year'),
                  Text(
                    '\$$price',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ), //end of price text

                  KHeight, //  Spacer between Price and Mileage Row

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'RegistrationId: $registrationId',
                          style: TextStyle(color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Color: $color',
                          style: TextStyle(color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ), // end of mileage Row

                  Row(
                    // VIN & Tasks Row
                    children: [
                      Text('VIN: $vin', style: TextStyle(color: Colors.black)),

                      Spacer(),
                      Text(
                        ' tasks:$task',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ), //  END of VIN Row
                ],
              ), //  END of the inner Column inside Padding
            ), //  END of the Padding
          ],
        ), //  END of Card's Column
      ),
    );
  }
}
