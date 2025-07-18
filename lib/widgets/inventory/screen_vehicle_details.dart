import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/expense.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/widgets/expense/add_expense_form_from_vehicle.dart';

class ScreenVehicleDetails extends StatefulWidget {
  final Vehicle vehicle;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  const ScreenVehicleDetails({
    super.key,
    required this.vehicle,
    required this.onBack,
    required this.onEdit,
  });

  @override
  State<ScreenVehicleDetails> createState() => _ScreenVehicleDetailsState();
}

class _ScreenVehicleDetailsState extends State<ScreenVehicleDetails> {
  bool _showExpenseForm = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //align all left
          children: [
            Container(
              // height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey,
              ),

              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.file(
                        File(widget.vehicle.imageUrl),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Center(
                          child: Icon(
                            Icons.car_repair,
                            size: 50,
                          ), // in case of no internet it shows car repair image
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: widget.onBack,
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: TextButton(
                      onPressed: widget.onEdit,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Edit Vehicle',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),
            // Text(vehicle.year, style: TextStyle(color: Colors.black)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                Text(
                  '${widget.vehicle.year} ${widget.vehicle.title}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'VIN:${widget.vehicle.vin}',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),

            SizedBox(height: 12),
            // Text(vehicle.price, style: TextStyle(color: Colors.black)),
            Column(
              children: [
                Text(
                  '\$${widget.vehicle.price}',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: Text(
                    widget.vehicle.status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vehicle Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Color',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    widget.vehicle.color,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            KWidth12,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mileage',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.vehicle.mileage,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        Text(
                          'Purchase Date',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.vehicle.purchaseDate ?? 'N/A',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Description',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.vehicle.description ??
                              'No description available.',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            
          ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: AddExpenseFormFromVehicle(
                vehicleId: widget.vehicle.id,
                onCancel: () {
                  Navigator.of(context).pop();
                },
                onAddComplete: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ),
          ),
        );
      },
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue, // 🔵 Background color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // ◼️ No rounded corners
    ),
  ),
  child: Text(
    'Add Expense',
    style: TextStyle(color: Colors.white), // ⚪ White text
  ),
),











            // ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       _showExpenseForm = true; //show the dialog form
            //     });
            //   },

            //   child: Text('Add Expense', style: TextStyle(color: Colors.white)),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blue,
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            //   ),
            // ),

            // if (_showExpenseForm)
            //   Padding(
            //     padding: EdgeInsets.all(16),
            //     child: AddExpenseFormFromVehicle(
            //       vehicleId: widget.vehicle.id,
            //       onCancel: () {
            //         setState(() {
            //           _showExpenseForm = false;
            //         });
            //       },
            //       onAddComplete: () {
            //         setState(() {
            //           _showExpenseForm =
            //               false; // Hide it because it will auto update in Hive
            //         });
            //       },
            //     ),
            //   ),

            // expense list header
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 8),
              child: Text(
                'Expenses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            //Expense List
            ValueListenableBuilder(
              valueListenable: Hive.box<Expense>('expenses').listenable(),
              builder: (context, box, _) {
                final expenses = box.values
                    .where((expense) => expense.vehicleId == widget.vehicle.id)
                    .toList();

                if (expenses.isEmpty) {
                  return Text('No Expenses Recorded');
                }
                return Column(
                  children: expenses
                      .map(
                        (expense) => Card(
                          child: ListTile(
                            title: Text(
                              '₹${expense.amount} - ${expense.category}',
                            ),
                            subtitle: Text(expense.date),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(expense.paymentMode),
                                IconButton(
                                  onPressed: () {
                                    Hive.box<Expense>(
                                      'expenses',
                                    ).delete(expense.id);
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),

                            //
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}










/*ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      barrierDismissible: false, // prevent tap outside to close
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: AddExpenseFormFromVehicle(
                vehicleId: widget.vehicle.id,
                onCancel: () {
                  Navigator.of(context).pop(); // close dialog
                },
                onAddComplete: () {
                  Navigator.of(context).pop(); // close dialog
                  setState(() {}); // refresh if needed
                },
              ),
            ),
          ),
        );
      },
    );
  },
  child: Text("Add Expense"),
)

*/