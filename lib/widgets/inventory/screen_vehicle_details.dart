import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/purchase/purchase_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/expense.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/purchase.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/infrastructure/vehicle/vehicle_repositary.dart';
import 'package:my_new_project/widgets/expense/add_expense_dialog.dart';
import 'package:my_new_project/widgets/partnerships/add_partnership_form.dart';

class ScreenVehicleDetails extends ConsumerStatefulWidget {
  final Vehicle vehicle;
  final VoidCallback onBack;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ScreenVehicleDetails({
    super.key,
    required this.vehicle,
    required this.onBack,
    this.onEdit,
    this.onDelete,
  });

  @override
  ConsumerState<ScreenVehicleDetails> createState() =>
      _ScreenVehicleDetailsState();
}

class _ScreenVehicleDetailsState extends ConsumerState<ScreenVehicleDetails> {
  String _selectedStatus = "available"; // keep this in your State

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
      make: vehicle.make,
      model: vehicle.model,
      photos: vehicle.photos,
      price: vehicle.price,
      registrationId: vehicle.registrationId,
      color: vehicle.color,
      status: vehicle.status,
      year: vehicle.year,
      purchaseDate: vehicle.purchaseDate,
      purchaseName: vehicle.purchaseName,
      purchasePhone: vehicle.purchasePhone,
      purchaseAddress: vehicle.purchaseAddress,
      purchasePrice: vehicle.purchasePrice,
      purchaseMode: vehicle.purchaseMode,
      purchasePaymentStatus: vehicle.purchasePaymentStatus,
      mileage: vehicle.mileage,
      fuelType: vehicle.fuelType,
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

