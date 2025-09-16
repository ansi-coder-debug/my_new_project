// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:intl/intl.dart';
// import 'package:my_new_project/application/expense/expense_provider.dart';

// import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
// import 'package:my_new_project/core/constants/constant.dart';

// import 'package:my_new_project/core/models/partnership.dart';

// import 'package:my_new_project/infrastructure/vehicle/vehicle_repositary.dart';
// import 'package:my_new_project/widgets/expense/add_expense_dialog.dart';
// import 'package:my_new_project/widgets/sales/profit_summary_card.dart';
// import 'package:my_new_project/widgets/sales/sale_form.dart';

// class ScreenVehicleDetails extends ConsumerStatefulWidget {
//   final String vehicleId;
//   final VoidCallback onBack;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;

//   const ScreenVehicleDetails({
//     super.key,
//     required this.vehicleId,
//     required this.onBack,
//     this.onEdit,
//     this.onDelete,
//   });

//   @override
//   ConsumerState<ScreenVehicleDetails> createState() =>
//       _ScreenVehicleDetailsState();
// }

// class _ScreenVehicleDetailsState extends ConsumerState<ScreenVehicleDetails> {
//   String _selectedStatus = "available";

//   final List<String> _paymentModes = [
//     "Cash",
//     "Card",
//     "Bank Transfer",
//     "Finance",
//   ];
//   String? _selectedMode;

//   void _deletePartnership(Partnership partnership) async {
//     final vehicle = ref
//         .read(vehicleProvider)
//         .vehicles
//         .firstWhere((v) => v.id == widget.vehicleId);

//     final updatedPartnerships =
//         List<Partnership>.from(vehicle.partnerships ?? [])..removeWhere(
//           (p) =>
//               p.partnerName == partnership.partnerName &&
//               p.contribution == partnership.contribution &&
//               p.sharePercentage == partnership.sharePercentage,
//         );

//     final updatedVehicle = vehicle.copyWith(partnerships: updatedPartnerships);

//     try {
//       await ref.read(vehicleRepositoryProvider).updateVehicle(updatedVehicle);

//       // Refresh local state
//       await ref.read(vehicleProvider.notifier).loadVehicles();

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Partnership deleted')));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to delete partnership')),
//       );
//     }
//   }

//   // keep this in your State

//   bool _showExpenseForm = false;

//   // sales inline
//   // Controllers
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   // Dropdown value
//   String? _advancePayment; // 👈 add this line
//   final TextEditingController _dateController = TextEditingController();
//   DateTime? _selectedDate;
//   final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

//   @override
//   Widget build(BuildContext context) {
//     final vehicleState = ref.watch(vehicleProvider);

//     // Promote to non-nullable by assigning and returning early
//     final vehicle = vehicleState.vehicles.firstWhere(
//       (v) => v.id == widget.vehicleId,
//       // orElse: () => ,
//     );

//     if (vehicle == null) {
//       return const Center(child: Text("Vehicle not found"));
//     }

//     final expenseState = ref.watch(expenseProvider);
//     final expenseForThisVehicle = expenseState.expenses
//         .where((e) => e.vehicleId == vehicle!.id)
//         .toList();

//     final totalExpenseAmount = expenseForThisVehicle.fold<double>(
//       0.0,
//       (sum, e) => sum + (double.tryParse(e.amount) ?? 0),
//     );

//     //sold green card

