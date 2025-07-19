// import 'package:flutter/material.dart';
// import 'package:my_new_project/core/constants/constant.dart';

// class PartnershipCard extends StatelessWidget {
//   final String id;
//   final String partnerName;
//   final String contactPerson;
//   final String email;
//   final String phone;
//   final String sharePercentage;
//   final String vehicleId;
//   final String startDate;

//   final VoidCallback? onTap;
//   final VoidCallback onEdit;
//   final VoidCallback? onDelete;

//   const PartnershipCard({
//     super.key,
//     required this.id,
//     required this.partnerName,
//     required this.contactPerson,
//     required this.email,
//     required this.phone,
//     required this.sharePercentage,
//     required this.vehicleId,
//     required this.startDate,

//     required this.onDelete,
//     required this.onEdit,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 4,
//         margin: EdgeInsets.all(16),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       partnerName,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   IconButton(onPressed: onEdit, icon: Icon(Icons.edit_square)),
//                   KWidth12,
//                   IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
//                 ],
//               ),
//               KHeight,
//               Text(
//                 'Contact Person : $contactPerson',
//                 style: TextStyle(fontSize: 20, color: Colors.black),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               KHeight,
//               Row(
//                 children: [
//                   Expanded(
//                     child:Text(
//                       'Email: $email',
//                 style: TextStyle(fontSize: 20, color: Colors.black),
//                 overflow: TextOverflow.ellipsis,
//                     )
//                      )
//                 ],
//               )

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';

class PartnershipCard extends StatelessWidget {
  final String id;
  final String partnerName;
  final String contactPerson;
  final String email;
  final String phone;
  final String sharePercentage;
  final String vehicleId;
  final String startDate;

  final VoidCallback? onTap;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  const PartnershipCard({
    super.key,
    required this.id,
    required this.partnerName,
    required this.contactPerson,
    required this.email,
    required this.phone,
    required this.sharePercentage,
    required this.vehicleId,
    required this.startDate,
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
                      partnerName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    '$sharePercentage%',
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
                'Contact Person: $contactPerson',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              KHeight,

              /// Row 3: Email
              Text(
                'Email: $email',
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
                      'Vehicle ID: $vehicleId',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Text(
                    'Start: $startDate',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