  // sales inline
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  // Dropdown value
  String? _advancePayment; // 👈 add this line
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
  final List<String> _paymentModes = [
    "Cash",
    "Card",
    "Bank Transfer",
    "Finance",
  ];
  String? _selectedMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //align all left
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First line: Back button
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back, size: 20),
                  ),
                ),

                const SizedBox(height: 20), // spacing between lines
                // Second line: Edit + Delete buttons (aligned right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Edit button
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: widget.onEdit,
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                    ),

                    // Delete button
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: widget.onDelete,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            KHeight16,
            Text(
              "${widget.vehicle.make} ${widget.vehicle.model} (${widget.vehicle.model})",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            KHeight16,
            Text(
              widget.vehicle.registrationId,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            KHeight16,
            // cost Acquisition Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Total Cost of Acquisition",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  KHeight,
                  Text(
                    "₹${widget.vehicle.purchasePrice}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  KHeight,
                  Text(
                    "(Buying Price: ₹${widget.vehicle.purchasePrice} + Total Expenses: ₹0)", //heeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeere
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            KHeight20,

            //vehicle image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: widget.vehicle.photos.isNotEmpty
                    ? PageView.builder(
                        itemCount: widget.vehicle.photos.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            widget.vehicle.photos[index],
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.network(
                        "https://wallpaperaccess.com/full/472325.jpg", // fallback if no photo
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            KHeight16,

            // ================= Vehicle Info & Status Section =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Vehicle Information",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Divider(color: Colors.grey),

                  const SizedBox(height: 8),

                  // Color
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Color:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ), // Add a small space after the label
                      Text(
                        widget.vehicle.color,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  KHeight,

                  // Mileage
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Mileage:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${widget.vehicle.mileage} km",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  KHeight,

                  // Fuel Type
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Fuel Type:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.vehicle.fuelType,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  KHeight,

                  // Purchase Date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Purchase Date:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.vehicle.purchaseDate.toString().split("T").first,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  KHeight,

                  // Notes
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Notes:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.vehicle.description ?? "No additional notes.",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ), // Adjust spacing before the status

                  const Divider(
                    color: Colors.grey,
                  ), // Add a divider between sections

                  const SizedBox(height: 12),

                  // Status section (now inside the same container)
                  Row(
                    children: [
                      const Text(
                        "Status:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        // Wrap the dropdown button in an expanded widget
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            isExpanded:
                                true, // This helps the dropdown fill available space
                            value: _selectedStatus,
                            underline: const SizedBox(),
                            borderRadius: BorderRadius.circular(8),
                            items: const [
                              DropdownMenuItem(
                                value: "available",
                                child: Text("Available"),
                              ),
                              DropdownMenuItem(
                                value: "maintenance",
                                child: Text("Maintenance"),
                              ),
                              DropdownMenuItem(
                                value: "sold",
                                child: Text("Sold"),
                              ),
                            ],
                            onChanged: (value) async {
                              if (value == null) return;

                              setState(() {
                                _selectedStatus = value;
                              });

                              try {
                                await ref
                                    .read(vehicleRepositoryProvider)
                                    .updateVehicleStatus(
                                      widget.vehicle.id,
                                      value,
                                    );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Status updated to $value"),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to update status"),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  //
                ],
              ),
            ),

            KHeight16,

            // Now conditionally render when status == "sold"
            if (_selectedStatus == "sold") ...[
              const SizedBox(height: 20),
              //inline
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title inside same container
                    const Text(
                      "Record New Sale",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,

                        decoration: TextDecoration.underline,
                        // decorationThickness: 30
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Customer Information heading
                    const Text(
                      "Customer Information",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    // const SizedBox(height: 12),
                    Divider(color: Colors.black, thickness: 1),

                    // Advance Payment Dropdown
                    const Text("Select Advance Payment"),
                    DropdownButtonFormField<String>(
                      value: _advancePayment,
                      hint: const Text("Manual Entry / No Advance"),
                      items:
                          ["Manual Entry / No Advance", "Bank Transfer", "Cash"]
                              .map(
                                (method) => DropdownMenuItem(
                                  value: method,
                                  child: Text(method),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          _advancePayment = value;
                        });
                      },
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    const Text(
                      "Customer Name *",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: "Enter customer name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Phone
                    const Text(
                      "Customer Phone *",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _phoneController,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Enter phone number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Address
                    const Text(
                      "Customer Address",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _addressController,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Enter customer address",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    KHeight16,
                    Text(
                      "Sale & Payment Details",
                      style: TextStyle(color: Colors.black),
                    ),
                    KHeight16,
                    Divider(color: Colors.black),

                    Text(
                      "Sale Date*",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        // labelText: "Sale Date*",
                        hintText: "dd-MM-yyyy",
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () => _pickDate(context),
                    ),
                    KHeight16,

                    Text(
                      "Sale Price(INR)*",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: "e.g.500000",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    KHeight16,

                    Text(
                      "Recieved Amount(INR)*",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: "e.g.100000",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    KHeight16,

                    Text(
                      "Payment Status*",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: "Pending",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    KHeight16,

                    DropdownButtonFormField<String>(
                      value: _selectedMode,
                      decoration: const InputDecoration(
                        hintText: "Select Payment Mode",
                        border: OutlineInputBorder(),
                      ),
                      items: _paymentModes.map((mode) {
                        return DropdownMenuItem<String>(
                          value: mode,
                          child: Text(mode),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMode = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? "Please select a payment mode" : null,
                    ),
                    KHeight20,
                    const Text(
                      "Brokerage Details",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(color: Colors.black),

                    KHeight20,
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: "Select Broker(optional)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    KHeight20,
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // button background color
                          foregroundColor: Colors.white, // text color
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // your submit logic here
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ================= Seller Details Section =================
            KHeight30,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Seller Details",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Divider(color: Colors.grey),

                  KHeight,

                  // Name
                  Column(
                    children: [
                      const Text(
                        "Name:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.vehicle.purchaseName,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  KHeight,

                  // Phone
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Phone:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.vehicle.purchasePhone,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  KHeight,

                  // Address
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Address:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.vehicle.purchaseAddress,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  KHeight,

                  // Payment Mode
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Payment Mode:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.vehicle.purchaseMode,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  KHeight,

                  // Buying Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Buying Price:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.vehicle.purchasePrice.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Add this section after the Seller Details section and before the ElevatedButton

            // Expenses Section
            KHeight30,

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                20,
              ), // More generous padding like original
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expenses Header with + Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Expenses",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return DraggableScrollableSheet(
                                initialChildSize: 0.8,
                                minChildSize: 0.4,
                                maxChildSize: 0.95,
                                expand: false,
                                builder: (context, scrollController) {
                                  return SingleChildScrollView(
                                    controller: scrollController,
                                    child: AddExpenseDialog(
                                      vehicle: widget.vehicle,
                                      onSubmit: (data) {
                                        // Handle submit logic
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.add, color: Colors.blue),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40), // Increased spacing
                  // Body (empty state)
                  Center(
                    child: Text(
                      "No expenses have been recorded for this vehicle.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),

            // partnership dialog
            KHeight20,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                20,
              ), // More generous padding like original
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expenses Header with + Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Partnerships",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const AddPartnershipDialog(),
                          );
                        },
                        icon: const Icon(Icons.add, color: Colors.blue),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40), // Increased spacing
                  // Body (empty state)
                  Center(
                    child: Text(
                      "No partnerships have been recorded for this vehicle.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),

            // 👇 Only show when status is "sold"
            if (_selectedStatus == "sold") ...[
              const SizedBox(height: 20),

              /// Finance Details Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(
                  20,
                ), // More generous padding like original
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expenses Header with + Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Finance Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.blue,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 40), // Increased spacing
                    // Body (empty state)
                    Center(
                      child: Text(
                        "No Finance  have been recorded for this vehicle.",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              KHeight30,

              /// Brokerage Details Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(
                  20,
                ), // More generous padding like original
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expenses Header with + Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Brokerage details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.blue,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 40), // Increased spacing
                    // Body (empty state)
                    Center(
                      child: Text(
                        "No Brokerage  have been recorded for this vehicle.",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleImage(String path) {
    if (path.isEmpty) {
      return Center(child: Icon(Icons.car_repair, size: 50));
    }

    if (path.startsWith('http') || path.startsWith('https')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Center(child: Icon(Icons.car_repair, size: 50)),
      );
    } else if (kIsWeb) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Center(child: Icon(Icons.car_repair, size: 50)),
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Center(child: Icon(Icons.car_repair, size: 50)),
      );
    }
  }

  //date format
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _dateFormat.format(picked); // 👈 format applied
      });
    }
  }
}