//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start, //align all left
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // First line: Back button
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black54),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: IconButton(
//                     onPressed: widget.onBack,
//                     icon: const Icon(Icons.arrow_back, size: 20),
//                   ),
//                 ),

//                 const SizedBox(height: 20), // spacing between lines
//                 // Second line: Edit + Delete buttons (aligned right)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     // Edit button
//                     Container(
//                       margin: const EdgeInsets.only(right: 8),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blueAccent),
//                         borderRadius: BorderRadius.circular(8),
//                       ),

//                       child: IconButton(
//                         onPressed: () {
//                           print('IconButton pressed');
//                           ref
//                               .read(vehicleProvider.notifier)
//                               .setVehicleToEdit(vehicle);

//                           // Notify parent widget about edit action (optional)
//                           if (widget.onEdit != null) {
//                             widget.onEdit!();
//                           }
//                         },
//                         icon: const Icon(
//                           Icons.edit,
//                           color: Colors.blue,
//                           size: 20,
//                         ),
//                       ),
//                     ),

//                     // Delete button
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.redAccent),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: IconButton(
//                         onPressed: widget.onDelete,
//                         icon: const Icon(
//                           Icons.delete,
//                           color: Colors.red,
//                           size: 20,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),

//             KHeight16,
//             Text(
//               "${vehicle.make} ${vehicle.model} (${vehicle.model})",
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             KHeight16,
//             Text(
//               vehicle.registrationId,
//               style: const TextStyle(fontSize: 16, color: Colors.black),
//             ),
//             KHeight16,

//             // cost Acquisition Card
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
//                   begin: Alignment.center,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   const Text(
//                     "Total Cost of Acquisition",
//                     style: TextStyle(color: Colors.white, fontSize: 14),
//                   ),
//                   KHeight,
//                   Text(
//                     "₹${vehicle.purchaseInfo.price}",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   KHeight,

//                   Text(
//                     "(Buying Price: ₹${vehicle.purchaseInfo.price} + Total Expenses: ₹${totalExpenseAmount.toStringAsFixed(2)})",

//                     style: const TextStyle(color: Colors.white70, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//             KHeight20,

//             //total profit
//             if (vehicle.status.toLowerCase() == "sold") ...[
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
//                     begin: Alignment.center,
//                     end: Alignment.bottomCenter,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     const Text(
//                       "Total Profit",
//                       style: TextStyle(color: Colors.white, fontSize: 14),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "total profit",
//                       // "₹${totalProfit.toStringAsFixed(0)}",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "ownera profit",
//                       // "(Owner Profit: ₹${ownerProfit.toStringAsFixed(0)} + Partners Profit: ₹${partnersProfit.toStringAsFixed(0)})",
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],

//             //vehicle image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: AspectRatio(
//                 aspectRatio: 16 / 9,
//                 child: vehicle.photos.isNotEmpty
//                     ? PageView.builder(
//                         itemCount: vehicle.photos.length,
//                         itemBuilder: (context, index) {
//                           return Image.network(
//                             vehicle.photos[index],
//                             fit: BoxFit.cover,
//                           );
//                         },
//                       )
//                     : Image.network(
//                         "https://wallpaperaccess.com/full/472325.jpg", // fallback if no photo
//                         fit: BoxFit.cover,
//                       ),
//               ),
//             ),

//             KHeight16,

//             // ================= Vehicle Info & Status Section =================
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: Colors.white,
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Vehicle Information",
//                     style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const Divider(color: Colors.grey),

//                   const SizedBox(height: 8),

//                   // Color
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Color:",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 5,
//                       ), // Add a small space after the label
//                       Text(
//                         vehicle.color,
//                         style: const TextStyle(color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   KHeight,

//                   // Mileage
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Mileage:",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         "${vehicle.mileage} km",
//                         style: const TextStyle(color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   KHeight,

//                   // Fuel Type
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Fuel Type:",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         vehicle.fuelType,
//                         style: const TextStyle(color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   KHeight,

//                   // Purchase Date
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Purchase Date:",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         vehicle.purchaseInfo.date.toString().split("T").first,
//                         style: const TextStyle(color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   KHeight,

//                   // Notes
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Notes:",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         vehicle.description ?? "No additional notes.",
//                         style: const TextStyle(color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 12,
//                   ), // Adjust spacing before the status

//                   const Divider(
//                     color: Colors.grey,
//                   ), // Add a divider between sections

//                   const SizedBox(height: 12),

//                   // Status section (now inside the same container)
//                   Row(
//                     children: [
//                       const Text(
//                         "Status:",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         // Wrap the dropdown button in an expanded widget
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 6,
//                             vertical: 2,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey.shade400),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: DropdownButton<String>(
//                             isExpanded:
//                                 true, // This helps the dropdown fill available space
//                             value: _selectedStatus,
//                             underline: const SizedBox(),
//                             borderRadius: BorderRadius.circular(8),
//                             items: const [
//                               DropdownMenuItem(
//                                 value: "available",
//                                 child: Text("Available"),
//                               ),
//                               DropdownMenuItem(
//                                 value: "maintenance",
//                                 child: Text("Maintenance"),
//                               ),
//                               DropdownMenuItem(
//                                 value: "sold",
//                                 child: Text("Sold"),
//                               ),
//                             ],
//                             onChanged: (value) async {
//                               if (value == null) return;

