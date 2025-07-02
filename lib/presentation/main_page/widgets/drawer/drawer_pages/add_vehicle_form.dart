import 'package:flutter/material.dart';
import 'package:my_new_project/core/constant.dart';

class AddVehicleForm extends StatefulWidget {
  final VoidCallback? onCancel;

  const AddVehicleForm({super.key, this.onCancel});

  @override
  State<AddVehicleForm> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<AddVehicleForm> {
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Make', style: TextStyle(color: Colors.black)),
            TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight16,
            Text('Model', style: TextStyle(color: Colors.black)),
            TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight16,
            Text('Year',
              style: TextStyle(
              color: Colors.black
            ),
            ),
             TextFormField(
              decoration: InputDecoration(
                
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight16,
             TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        border: OutlineInputBorder(),
      ),
    ),
    SizedBox(height: 16),

    // Price
    Text(
      'Price',
      style: TextStyle(color: Colors.black),
    ),
    TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        border: OutlineInputBorder(),
      ),
    ),
    KHeight16,

    // Mileage
    Text(
      'Mileage',
      style: TextStyle(color: Colors.black),
    ),
    TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        border: OutlineInputBorder(),
      ),
    ),
     KHeight16,

    // VIN
    Text(
      'VIN',
      style: TextStyle(color: Colors.black),
    ),
    TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        border: OutlineInputBorder(),
      ),
    ),
     KHeight16,
    // Color
    Text(
      'Color',
      style: TextStyle(color: Colors.black),
    ),
    TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        border: OutlineInputBorder(),
      ),
    ),
     KHeight16,

    // Status
    Text(
      'Status',
      style: TextStyle(color: Colors.black),
    ),
    TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        border: OutlineInputBorder(),
      ),
    ),
    KHeight16,

    // Purchase Date
    Text(
      'Purchase Date',
      style: TextStyle(color: Colors.black),
    ),
    TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        border: OutlineInputBorder(),
      ),
    ),
     KHeight16,

    // Description
    Text(
      'Description',
      style: TextStyle(color: Colors.black),
    ),
    TextFormField(
      maxLines: 3, // multi-line for description
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        border: OutlineInputBorder(),
      ),
    ),
    KHeight16,

    // Photos (could be a custom widget or placeholder for now)
    Text(
      'Photos',
      style: TextStyle(color: Colors.black),
    ),


    // Stack(
  // children: [
//     TextFormField(
//       decoration: InputDecoration(
//         hintText: 'Add photo URL or use file picker',
//         contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//         border: OutlineInputBorder(),
//       ),
//     ),
//     Positioned(
//       right:0,
//       top: 0,
//       child: ElevatedButton(
//         onPressed: () {
//           // Your action here
//         },
//         style: ElevatedButton.styleFrom(
          
//           backgroundColor: Colors.blue,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.zero
//           )
          
//         ),
//         child: Text('Add', style: TextStyle(color: Colors.white)),
//       ),
//     ),
//   ],
// )

    TextFormField(
      decoration: InputDecoration(
        hintText: 'Add photo URL or use file picker',
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        border: OutlineInputBorder(),
        suffixIcon: Padding(padding: const EdgeInsets.only(right: 4),
        
        child:  ElevatedButton.icon(
      
      onPressed: (){},
     label: Text('Add',
     style: TextStyle(color: Colors.white),),
     style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero
      ),
      
     ),
     ),
        )
      ),
    ),
   
     KHeight,

Row(
  children: [
    SizedBox(width: 90),
    ElevatedButton(onPressed: (){},
     child: Text('Cancel',
     style: TextStyle(
      color: Colors.black
     ),),
     style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero
      )
     )
     ),

     SizedBox(width: 20),

     ElevatedButton(onPressed: (){},
      child: Text('Add Vehicle',
      style: TextStyle(
        color: Colors.white
      ),),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero
        )
      )
      )
  ],
)

