// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:my_new_project/application/expense/expense_provider.dart';
// import 'package:my_new_project/application/finance/finance_provider.dart';
// import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
// import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/core/models/partnership.dart';
// import 'package:my_new_project/infrastructure/vehicle/vehicle_repositary.dart';
// import 'package:my_new_project/widgets/expense/add_expense_dialog.dart';
// import 'package:my_new_project/widgets/inventory/highlight_reusable_card.dart';
// import 'package:my_new_project/widgets/inventory/reusable_info_card.dart';
// import 'package:my_new_project/widgets/inventory/reusable_section_card.dart';
// import 'package:my_new_project/widgets/inventory/vehicle_info_card.dart';
// import 'package:my_new_project/widgets/partnerships/add_partnership_details.dart';
// import 'package:my_new_project/widgets/reusable/output_card.dart';
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

//   @override
//   void initState() {
//     super.initState();

//     // ⚠️ DON'T call ref.watch or ref.read for providers that depend on context here
//     // So we delay that work to AFTER the first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Load expenses if not already loaded
//       ref.read(expenseProvider.notifier).loadExpenses();

//       // Read vehicle and set status
//       final vehicleState = ref.read(vehicleProvider);
//       final vehicle = vehicleState.vehicles.firstWhere(
//         (v) => v.id == widget.vehicleId,
//         orElse: () => throw Exception("Vehicle not found"),
//       );

//       setState(() {
//         _selectedStatus = vehicle.status.toLowerCase();
//       });
//     });
//   }

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

//   // Controllers
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   // Dropdown value
//   String? _advancePayment;
//   final TextEditingController _dateController = TextEditingController();
//   DateTime? _selectedDate;
//   final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

//   @override
//   Widget build(BuildContext context) {
//     final vehicleState = ref.watch(vehicleProvider);

//     // Promote to non-nullable by assigning and returning early
//     final vehicle = vehicleState.vehicles.firstWhere(
//       (v) => v.id == widget.vehicleId,
//     );

//     if (vehicle == null) {
//       return const Center(child: Text("Vehicle not found"));
//     }

//     final expenseState = ref.watch(expenseProvider);
//     // final expenseForThisVehicle = expenseState.expenses
//     //     .where((e) => e.vehicleId == vehicle.id)
//     //     .toList();
//     final expenseForThisVehicle = expenseState.expenses
//         .where((e) => e.vehicleId.toString() == vehicle.id.toString())
//         .toList();

//     final totalExpenseAmount = expenseForThisVehicle.fold<double>(
//       0.0,
//       (sum, e) => sum + e.amount,
//       // (double.tryParse(e.amount) ?? 0),
//     );

//     //Finance Details
//     final allFinances = ref.watch(financeProvider).finances;
//     final vehicleFinances = allFinances
//         .where((f) => f.vehicleId == vehicle.id)
//         .toList();


//         // 🟢 Purchase Info
// final double purchasePrice = double.tryParse('${vehicle.purchaseInfo?.price}') ?? 0.0;
// final double purchasePaid = double.tryParse('${vehicle.purchaseInfo?.paidAmount }') ?? 0.0;
// final double purchaseBalance = purchasePrice - purchasePaid;
// final double buyingPrice = purchasePrice;//confusion


// // 🟢 Sale Info
// final double salePrice = double.tryParse(vehicle.saleInfo?.price ?? '0') ?? 0.0;
// final double saleReceived = double.tryParse(vehicle.saleInfo?.receivedPrice ?? '0') ?? 0.0;
// final double financeReceived =
//     vehicle.saleInfo?.financeInfo?.receivedPrice ?? 0.0;
// final double totalSaleReceived = saleReceived + financeReceived;
// final double saleBalance = salePrice - totalSaleReceived;

// // 🟢 Grand Total (purchase + expenses)
// final double grandTotal = purchasePrice + totalExpenseAmount;

// // 🟢 Brokerage
// final double totalBrokerage = (vehicle.brokerageInfo ?? []).fold(
//   0.0,
//   (sum, item) => sum + (double.tryParse(item.amount ?? '0') ?? 0.0),
// );

// // 🟢 Profit Calculations
// final double grossProfit = salePrice - grandTotal - totalBrokerage;
// final double partnerProfitShare = 0.0; // set dynamically if needed
// final double ownerProfit = grossProfit - partnerProfitShare;


 



