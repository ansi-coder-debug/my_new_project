// import 'package:flutter/material.dart';
// import 'package:my_new_project/core/constants/constant.dart';

// class OutputCard extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final String? phone;
//   final double amount;
//   final double? received;
//   final double? balance;
//   final VoidCallback? onView;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;
//   final bool showMenu;

//   const OutputCard({
//     Key? key,
//     required this.title,
//     required this.subtitle,
//     required this.amount,
//     this.phone,
//     this.received,
//     this.balance,
//     this.onView,
//     this.onEdit,
//     this.onDelete,
//     this.showMenu = true,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        width: double.infinity, // full width of parent/screen
//     margin: const EdgeInsets.only(bottom: 16),
//  padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),

//     decoration: BoxDecoration(
//       color: Colors.white,
//       border: Border(
//         bottom: BorderSide(color: Colors.grey.shade300, width: 1), // bottom border line
//       ),
//       borderRadius: BorderRadius.zero, // no rounding
//     ),
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ─ Row 1: Name + Amount ─
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         title.toUpperCase(),
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
                  
//                     Text(
//                       "${amount.toStringAsFixed(2)}",
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),                   
//                   ],
//                 ),
//                 const SizedBox(height: 3),

//                 // ─ Row 2: Subtitle + Received ─
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         subtitle,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                     if (received != null)
//                       Text(
//                         "Received: ₹${received!.toStringAsFixed(2)}",
//                         style: const TextStyle(
//                           color: Colors.green,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),

//                 // ─ Row 3: Phone + Balance ─
//                 if (phone != null && phone!.isNotEmpty)
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           phone!,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                       if (balance != null && balance! > 0)
//                         Text(
//                           "Balance: ₹${balance!.toStringAsFixed(2)}",
//                           style: const TextStyle(
//                             color: Colors.red,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//            if (showMenu)
//       Positioned(
//         top: 10,
//         right: -17,
//         child: _buildPopupMenu(),
//       ),
        

//         ],
//       ),
//     );
//   }



//   Widget _buildPopupMenu() {
//     return PopupMenuButton<String>(
//       icon: const Icon(Icons.more_vert),
//       onSelected: (value) {
//         switch (value) {
//           case 'view':
//             onView?.call();
//             break;
//           case 'edit':
//             onEdit?.call();
//             break;
//           case 'delete':
//             onDelete?.call();
//             break;
//         }
//       },
//       itemBuilder: (context) {
//         final items = <PopupMenuEntry<String>>[];

//         if (onView != null) {
//           items.add(
//             const PopupMenuItem<String>(
//               value: 'view',
//               child: Row(
//                 children: [
//                   Icon(Icons.remove_red_eye, color: Colors.blue),
//                   SizedBox(width: 8),
//                   Text("View"),
//                 ],
//               ),
//             ),
//           );
//         }

//         if (onEdit != null) {
//           items.add(
//             const PopupMenuItem<String>(
//               value: 'edit',
//               child: Row(
//                 children: [
//                   Icon(Icons.edit, color: Colors.black87),
//                   SizedBox(width: 8),
//                   Text("Edit"),
//                 ],
//               ),
//             ),
//           );
//         }

//         if (onDelete != null) {
//           items.add(
//             const PopupMenuItem<String>(
//               value: 'delete',
//               child: Row(
//                 children: [
//                   Icon(Icons.delete, color: Colors.red),
//                   SizedBox(width: 8),
//                   Text("Delete"),
//                 ],
//               ),
//             ),
//           );
//         }

//         return items;
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';

class OutputCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? phone;
  final double amount;
  final double? received;
  final double? balance;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showMenu;
  final String receivedLabel;

  const OutputCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.phone,
    this.received,
    this.balance,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.showMenu = true,
    this.receivedLabel = 'Received', 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content with padding
        Padding(
          padding: const EdgeInsets.only(right: 40), // space for popup
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onTap: onView,
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Text(
                  "₹${amount.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    if (received != null)
                      Text(
                        "$receivedLabel:${received!.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.green),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                if (phone != null && phone!.isNotEmpty)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          phone!,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      if (balance != null && balance! > 0)
                        Text(
                          "Balance: ₹${balance!.toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),

        // Popup menu positioned independently to the top right
        if (showMenu)
          Positioned(
            top: 24,
            right: 8,
            child: _buildPopupMenu(),
          ),

        const Positioned(
          bottom: 0,
          left: 16,
          right: 16,
          child: Divider(height: 0),
        ),
      ],
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'view':
            onView?.call();
            break;
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        if (onView != null)
          const PopupMenuItem<String>(
            value: 'view',
            child: Row(
              children: [
                Icon(Icons.remove_red_eye, color: Colors.blue),
                SizedBox(width: 8),
                Text("View"),
              ],
            ),
          ),
        if (onEdit != null)
          const PopupMenuItem<String>(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, color: Colors.black87),
                SizedBox(width: 8),
                Text("Edit"),
              ],
            ),
          ),
        if (onDelete != null)
          const PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 8),
                Text("Delete"),
              ],
            ),
          ),
      ],
    );
  }
}