//                               setState(() {
//                                 _selectedStatus = value;
//                               });

//                               try {
//                                 await ref
//                                     .read(vehicleRepositoryProvider)
//                                     .updateVehicleStatus(vehicle.id, value);

//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text("Status updated to $value"),
//                                   ),
//                                 );
//                               } catch (e) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text("Failed to update status"),
//                                   ),
//                                 );
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   //
//                 ],
//               ),
//             ),

//             KHeight16,

//             // // Now conditionally render when status == "sold"
//             // if (_selectedStatus == "sold") ...[
//             // SaleForm(vehicle: vehicle,)
//             // ],

//             // ✅ Instead of this
//             // if (_selectedStatus == "sold") ...[
//             //   SaleForm(vehicle: vehicle,)
//             // ],

//             // ✅ Do this
//             if (vehicle.status.toLowerCase() == "sold") ...[
//               ProfitSummaryCard(
//                 vehicle: vehicle,
//                 expenses:
//                     expenseForThisVehicle, // Make sure this is a List<Expense>
//               ),
//             ] else if (_selectedStatus == "sold") ...[
//               SaleForm(vehicle: vehicle),
//             ],

//             // ================= Seller Details Section =================
//             KHeight30,
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: Colors.white,
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Seller Details",
//                     style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const Divider(color: Colors.grey),

//                   KHeight,

//                   // Name
//                   Column(
//                     children: [
//                       const Text(
//                         "Name:",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         vehicle.purchaseInfo.name,
//                         style: const TextStyle(color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   KHeight,

//                   // Phone
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Phone:",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         vehicle.purchaseInfo.phone,
//                         style: const TextStyle(color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   KHeight,

//                   // Address
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Address:",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         vehicle.purchaseInfo.address,
//                         style: const TextStyle(color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   KHeight,

//                   // Payment Mode
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Payment Mode:",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         vehicle.purchaseInfo.modeOfPayment,
//                         style: const TextStyle(color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   KHeight,

//                   // Buying Price
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Buying Price:",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         vehicle.purchaseInfo.price.toString(),
//                         style: const TextStyle(color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // Add this section after the Seller Details section and before the ElevatedButton

//             // Expenses Section
//             KHeight30,

//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(
//                 20,
//               ), // More generous padding like original
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 6,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Expenses Header with + Button
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Expenses",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),

//                       IconButton(
//                         onPressed: () {
//                           showModalBottomSheet(
//                             context: context,
//                             isScrollControlled: true,
//                             backgroundColor: Colors.transparent,
//                             builder: (context) {
//                               return DraggableScrollableSheet(
//                                 initialChildSize: 0.8,
//                                 minChildSize: 0.4,
//                                 maxChildSize: 0.95,
//                                 expand: false,
//                                 builder: (context, scrollController) {
//                                   return SingleChildScrollView(
//                                     controller: scrollController,
//                                     child: AddExpenseDialog(
//                                       vehicle: vehicle,
//                                       // onSubmit: (data) {
//                                       //   // Handle submit logic
//                                       // },
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                           );
//                         },
//                         icon: const Icon(Icons.add, color: Colors.blue),
//                         style: IconButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 40), // Increased spacing
//                   // Body (empty state)
//                   expenseForThisVehicle.isEmpty
//                       ? Center(
//                           child: Text(
//                             "No expenses have been recorded for this vehicle.",
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         )
//                       : Column(
//                           children: expenseForThisVehicle.map((expense) {
//                             return ListTile(
//                               title: Text("₹${expense.amount}"),
//                               subtitle: Text(
//                                 "${expense.description ?? "No description"}",
//                               ),
//                               trailing: Text(expense.date),
//                             );
//                           }).toList(),
//                         ),
//                 ],
//               ),
//             ),

