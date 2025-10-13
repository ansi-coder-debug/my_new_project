// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/core/models/vehicle.dart';

// class InventoryVehicleCard extends StatelessWidget {
//   final Vehicle vehicle;
//   final VoidCallback? onTap;
//   final VoidCallback? onMenu;

//   const InventoryVehicleCard({
//     super.key,
//     required this.vehicle,
//     this.onTap,
//     this.onMenu,
//   });

//   // Format currency nicely
//   String formatCurrency(String amount) {
//     final numValue = double.tryParse(amount.replaceAll(',', '')) ?? 0.0;
//     final formatter = NumberFormat.currency(
//       locale: 'en_IN',
//       symbol: '₹',
//       decimalDigits: 0,
//     );
//     return formatter.format(numValue);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final status = vehicle.status.toLowerCase();

//     // Get image or fallback
//     final imageUrl = vehicle.photos.isNotEmpty
//         ? vehicle.photos.first
//         : 'https://via.placeholder.com/300x200';

//     // Status color
//     final Color statusColor = switch (status) {
//       'sold' => Colors.red.shade600,
//       'maintenance' => Colors.amber.shade700,
//       _ => Colors.green.shade600,
//     };

//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         color: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//         elevation: 2,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔹 Image and status label
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                   child: Image.network(
//                     imageUrl,
//                     height: 150,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   top: 8,
//                   left: 8,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: statusColor,
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: Text(
//                       status.toUpperCase(),
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 4,
//                   right: 4,
//                   child: IconButton(
//                     icon: const Icon(
//                       Icons.more_vert,
//                       size: 20,
//                       color: Colors.black54,
//                     ),
//                     onPressed: onMenu,
//                   ),
//                 ),
//               ],
//             ),

//             // 🔹 Vehicle details
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child:
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "${vehicle.make} ${vehicle.model}",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Text(
//                         formatCurrency(
//                           vehicle.purchaseInfo?.price.toString() ?? '0',
//                         ),
//                         style: const TextStyle(
//                           color: Colors.black54,
//                           fontSize: 8,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Kheight6,
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "${vehicle.year} • ${vehicle.registrationId}",
//                         style: const TextStyle(
//                           fontSize: 8,
//                           color: Colors.black54,
//                         ),
//                       ),
//                       // 🔹 Price section
//                   Text(
//                     formatCurrency(
//                       vehicle.purchaseInfo?.price.toString() ?? '0',
//                     ),
//                     style: const TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 13,
//                     ),
//                   ),
//                     ],
//                   ),

//                   Kheight6,

//                   // Sale price (red)
//                   if (vehicle.saleInfo != null)
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                           // Expected price (bold black)
//                   Text(
//                     formatCurrency(vehicle.price),
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                         Text(
//                           formatCurrency(vehicle.saleInfo?.price ?? '0'),
//                           style: const TextStyle(
//                             color: Colors.red,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 8,
//                           ),
//                         ),
//                       ],
//                     ),

//                   Kheight6,

//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/vehicle.dart';

class InventoryVehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback? onTap;
  final VoidCallback? onMenu;

  const InventoryVehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
    this.onMenu,
  });

  // Format currency nicely
  String formatCurrency(dynamic amount) {
    final numValue =
        double.tryParse(amount.toString().replaceAll(',', '')) ?? 0.0;
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(numValue);
  }

  @override
  Widget build(BuildContext context) {
    final status = vehicle.status.toLowerCase();

    // image or fallback
    final imageUrl = vehicle.photos.isNotEmpty
        ? vehicle.photos.first
        : 'https://via.placeholder.com/300x200';

    // Status color
    final Color statusColor = switch (status) {
      'sold' => Colors.red.shade600,
      'maintenance' => Colors.amber.shade700,
      _ => Colors.green.shade600,
    };

    // Extract prices safely
    final purchasePrice = vehicle.purchaseInfo.price; // double
    final purchasePaid = vehicle.purchaseInfo.paidAmount; // double
    final expectedPrice = double.tryParse(vehicle.price) ?? 0.0;
    final salePrice = double.tryParse(vehicle.saleInfo?.price ?? '0') ?? 0.0;

    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Image + status + menu
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    width: double.infinity,
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
                      color: statusColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      size: 20,
                      color: Colors.black54,
                    ),
                    onPressed: onMenu,
                  ),
                ),
              ],
            ),

            // 🔹 Vehicle details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle name + purchase price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${vehicle.make} ${vehicle.model}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        formatCurrency(purchasePrice),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  Kheight6,

                  // Year + Reg + purchasePaid (green)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${vehicle.year} • ${vehicle.registrationId}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        formatCurrency(purchasePaid),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  Kheight6,

                  // Expected price (bold black) + Sale price (red)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency(expectedPrice),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        formatCurrency(salePrice),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
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