//     return Scaffold(
//       body: Column(
//         children: [
//           // Fixed Header Section
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Back Button
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

//                 KHeight16,

//                 // Vehicle Title
//                 Text(
//                   "${vehicle.make} ${vehicle.model} (${vehicle.year}) ${vehicle.registrationId}",
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 KHeight16,

//                 // Edit + Delete buttons
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
//                           ref
//                               .read(vehicleProvider.notifier)
//                               .setVehicleToEdit(vehicle);
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
//           ),

//           // Scrollable Content Section
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                    // 1. Always show Cost of Acquisition
//                    HighlightCard(
//                     title: "Total Cost of Acquisition",
//                      amount:  "₹${grandTotal.toStringAsFixed(0)}",
//                      breakdown: "(Buying Price: ₹${buyingPrice.toStringAsFixed(0)} + Expenses: ₹${totalExpenseAmount.toStringAsFixed(0)})",
//                       backgroundColor: const Color(0xFF1565C0),
//                       ),
//                    /// 2. Show Purchase Balance if vehicle is not sold
//     if (vehicle.status.toLowerCase() != 'sold' && purchaseBalance > 0)
//       HighlightCard(
//         title: "Purchase Balance",
//         amount: "₹${purchaseBalance.toStringAsFixed(0)}",
//         breakdown: "(Total: ₹${purchasePrice.toStringAsFixed(0)} - Paid: ₹${purchasePaid.toStringAsFixed(0)})",
//         backgroundColor: Colors.orange.shade700,
//       ),

//     /// 3. If sold, show sale balance and profit
//     if (vehicle.status.toLowerCase() == 'sold') ...[
//       if (saleBalance != 0)
//         HighlightCard(
//           title: "Sale Balance",
//           amount: "₹${saleBalance.toStringAsFixed(0)}",
//           breakdown: "(Sale Amount: ₹${salePrice.toStringAsFixed(0)} - Received: ₹${totalSaleReceived.toStringAsFixed(0)})",
//           backgroundColor: Colors.deepPurple.shade700,
//         ),

//       HighlightCard(
//         title: grossProfit >= 0 ? "Total Profit" : "Total Loss",
//         amount: "₹${grossProfit.toStringAsFixed(0)}",
//         breakdown: "(Owner: ₹${ownerProfit.toStringAsFixed(0)} + Partners: ₹${partnerProfitShare.toStringAsFixed(0)})",
//         backgroundColor: grossProfit >= 0 ? Colors.green.shade700 : Colors.red.shade700,
//       ),
//     ],
       
//          // Profit Summary or Sale Form
//      if (vehicle.status.toLowerCase() == "sold") ...[
//                     ProfitSummaryCard(
//                       vehicle: vehicle,
//                       expenses: expenseForThisVehicle,
//                     ),
//                   ] else if (_selectedStatus == "sold") ...[
//                     SaleForm(vehicle: vehicle),
//                   ],
//   ],
// ),

              