//             // partnership dialog
//             KHeight20,
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(
//                 20,
//               ), // More generous padding like original
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 6,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Expenses Header with + Button
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Partnerships",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 40), // Increased spacing
//                   // Body (empty state)
//                   vehicle.partnerships != null &&
//                           vehicle.partnerships!.isNotEmpty
//                       ? ListView.separated(
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemCount: vehicle.partnerships!.length,
//                           separatorBuilder: (_, __) => Divider(),
//                           itemBuilder: (context, index) {
//                             final partnership = vehicle.partnerships![index];
//                             return ListTile(
//                               title: Text(
//                                 partnership.partnerName ?? 'Unnamed Partner',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   if (partnership.contribution != null)
//                                     Text(
//                                       'Contribution: ₹${partnership.contribution}',
//                                     ),
//                                   if (partnership.sharePercentage != null)
//                                     Text(
//                                       'Profit Share: ${partnership.sharePercentage}%',
//                                     ),
//                                   if (partnership.paymentMode != null)
//                                     Text(
//                                       'Payment Mode: ${partnership.paymentMode}',
//                                     ),
//                                   if (partnership.contributionStatus != null)
//                                     Text(
//                                       'Status: ${partnership.contributionStatus}',
//                                     ),
//                                 ],
//                               ),
//                               trailing: IconButton(
//                                 icon: Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () {
//                                   _deletePartnership(partnership);
//                                 },
//                               ),
//                             );
//                           },
//                         )
//                       : Center(
//                           child: Text(
//                             "No partnerships have been recorded for this vehicle.",
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                             softWrap: true,
//                           ),
//                         ),
//                 ],
//               ),
//             ),

//             // 👇 Only show when status is "sold"
//             if (_selectedStatus == "sold") ...[
//               const SizedBox(height: 20),

//               /// Finance Details Section
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(
//                   20,
//                 ), // More generous padding like original
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 6,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Expenses Header with + Button
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Finance Details",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black,
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                         Container(
//                           width: 24,
//                           height: 24,
//                           decoration: BoxDecoration(
//                             color: Colors.blue.shade50,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: Icon(
//                               Icons.add,
//                               color: Colors.blue,
//                               size: 16,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: 40), // Increased spacing
//                     // Body (empty state)
//                     Center(
//                       child: Text(
//                         "No Finance  have been recorded for this vehicle.",
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               KHeight30,

//               /// Brokerage Details Section
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(
//                   20,
//                 ), // More generous padding like original
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 6,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Expenses Header with + Button
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Brokerage details",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black,
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                         Container(
//                           width: 24,
//                           height: 24,
//                           decoration: BoxDecoration(
//                             color: Colors.blue.shade50,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: Icon(
//                               Icons.add,
//                               color: Colors.blue,
//                               size: 16,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: 40), // Increased spacing
//                     // Body (empty state)
//                     Center(
//                       child: Text(
//                         "No Brokerage  have been recorded for this vehicle.",
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVehicleImage(String path) {
//     if (path.isEmpty) {
//       return Center(child: Icon(Icons.car_repair, size: 50));
//     }

//     if (path.startsWith('http') || path.startsWith('https')) {
//       return Image.network(
//         path,
//         fit: BoxFit.cover,
//         errorBuilder: (_, __, ___) =>
//             Center(child: Icon(Icons.car_repair, size: 50)),
//       );
//     } else if (kIsWeb) {
//       return Image.network(
//         path,
//         fit: BoxFit.cover,
//         errorBuilder: (_, __, ___) =>
//             Center(child: Icon(Icons.car_repair, size: 50)),
//       );
//     } else {
//       return Image.file(
//         File(path),
//         fit: BoxFit.cover,
//         errorBuilder: (_, __, ___) =>
//             Center(child: Icon(Icons.car_repair, size: 50)),
//       );
//     }
//   }

//   //date format
//   Future<void> _pickDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _dateController.text = _dateFormat.format(picked); // 👈 format applied
//       });
//     }
//   }
// }

//new code

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/expense/expense_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/infrastructure/vehicle/vehicle_repositary.dart';
import 'package:my_new_project/widgets/expense/add_expense_dialog.dart';
import 'package:my_new_project/widgets/sales/profit_summary_card.dart';
import 'package:my_new_project/widgets/sales/sale_form.dart';

class ScreenVehicleDetails extends ConsumerStatefulWidget {
  final String vehicleId;
  final VoidCallback onBack;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ScreenVehicleDetails({
    super.key,
    required this.vehicleId,
    required this.onBack,
    this.onEdit,
    this.onDelete,
  });

  @override
  ConsumerState<ScreenVehicleDetails> createState() =>
      _ScreenVehicleDetailsState();
}

class _ScreenVehicleDetailsState extends ConsumerState<ScreenVehicleDetails> {
  String _selectedStatus = "available";

  final List<String> _paymentModes = [
    "Cash",
    "Card",
    "Bank Transfer",
    "Finance",
  ];
  String? _selectedMode;

  void _deletePartnership(Partnership partnership) async {
    final vehicle = ref
        .read(vehicleProvider)
        .vehicles
        .firstWhere((v) => v.id == widget.vehicleId);

    final updatedPartnerships =
        List<Partnership>.from(vehicle.partnerships ?? [])..removeWhere(
          (p) =>
              p.partnerName == partnership.partnerName &&
              p.contribution == partnership.contribution &&
              p.sharePercentage == partnership.sharePercentage,
        );

    final updatedVehicle = vehicle.copyWith(partnerships: updatedPartnerships);

    try {
      await ref.read(vehicleRepositoryProvider).updateVehicle(updatedVehicle);

      // Refresh local state
      await ref.read(vehicleProvider.notifier).loadVehicles();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Partnership deleted')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete partnership')),
      );
    }
  }

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  // Dropdown value
  String? _advancePayment;
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final vehicleState = ref.watch(vehicleProvider);

    // Promote to non-nullable by assigning and returning early
    final vehicle = vehicleState.vehicles.firstWhere(
      (v) => v.id == widget.vehicleId,
    );

    if (vehicle == null) {
      return const Center(child: Text("Vehicle not found"));
    }

    final expenseState = ref.watch(expenseProvider);
    final expenseForThisVehicle = expenseState.expenses
        .where((e) => e.vehicleId == vehicle.id)
        .toList();

    final totalExpenseAmount = expenseForThisVehicle.fold<double>(
      0.0,
      (sum, e) => sum + (double.tryParse(e.amount) ?? 0),
    );

    return Scaffold(
      body: Column(
        children: [
          // Fixed Header Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
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

                KHeight16,

                // Vehicle Title
                Text(
                  "${vehicle.make} ${vehicle.model} (${vehicle.year}) ${vehicle.registrationId}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                KHeight16,

                // Edit + Delete buttons
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
                        onPressed: () {
                          ref
                              .read(vehicleProvider.notifier)
                              .setVehicleToEdit(vehicle);
                          if (widget.onEdit != null) {
                            widget.onEdit!();
                          }
                        },
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
          ),

          // Scrollable Content Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cost Acquisition Card
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
                          "₹${vehicle.purchaseInfo.price}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        KHeight,
                        Text(
                          "(Buying Price: ₹${vehicle.purchaseInfo.price} + Total Expenses: ₹${totalExpenseAmount.toStringAsFixed(2)})",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  KHeight20,

                  // Total Profit (if sold)
                  if (vehicle.status.toLowerCase() == "sold") ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Total Profit",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "total profit",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "ownera profit",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Vehicle Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: vehicle.photos.isNotEmpty
                          ? PageView.builder(
                              itemCount: vehicle.photos.length,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  vehicle.photos[index],
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.network(
                              "https://wallpaperaccess.com/full/472325.jpg",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  KHeight16,

                  // Vehicle Information Section
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
                            const SizedBox(height: 5),
                            Text(
                              vehicle.color,
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
                              "${vehicle.mileage} km",
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
                              vehicle.fuelType,
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
                              vehicle.purchaseInfo.date
                                  .toString()
                                  .split("T")
                                  .first,
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
                              vehicle.description ?? "No additional notes.",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 12),

                        // Status section
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
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
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
                                            vehicle.id,
                                            value,
                                          );

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Status updated to $value",
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Failed to update status",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  KHeight16,

                  // Profit Summary or Sale Form
                  if (vehicle.status.toLowerCase() == "sold") ...[
                    ProfitSummaryCard(
                      vehicle: vehicle,
                      expenses: expenseForThisVehicle,
                    ),
                  ] else if (_selectedStatus == "sold") ...[
                    SaleForm(vehicle: vehicle),
                  ],

                  // Seller Details Section
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
                              vehicle.purchaseInfo.name,
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
                              vehicle.purchaseInfo.phone,
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
                              vehicle.purchaseInfo.address,
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
                              vehicle.purchaseInfo.modeOfPayment,
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
                              vehicle.purchaseInfo.price.toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Expenses Section
                  KHeight30,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
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
                              onPressed: vehicle.status.toLowerCase() == 'sold'
                                  ? null
                                  : () {
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
                                            builder:
                                                (context, scrollController) {
                                                  return SingleChildScrollView(
                                                    controller:
                                                        scrollController,
                                                    child: AddExpenseDialog(
                                                      vehicle: vehicle,
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
                        const SizedBox(height: 40),

                        // Body (empty state)
                        expenseForThisVehicle.isEmpty
                            ? Center(
                                child: Text(
                                  "No expenses have been recorded for this vehicle.",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Column(
                                children: expenseForThisVehicle.map((expense) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "#${expense.id}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Type:"),
                                            Text(expense.type.toUpperCase()),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Amount:"),
                                            Text("₹${expense.amount}"),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Date:"),
                                            Text(expense.date),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Description:"),
                                            Expanded(
                                              child: Text(
                                                expense.description ?? "",
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton.icon(
                                              icon: Icon(Icons.visibility),
                                              label: Text("View"),
                                              onPressed: () {
                                                // Your view logic here
                                              },
                                            ),
                                            SizedBox(width: 8),
                                            TextButton.icon(
                                              icon: Icon(Icons.edit),
                                              label: Text("Edit"),
                                              onPressed: () {
                                                // Your edit logic here
                                              },
                                            ),
                                            SizedBox(width: 8),
                                            TextButton.icon(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              label: Text(
                                                "Delete",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onPressed: () {
                                                // Your delete logic here
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),

                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            "Total: ₹${expenseForThisVehicle.fold<double>(0.0, (sum, item) => sum + (double.tryParse(item.amount) ?? 0.0)).toStringAsFixed(2)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Partnership Section
                  KHeight20,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
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
                          ],
                        ),
                        const SizedBox(height: 40),
                        // Body (empty state)
                        vehicle.partnerships != null &&
                                vehicle.partnerships!.isNotEmpty
                            ? ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: vehicle.partnerships!.length,
                                separatorBuilder: (_, __) => Divider(),
                                itemBuilder: (context, index) {
                                  final partnership =
                                      vehicle.partnerships![index];
                                  return ListTile(
                                    title: Text(
                                      partnership.partnerName ??
                                          'Unnamed Partner',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (partnership.contribution != null)
                                          Text(
                                            'Contribution: ₹${partnership.contribution}',
                                          ),
                                        if (partnership.sharePercentage != null)
                                          Text(
                                            'Profit Share: ${partnership.sharePercentage}%',
                                          ),
                                        if (partnership.paymentMode != null)
                                          Text(
                                            'Payment Mode: ${partnership.paymentMode}',
                                          ),
                                        if (partnership.contributionStatus !=
                                            null)
                                          Text(
                                            'Status: ${partnership.contributionStatus}',
                                          ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _deletePartnership(partnership);
                                      },
                                    ),
                                  );
                                },
                              )
                            : Center(
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

                  // Finance Details Section (if sold)
                  if (_selectedStatus == "sold") ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
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
                          const SizedBox(height: 40),
                          Center(
                            child: Text(
                              "No Finance have been recorded for this vehicle.",
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

                    // Brokerage Details Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
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
                          const SizedBox(height: 40),
                          Center(
                            child: Text(
                              "No Brokerage have been recorded for this vehicle.",
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
          ),
        ],
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

  // Date format
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
        _dateController.text = _dateFormat.format(picked);
      });
    }
  }
}
