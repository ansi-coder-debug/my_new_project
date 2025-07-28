import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/expense.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/purchase.dart';
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
  void _deletePartnership() async {
    final vehicleBox = Hive.box<Vehicle>('vehicles');

    final partnershipBox = Hive.box<Partnership>('partnerships');

    final vehicle = widget.vehicle;

    // delete the actual partnership from the box
    if (vehicle.partnership != null) {
      await partnershipBox.delete(vehicle.partnership!.id);
    }
    // Step 2: Replace the vehicle with the same data but no partnership
    final updatedVehicle = Vehicle(
      id: vehicle.id,
      title: vehicle.title,
      imageUrl: vehicle.imageUrl,
      price: vehicle.price,
      mileage: vehicle.mileage,
      color: vehicle.color,
      vin: vehicle.vin,
      task: vehicle.task,
      status: vehicle.status,
      year: vehicle.year,
    );

    // Step 3: Save updated vehicle to Hive
    await vehicleBox.put(vehicle.id, updatedVehicle);

    //step 4 rebuild ui
    setState(() {});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Partnership Deleted')));
  }

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

            // Purchase Section
            ValueListenableBuilder(
              //Listen to changes in the Hive 'purchases' box
              valueListenable: Hive.box<Purchase>('purchases').listenable(),

              // Find the first purchase whose vehicleId matches the current vehicle
              builder: (context, box, _) {
                final purchases = box.values
                    .where(
                      (purchase) => purchase.vehicleId == widget.vehicle.id,
                    )
                    .toList();

                if (purchases.isEmpty) {
                  return Text('No Purchases Recorded');
                }
                // if purchase found build ui section
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Text(
                      'Purchase Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    KHeight,
                    // build one card per purchase
                    ...purchases.map(
                      (purchase) => Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            '${purchase.name} - ${purchase.price}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('📞 Phone: ${purchase.phone}'),
                              Text('📍 Address: ${purchase.address}'),
                              Text('🗓️ Date: ${purchase.date}'),
                              Text(
                                '💳 Payment Mode: ${purchase.modeOfPayment}',
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Hive.box<Purchase>(
                                'purchases',
                              ).delete(purchase.id);
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Partnership Section
            if (widget.vehicle.partnership != null) ...[
              SizedBox(height: 24),
              Text(
                'Partnership Details',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Partner Name :${widget.vehicle.partnership!.partnerName}',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Contact Person :${widget.vehicle.partnership!.contactPerson}',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Share % :${widget.vehicle.partnership!.sharePercentage}',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Phone :${widget.vehicle.partnership!.phone}',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Email:${widget.vehicle.partnership!.email}',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Start Date:${widget.vehicle.partnership!.startDate}',
                          style: TextStyle(color: Colors.black),
                        ),
                        IconButton(
                          onPressed: _deletePartnership,
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}





// onPressed: () async {
//   if (_status == 'Sold') {
//     final salesBox = Hive.box<Sales>('sales');

//     final newSale = Sales(
//       id: Uuid().v4(),
//       vehicleId: (widget.vehicleToEdit ?? widget.vehicle)!.id,
//       buyerName: _buyerNameController.text,
//       buyerPhone: _buyerPhoneController.text,
//       buyerAddress: _buyerAddressController.text,
//       modeOfPayment: _modeOfPaymentController.text,
//       date: _saleDateController.text,
//     );

//     await salesBox.put(newSale.id, newSale); // ✅ Save sale record
//   }

//   // ✅ Always update the vehicle status in Hive
//   final vehicleBox = Hive.box<Vehicle>('vehicles');
//   final currentVehicle = (widget.vehicleToEdit ?? widget.vehicle);

//   if (currentVehicle != null) {
//     final updatedVehicle = currentVehicle.copyWith(
//       status: _status, // ✅ Apply the new status (e.g., 'Sold')
//     );

//     await vehicleBox.put(updatedVehicle.id, updatedVehicle); // ✅ Save back the updated vehicle
//   }

//   // ✅ Notify completion (close form or refresh list)
//   if (_status == 'Sold') {
//     widget.onAddComplete();
//   }
// }