//                   // Vehicle Image
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: AspectRatio(
//                       aspectRatio: 16 / 9,
//                       child: vehicle.photos.isNotEmpty
//                           ? PageView.builder(
//                               itemCount: vehicle.photos.length,
//                               itemBuilder: (context, index) {
//                                 return Image.network(
//                                   vehicle.photos[index],
//                                   fit: BoxFit.cover,
//                                 );
//                               },
//                             )
//                           : Image.network(
//                               "https://wallpaperaccess.com/full/472325.jpg",
//                               fit: BoxFit.cover,
//                             ),
//                     ),
//                   ),
//                   KHeight16,

//                   // Vehicle Information Section
//                   VehicleInfoCard(
//                     vehicle: vehicle,
//                     selectedStatus: _selectedStatus,
//                     onStatusChanged: (newStatus) async {
//                       setState(() {
//                         _selectedStatus = newStatus;
//                       });

//                       try {
//                         await ref
//                             .read(vehicleRepositoryProvider)
//                             .updateVehicleStatus(vehicle.id, newStatus);

//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text("Status updated to $newStatus"),
//                           ),
//                         );
//                       } catch (e) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Failed to update status"),
//                           ),
//                         );
//                       }
//                     },
//                   ),

//                   // Profit Summary or Sale Form
//                   // if (vehicle.status.toLowerCase() == "sold") ...[
//                   //   ProfitSummaryCard(
//                   //     vehicle: vehicle,
//                   //     expenses: expenseForThisVehicle,
//                   //   ),
//                   // ] else if (_selectedStatus == "sold") ...[
//                   //   SaleForm(vehicle: vehicle),
//                   // ],
             
                  
//                   KHeight30,

//                   // Seller Details Section
//                   ReusableInfoCard(
//                     title: "Seller Details",
//                     dataRows: [
//                       MapEntry("Name", vehicle.purchaseInfo.name),
//                       MapEntry("Phone", vehicle.purchaseInfo.phone),
//                       MapEntry("Address", vehicle.purchaseInfo.address),
//                       MapEntry(
//                         "Payment Mode",
//                         vehicle.purchaseInfo.modeOfPayment,
//                       ),
//                       MapEntry(
//                         "Buying Price",
//                         vehicle.purchaseInfo.paidAmount.toString(),
//                       ),
//                     ],
//                   ),
//                   KHeight20,

//                   ReusableInfoCard(
//                     title: "Buyer Details",
//                     dataRows: [
//                       MapEntry("Name", vehicle.saleInfo?.name ?? ""),
//                       MapEntry("Phone", vehicle.saleInfo?.phone ?? ""),
//                       MapEntry("Address", vehicle.saleInfo?.address ?? ""),
//                       MapEntry(
//                         "Sale Price",
//                         vehicle.saleInfo?.price?.toString() ?? "",
//                       ),
//                       MapEntry(
//                         "Sale Date",
//                         vehicle.saleInfo?.date?.toString() ?? "",
//                       ),
//                       MapEntry(
//                         "Payment Mode",
//                         vehicle.saleInfo?.modeOfPayment ?? "",
//                       ),
//                       MapEntry(
//                         "Payment Status",
//                         vehicle.saleInfo?.paymentStatus ?? "",
//                       ),
//                     ],
//                   ),
//                   KHeight30,

//                   // Expenses Section
//                   ReusableSectionCard(
//                     title: "Expenses",
//                     isAddEnabled: vehicle.status.toLowerCase() != 'sold',
//                     onAddPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) {
//                           return AddExpenseDialog(vehicle: vehicle);
//                         },
//                       );
//                     },
//                     isEmpty: expenseForThisVehicle.isEmpty,
//                     emptyMessage:
//                         "No expenses have been recorded for this vehicle.",
//                     children: [
//                       ...expenseForThisVehicle.map((expense) {
//                         final date = DateFormat('d/M/y').format(expense.date);

//                         return OutputCard(
//                           title:
//                               expense.expenseTypeName?.toUpperCase() ??
//                               "UNKNOWN",
//                           subtitle: "${expense.paymentStatus} - $date",
//                           amount: expense.amount,
//                           received: expense.expensePaid,
//                           receivedLabel: "Paid",
//                           showMenu: true,
//                           onView: () {
//                             showDialog(
//                               context: context,
//                               builder: (_) => AddExpenseDialog(
//                                 vehicle: vehicle,
//                                 expense: expense,
//                                 isViewOnly: true,
//                               ),
//                             );
//                           },
//                           onEdit: () {
//                             showDialog(
//                               context: context,
//                               builder: (_) => AddExpenseDialog(
//                                 vehicle: vehicle,
//                                 expense: expense,
//                                 isViewOnly: false,
//                               ),
//                             );
//                           },
//                           onDelete: () async {
//                             final confirm = await showDialog<bool>(
//                               context: context,
//                               builder: (_) => AlertDialog(
//                                 title: const Text('Confirm Delete'),
//                                 content: const Text(
//                                   'Are you sure you want to delete this expense?',
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () =>
//                                         Navigator.pop(context, false),
//                                     child: const Text('Cancel'),
//                                   ),
//                                   ElevatedButton(
//                                     onPressed: () =>
//                                         Navigator.pop(context, true),
//                                     child: const Text('Delete'),
//                                   ),
//                                 ],
//                               ),
//                             );

//                             if (confirm == true) {
//                               await ref
//                                   .read(expenseProvider.notifier)
//                                   .deleteExpense(expense.id!);
//                               ref.read(expenseProvider.notifier).loadExpenses();
//                               if (context.mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text("Expense deleted"),
//                                   ),
//                                 );
//                               }
//                             }
//                           },
//                         );
//                       }).toList(),
//                     ],
//                   ),
//                   KHeight20,

//                   // Partnership Section
//                   ReusableSectionCard(
//                     title: "Partnership",
//                     isAddEnabled: vehicle.status.toLowerCase() != 'sold',
//                     // onAddPressed: (){
//                     //  // dont have a add option
//                     // },
//                     isEmpty:
//                         vehicle.partnerships == null ||
//                         vehicle.partnerships!.isEmpty,
//                     emptyMessage:
//                         "No partnerships have been recorded for this vehicle.",
//                     children: vehicle.partnerships != null
//                         ? vehicle.partnerships!.map((partnership) {
//                             final contribution =
//                                 double.tryParse(
//                                   partnership.contribution ?? '0',
//                                 ) ??
//                                 0.0;
//                             final received = contribution;

//                             // Optional: calculate dynamic label
//                             String status;
//                             if (received >= contribution && contribution > 0) {
//                               status = 'paid';
//                             } else if (received > 0 &&
//                                 received < contribution) {
//                               status = 'partial';
//                             } else {
//                               status = 'pending';
//                             }

//                             final receivedLabel =
//                                 status[0].toUpperCase() + status.substring(1);

//                             return OutputCard(
//                               title:
//                                   partnership.partnerName ?? 'Unnamed Partner',
//                               subtitle: vehicle.make + ' ' + vehicle.model,
//                               amount: contribution,
//                               received: received,
//                               receivedLabel: receivedLabel,
//                               paymentMode: partnership.paymentMode,
//                               status: status,
//                               showMenu: true,
//                               onEdit: () {},
//                               onDelete: () {},
//                               onView: () {},
//                             );
//                           }).toList()
//                         : [],
//                   ),

                  
//                   // Finance Details Section (if sold)
//                   if (_selectedStatus == "sold") ...[
//                     KHeight20,

//                     ReusableSectionCard(
//                       title: "Finance Details",
//                       isEmpty: vehicleFinances.isEmpty,
//                       emptyMessage:
//                           "No Financial details have been recorded for this vehicle.",
//                       children: vehicleFinances.map((finance) {
//                         final vehicleName =
//                             finance.vehicle?.name ?? 'Unknown Vehicle';
//                         final financierName =
//                             finance.financier?.companyName ??
//                             'Unknown Financier';
//                         final amount = finance.amount;
//                         final received = finance.receivedPrice;
//                         final paymentMode = finance.toAccount ?? 'Unknown';
//                         final status = finance.paymentStatus ?? 'Unknown';

//                         // Dynamic label logic
//                         String receivedLabel;
//                         if (received >= amount && amount > 0) {
//                           receivedLabel = 'Paid';
//                         } else if (received > 0 && received < amount) {
//                           receivedLabel = 'Partial';
//                         } else {
//                           receivedLabel = 'Pending';
//                         }

//                         return OutputCard(
//                           title: vehicleName.toUpperCase(),
//                           subtitle: financierName,
//                           amount: amount,
//                           received: received,
//                           balance: amount - received,
//                           receivedLabel: receivedLabel,
//                           paymentMode: paymentMode,
//                           status: status,
//                           receivedLabelColor: Colors.green,
//                           showBalanceBelowPaid: true,
//                           showMenu: true,
//                           onView: () {
//                             // Optional: show view-only dialog
//                           },
//                           onEdit: () {
//                             // Optional: show edit form
//                           },
//                           onDelete: () {
//                             // Optional: confirm and delete
//                           },
//                         );
//                       }).toList(),
//                     ),
//                     KHeight30,

//                     // Brokerage Details Section
//                     ReusableSectionCard(
//                       title: "Brokerage",
//                       isAddEnabled: vehicle.status.toLowerCase() != 'sold',
//                       // Optional: implement onAddPressed
//                       isEmpty:
//                           vehicle.brokerageInfo == null ||
//                           vehicle.brokerageInfo!.isEmpty,
//                       emptyMessage:
//                           "No brokerage records have been recorded for this vehicle.",
//                       children: vehicle.brokerageInfo != null
//                           ? vehicle.brokerageInfo!.map((brokerage) {
//                               final doubleAmount =
//                                   double.tryParse(brokerage.amount) ?? 0.0;
//                               final doublePaid =
//                                   double.tryParse(
//                                     brokerage.brokeragePaid ?? '0',
//                                   ) ??
//                                   0.0;
//                               final doubleBalance = doubleAmount - doublePaid;

//                               // Status calculation
//                               String computedStatus;
//                               if (doublePaid == 0) {
//                                 computedStatus = 'pending';
//                               } else if (doublePaid < doubleAmount) {
//                                 computedStatus = 'partial';
//                               } else {
//                                 computedStatus = 'paid';
//                               }

//                               // Capitalize first letter of label
//                               final receivedLabel =
//                                   computedStatus[0].toUpperCase() +
//                                   computedStatus.substring(1);

//                               return OutputCard(
//                                 title: brokerage.brokerName.toUpperCase(),
//                                 subtitle: '',

//                                 amount: doubleAmount,

//                                 titleStyle: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 showMenu: true,
//                                 addTopSubtitleSpacing: false,
//                                 showBalanceBelowPaid: true,
//                                 onView: () {
//                                   // TODO: Add view logic
//                                 },
//                                 onEdit: () {
//                                   // TODO: Add edit logic
//                                 },
//                                 onDelete: () {
//                                   // TODO: Add delete logic
//                                 },
//                               );
//                             }).toList()
//                           : [],
//                     ),
//                   ],
//                 ],
      
//               ),
//             ),
            
        
//         ]
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

//   // Date format
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
//         _dateController.text = _dateFormat.format(picked);
//       });
//     }
//   }
// }
























import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/expense/expense_provider.dart';
import 'package:my_new_project/application/finance/finance_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/infrastructure/vehicle/vehicle_repositary.dart';
import 'package:my_new_project/widgets/expense/add_expense_dialog.dart';
import 'package:my_new_project/widgets/inventory/highlight_reusable_card.dart';
import 'package:my_new_project/widgets/inventory/reusable_info_card.dart';
import 'package:my_new_project/widgets/inventory/reusable_section_card.dart';
import 'package:my_new_project/widgets/inventory/vehicle_info_card.dart';
import 'package:my_new_project/widgets/partnerships/add_partnership_details.dart';
import 'package:my_new_project/widgets/reusable/output_card.dart';
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

  @override
  void initState() {
    super.initState();

    // ⚠️ DON'T call ref.watch or ref.read for providers that depend on context here
    // So we delay that work to AFTER the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load expenses if not already loaded
      ref.read(expenseProvider.notifier).loadExpenses();

      // Read vehicle and set status
      final vehicleState = ref.read(vehicleProvider);
      final vehicle = vehicleState.vehicles.firstWhere(
        (v) => v.id == widget.vehicleId,
        orElse: () => throw Exception("Vehicle not found"),
      );

      setState(() {
        _selectedStatus = vehicle.status.toLowerCase();
      });
    });
  }

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
        List<Partnership>.from(vehicle.partnerships ?? [])
          ..removeWhere((p) =>
              p.partnerName == partnership.partnerName &&
              p.contribution == partnership.contribution &&
              p.sharePercentage == partnership.sharePercentage);

    final updatedVehicle = vehicle.copyWith(partnerships: updatedPartnerships);

    try {
      await ref.read(vehicleRepositoryProvider).updateVehicle(updatedVehicle);

      // Refresh local state
      await ref.read(vehicleProvider.notifier).loadVehicles();

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Partnership deleted')));
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
        .where((e) => e.vehicleId.toString() == vehicle.id.toString())
        .toList();

    final totalExpenseAmount = expenseForThisVehicle.fold<double>(
      0.0,
      (sum, e) => sum + e.amount,
    );

    //Finance Details
    final allFinances = ref.watch(financeProvider).finances;
    final vehicleFinances =
        allFinances.where((f) => f.vehicleId == vehicle.id).toList();

    // 🟢 Purchase Info
    final double purchasePrice =
        double.tryParse('${vehicle.purchaseInfo?.price}') ?? 0.0;
    final double purchasePaid =
        double.tryParse('${vehicle.purchaseInfo?.paidAmount}') ?? 0.0;
    final double purchaseBalance = purchasePrice - purchasePaid;
    final double buyingPrice = purchasePrice; //confusion

    // 🟢 Sale Info
    final double salePrice =
        double.tryParse(vehicle.saleInfo?.price ?? '0') ?? 0.0;
    final double saleReceived =
        double.tryParse(vehicle.saleInfo?.receivedPrice ?? '0') ?? 0.0;
    final double financeReceived =
        vehicle.saleInfo?.financeInfo?.receivedPrice ?? 0.0;
    final double totalSaleReceived = saleReceived + financeReceived;
    final double saleBalance = salePrice - totalSaleReceived;

    // 🟢 Grand Total (purchase + expenses)
    final double grandTotal = purchasePrice + totalExpenseAmount;

    // 🟢 Brokerage
    final double totalBrokerage = (vehicle.brokerageInfo ?? []).fold(
      0.0,
      (sum, item) => sum + (double.tryParse(item.amount ?? '0') ?? 0.0),
    );

    // 🟢 Profit Calculations
    final double grossProfit = salePrice - grandTotal - totalBrokerage;
    final double partnerProfitShare = 0.0; // set dynamically if needed
    final double ownerProfit = grossProfit - partnerProfitShare;

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
                  // 1. Always show Cost of Acquisition
                  HighlightCard(
                    title: "Total Cost of Acquisition",titleColor: Colors.black,
                    amount: "₹${grandTotal.toStringAsFixed(0)}",amountColor: Colors.blue,
                    breakdown:
                        "(Buying Price: ₹${buyingPrice.toStringAsFixed(0)} + Expenses: ₹${totalExpenseAmount.toStringAsFixed(0)})",breakdownColor: Colors.black,
                    backgroundColor: Colors.white70,
                  ),
                    KHeight,

                  /// 2. Show Purchase Balance if vehicle is not sold
                  if (vehicle.status.toLowerCase() != 'sold' && purchaseBalance > 0)
                    HighlightCard(
                      title: "Purchase Balance",titleColor: Colors.white,
                      amount: "₹${purchaseBalance.toStringAsFixed(0)}",amountColor: Colors.white,
                      breakdown:
                          "(Total: ₹${purchasePrice.toStringAsFixed(0)} - Paid: ₹${purchasePaid.toStringAsFixed(0)})",breakdownColor: Colors.white,
                      backgroundColor: purchasePaid<purchasePrice
                      ?Colors.red.shade300 // Unpaid → red
                      :Colors.green.shade100,// Fully paid → green

                    ),
                    KHeight,

                  /// 3. If sold, show sale balance and profit
                  if (vehicle.status.toLowerCase() == 'sold') ...[
                    if (saleBalance != 0)
                      HighlightCard(
                        title: "Sale Balance",titleColor: Colors.white,
                        amount: "₹${saleBalance.toStringAsFixed(0)}",amountColor: Colors.white,
                        breakdown:
                            "(Sale Amount: ₹${salePrice.toStringAsFixed(0)} - Received Balance: ₹${totalSaleReceived.toStringAsFixed(0)})",breakdownColor: Colors.white,
                        backgroundColor:totalSaleReceived < salePrice
                       ? Colors.red.shade700   // Not fully received → red
                        : Colors.green.shade600, // Fully received → green
                      ),
                        KHeight,

                    HighlightCard(
                      title: grossProfit >= 0 ? "Total Profit" : "Total Loss",titleColor: Colors.white,
                      amount: "₹${grossProfit.toStringAsFixed(0)}",amountColor: Colors.white,
                      breakdown:
                          "(Owner: ₹${ownerProfit.toStringAsFixed(0)} + Partners: ₹${partnerProfitShare.toStringAsFixed(0)})",breakdownColor: Colors.white,
                      backgroundColor: grossProfit >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ],
                  KHeight20,

                 

                  // Vehicle Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 16,
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
                  KHeight30,

                  // Vehicle Information Section
                  VehicleInfoCard(
                    vehicle: vehicle,
                    selectedStatus: _selectedStatus,
                    onStatusChanged: (newStatus) async {
                      setState(() {
                        _selectedStatus = newStatus;
                      });

                      try {
                        await ref
                            .read(vehicleRepositoryProvider)
                            .updateVehicleStatus(vehicle.id, newStatus);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Status updated to $newStatus"),
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
                  KHeight30,

                  // Seller Details Section
                  ReusableInfoCard(
                    title: "Seller Details",
                    dataRows: [
                      MapEntry("Name", vehicle.purchaseInfo.name),
                      MapEntry("Phone", vehicle.purchaseInfo.phone),
                      MapEntry("Address", vehicle.purchaseInfo.address),
                      MapEntry(
                        "Payment Mode",
                        vehicle.purchaseInfo.modeOfPayment,
                      ),
                      MapEntry(
                        "Buying Price",
                        vehicle.purchaseInfo.paidAmount.toString(),
                      ),
                    ],
                  ),
                  KHeight20,

                  ReusableInfoCard(
                    title: "Buyer Details",
                    dataRows: [
                      MapEntry("Name", vehicle.saleInfo?.name ?? ""),
                      MapEntry("Phone", vehicle.saleInfo?.phone ?? ""),
                      MapEntry("Address", vehicle.saleInfo?.address ?? ""),
                      MapEntry(
                        "Sale Price",
                        vehicle.saleInfo?.price?.toString() ?? "",
                      ),
                      MapEntry(
                        "Sale Date",
                        vehicle.saleInfo?.date?.toString() ?? "",
                      ),
                      MapEntry(
                        "Payment Mode",
                        vehicle.saleInfo?.modeOfPayment ?? "",
                      ),
                      MapEntry(
                        "Payment Status",
                        vehicle.saleInfo?.paymentStatus ?? "",
                      ),
                    ],
                  ),
                  KHeight30,

                   // Profit Summary or Sale Form
                  if (vehicle.status.toLowerCase() == "sold") ...[
                    ProfitSummaryCard(
                      vehicle: vehicle,
                      expenses: expenseForThisVehicle,
                    ),
                  ] else if (_selectedStatus == "sold") ...[
                    SaleForm(vehicle: vehicle),
                  ],

                  // Expenses Section
                  ReusableSectionCard(
                    title: "Expenses",
                    isAddEnabled: vehicle.status.toLowerCase() != 'sold',
                    onAddPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AddExpenseDialog(vehicle: vehicle);
                        },
                      );
                    },
                    isEmpty: expenseForThisVehicle.isEmpty,
                    emptyMessage:
                        "No expenses have been recorded for this vehicle.",
                    children: [
                      ...expenseForThisVehicle.map((expense) {
                        final date = DateFormat('d/M/y').format(expense.date);

                        return OutputCard(
                          title: expense.expenseTypeName?.toUpperCase() ??
                              "UNKNOWN",
                          subtitle: "${expense.paymentStatus} - $date",
                          amount: expense.amount,
                          received: expense.expensePaid,
                          receivedLabel: "Paid",
                          showMenu: true,
                          onView: () {
                            showDialog(
                              context: context,
                              builder: (_) => AddExpenseDialog(
                                vehicle: vehicle,
                                expense: expense,
                                isViewOnly: true,
                              ),
                            );
                          },
                          onEdit: () {
                            showDialog(
                              context: context,
                              builder: (_) => AddExpenseDialog(
                                vehicle: vehicle,
                                expense: expense,
                                isViewOnly: false,
                              ),
                            );
                          },
                          onDelete: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                  'Are you sure you want to delete this expense?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await ref
                                  .read(expenseProvider.notifier)
                                  .deleteExpense(expense.id!);
                              ref.read(expenseProvider.notifier).loadExpenses();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Expense deleted"),
                                  ),
                                );
                              }
                            }
                          },
                        );
                      }).toList(),
                    ],
                  ),
                  KHeight20,

                  // Partnership Section
                  ReusableSectionCard(
                    title: "Partnership",
                    isAddEnabled: vehicle.status.toLowerCase() != 'sold',
                    isEmpty: vehicle.partnerships == null ||
                        vehicle.partnerships!.isEmpty,
                    emptyMessage:
                        "No partnerships have been recorded for this vehicle.",
                    children: vehicle.partnerships != null
                        ? vehicle.partnerships!.map((partnership) {
                            final contribution =
                                double.tryParse(partnership.contribution ?? '0') ??
                                    0.0;
                            final received = contribution;

                            // Optional: calculate dynamic label
                            String status;
                            if (received >= contribution && contribution > 0) {
                              status = 'paid';
                            } else if (received > 0 && received < contribution) {
                              status = 'partial';
                            } else {
                              status = 'pending';
                            }

                            final receivedLabel =
                                status[0].toUpperCase() + status.substring(1);

                            return OutputCard(
                              title:
                                  partnership.partnerName ?? 'Unnamed Partner',
                              subtitle: vehicle.make + ' ' + vehicle.model,
                              amount: contribution,
                              received: received,
                              receivedLabel: receivedLabel,
                              paymentMode: partnership.paymentMode,
                              status: status,
                              showMenu: true,
                              onEdit: () {},
                              onDelete: () {},
                              onView: () {},
                            );
                          }).toList()
                        : [],
                  ),

                  // Finance Details Section (if sold)
                  if (_selectedStatus == "sold") ...[
                    KHeight20,
                    ReusableSectionCard(
                      title: "Finance Details",
                      isEmpty: vehicleFinances.isEmpty,
                      emptyMessage:
                          "No Financial details have been recorded for this vehicle.",
                      children: vehicleFinances.map((finance) {
                        final vehicleName =
                            finance.vehicle?.name ?? 'Unknown Vehicle';
                        final financierName =
                            finance.financier?.companyName ??
                                'Unknown Financier';
                        final amount = finance.amount;
                        final received = finance.receivedPrice;
                        final paymentMode = finance.toAccount ?? 'Unknown';
                        final status = finance.paymentStatus ?? 'Unknown';

                        // Dynamic label logic
                        String receivedLabel;
                        if (received >= amount && amount > 0) {
                          receivedLabel = 'Paid';
                        } else if (received > 0 && received < amount) {
                          receivedLabel = 'Partial';
                        } else {
                          receivedLabel = 'Pending';
                        }

                        return OutputCard(
                          title: vehicleName.toUpperCase(),
                          subtitle: financierName,
                          amount: amount,
                          received: received,
                          balance: amount - received,
                          receivedLabel: receivedLabel,
                          paymentMode: paymentMode,
                          status: status,
                          receivedLabelColor: Colors.green,
                          showBalanceBelowPaid: true,
                          showMenu: true,
                          onView: () {
                            // Optional: show view-only dialog
                          },
                          onEdit: () {
                            // Optional: show edit form
                          },
                          onDelete: () {
                            // Optional: confirm and delete
                          },
                        );
                      }).toList(),
                    ),
                    KHeight30,

                    // Brokerage Details Section
                    ReusableSectionCard(
                      title: "Brokerage",
                      isAddEnabled: vehicle.status.toLowerCase() != 'sold',
                      // Optional: implement onAddPressed
                      isEmpty: vehicle.brokerageInfo == null ||
                          vehicle.brokerageInfo!.isEmpty,
                      emptyMessage:
                          "No brokerage records have been recorded for this vehicle.",
                      children: vehicle.brokerageInfo != null
                          ? vehicle.brokerageInfo!.map((brokerage) {
                              final doubleAmount =
                                  double.tryParse(brokerage.amount) ?? 0.0;
                              final doublePaid =
                                  double.tryParse(
                                          brokerage.brokeragePaid ?? '0') ??
                                      0.0;
                              final doubleBalance = doubleAmount - doublePaid;

                              // Status calculation
                              String computedStatus;
                              if (doublePaid == 0) {
                                computedStatus = 'pending';
                              } else if (doublePaid < doubleAmount) {
                                computedStatus = 'partial';
                              } else {
                                computedStatus = 'paid';
                              }

                              // Capitalize first letter of label
                              final receivedLabel =
                                  computedStatus[0].toUpperCase() +
                                      computedStatus.substring(1);

                              return OutputCard(
                                title: brokerage.brokerName.toUpperCase(),
                                subtitle: '',
                                amount: doubleAmount,
                                titleStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                showMenu: true,
                                addTopSubtitleSpacing: false,
                                showBalanceBelowPaid: true,
                                onView: () {
                                  // TODO: Add view logic
                                },
                                onEdit: () {
                                  // TODO: Add edit logic
                                },
                                onDelete: () {
                                  // TODO: Add delete logic
                                },
                              );
                            }).toList()
                          : [],
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