//      Row(
//   children: [
//     Expanded(
//       child: OutlinedButton(
//         onPressed: () {
//           // Handle cancel action
//         },
//         style: OutlinedButton.styleFrom(
//           side: BorderSide(color: Colors.grey),
//           padding: EdgeInsets.symmetric(vertical: 16),
//         ),
//         child: Text('Cancel', style: TextStyle(color: Colors.black)),
//       ),
//     ),
//     SizedBox(width: 16), // spacing between buttons
//     Expanded(
//       child: ElevatedButton(
//         onPressed: () {
//           // Handle add vehicle action
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.blue,
//           padding: EdgeInsets.symmetric(vertical: 16),
//         ),
//         child: Text('Add Vehicle', style: TextStyle(color: Colors.white)),
//       ),
//     ),
//   ],
// )



          ],
          //     padding: const EdgeInsets.all(16.0),
          //     children: [
          //       // Make and Model
          //       Row(
          //         children: [
          //           Expanded(
          //             child: TextField(
          //               decoration: const InputDecoration(
          //                 labelText: 'Make',
          //                 border: OutlineInputBorder(),
          //               ),
          //             ),
          //           ),
          //           const SizedBox(width: 16),
          //           Expanded(
          //             child: TextField(
          //               decoration: const InputDecoration(
          //                 labelText: 'Model',
          //                 border: OutlineInputBorder(),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 16),

          //       // Year and Price
          //       Row(
          //         children: [
          //           Expanded(
          //             child: TextField(
          //               decoration: const InputDecoration(
          //                 labelText: 'Year',
          //                 border: OutlineInputBorder(),
          //               ),
          //               keyboardType: TextInputType.number,
          //             ),
          //           ),
          //           const SizedBox(width: 16),
          //           Expanded(
          //             child: TextField(
          //               decoration: const InputDecoration(
          //                 labelText: 'Price (\$)',
          //                 border: OutlineInputBorder(),
          //               ),
          //               keyboardType: TextInputType.number,
          //             ),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 16),

          //       // Mileage and VIN
          //       Row(
          //         children: [
          //           Expanded(
          //             child: TextField(
          //               decoration: const InputDecoration(
          //                 labelText: 'Mileage',
          //                 border: OutlineInputBorder(),
          //               ),
          //               keyboardType: TextInputType.number,
          //             ),
          //           ),
          //           const SizedBox(width: 16),
          //           Expanded(
          //             child: TextField(
          //               decoration: const InputDecoration(
          //                 labelText: 'VIN',
          //                 border: OutlineInputBorder(),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 16),

          //       // Color and Status
          //       Row(
          //         children: [
          //           Expanded(
          //             child: TextField(
          //               decoration: const InputDecoration(
          //                 labelText: 'Color',
          //                 border: OutlineInputBorder(),
          //               ),
          //             ),
          //           ),
          //           const SizedBox(width: 16),
          //           Expanded(
          //             child: DropdownButtonFormField<String>(
          //               decoration: const InputDecoration(
          //                 labelText: 'Status',
          //                 border: OutlineInputBorder(),
          //               ),
          //               value: selectedStatus,
          //               items: [
          //                 'Available',
          //                 'Pending Sale',
          //                 'Sold',
          //                 'In Maintenance'
          //               ].map((status) => DropdownMenuItem(
          //                     value: status,
          //                     child: Text(status),
          //                   )).toList(),
          //               onChanged: (value) {
          //                 setState(() {
          //                   selectedStatus = value;
          //                 });
          //               },
          //             ),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 16),

          //       // Purchase Date
          //       TextField(
          //         decoration: const InputDecoration(
          //           labelText: 'Purchase Date',
          //           border: OutlineInputBorder(),
          //           suffixIcon: Icon(Icons.calendar_today),
          //         ),
          //         readOnly: true,
          //         onTap: () {
          //           // TODO: Show date picker
          //         },
          //       ),
          //       const SizedBox(height: 16),

          //       // Description
          //       TextField(

          //         decoration: const InputDecoration(
          //           labelText: 'Description',
          //           fillColor: Colors.black,
          //           border: OutlineInputBorder(),
          //         ),
          //         maxLines: 3,
          //       ),
          //       const SizedBox(height: 16),

          //       // Photo URL
          //       TextField(
          //         decoration: const InputDecoration(
          //           labelText: 'Photo URL',
          //           border: OutlineInputBorder(),
          //         ),
          //       ),
          //       const SizedBox(height: 100), // Add space for FAB
          //     ],
          //   ),
          //   floatingActionButton: FloatingActionButton(
          //     onPressed: () {
          //       // TODO: Save vehicle logic here
          //       // For now, just go back to the inventory
          //       widget.onCancel?.call();
          //     },
          //     backgroundColor: Colors.blue,
          //     child: const Icon(
          //       Icons.arrow_forward,
          //       color: Colors.white,
          //     ),
        ),
      ),
    );
  }
}
