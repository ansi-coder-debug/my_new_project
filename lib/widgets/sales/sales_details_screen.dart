// // screens/view_sale_record_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
// import 'package:my_new_project/core/models/sales.dart';
// import 'package:my_new_project/core/models/vehicle.dart';

// class ViewSaleRecordScreen extends ConsumerStatefulWidget {
//   final Vehicle vehicle;
  
//   const ViewSaleRecordScreen({
//     Key? key,
//     required this.vehicle,
//   }) : super(key: key);

//   @override
//   ConsumerState<ViewSaleRecordScreen> createState() => _ViewSaleRecordScreenState();
// }

// class _ViewSaleRecordScreenState extends ConsumerState<ViewSaleRecordScreen> {
//   bool _isEditing = false;
//   late TextEditingController _nameController;
//   late TextEditingController _phoneController;
//   late TextEditingController _addressController;
//   late TextEditingController _dateController;
//   late TextEditingController _priceController;
//   late TextEditingController _receivedPriceController;
//   late TextEditingController _paymentModeController;

//   @override
//   void initState() {
//     super.initState();
//     final saleInfo = widget.vehicle.saleInfo!;
    
//     _nameController = TextEditingController(text: saleInfo.name);
//     _phoneController = TextEditingController(text: saleInfo.phone);
//     _addressController = TextEditingController(text: saleInfo.address);
//     _dateController = TextEditingController(text: saleInfo.date);
//     _priceController = TextEditingController(text: saleInfo.price);
//     _receivedPriceController = TextEditingController(text: saleInfo.receivedPrice);
//     _paymentModeController = TextEditingController(text: saleInfo.modeOfPayment);
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _dateController.dispose();
//     _priceController.dispose();
//     _receivedPriceController.dispose();
//     _paymentModeController.dispose();
//     super.dispose();
//   }

//   void _toggleEdit() {
//     setState(() {
//       _isEditing = !_isEditing;
//     });
//   }

//   Future<void> _updateSaleRecord() async {
//     try {
//       final updatedSaleInfo = SaleInfo(
//         id: widget.vehicle.saleInfo!.id,
//         name: _nameController.text,
//         phone: _phoneController.text,
//         address: _addressController.text,
//         date: _dateController.text,
//         price: _priceController.text,
//         receivedPrice: _receivedPriceController.text,
//         modeOfPayment: _paymentModeController.text,
//         paymentStatus: widget.vehicle.saleInfo!.paymentStatus,
//       );

//       final updatedVehicle = widget.vehicle.copyWith(
//         saleInfo: updatedSaleInfo,
//       );

//       await ref.read(vehicleProvider.notifier).updateVehicle(updatedVehicle);
      
//       setState(() {
//         _isEditing = false;
//       });
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Sale record updated successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final saleInfo = widget.vehicle.saleInfo!;
//     final theme = Theme.of(context);
    
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('View Sale Record'),
//         actions: [
//           IconButton(
//             icon: Icon(_isEditing ? Icons.close : Icons.edit),
//             onPressed: _toggleEdit,
//           ),
//           if (_isEditing)
//             IconButton(
//               icon: const Icon(Icons.save),
//               onPressed: _updateSaleRecord,
//             ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Date Section
//             _buildSection(
//               title: 'Date',
//               child: _isEditing
//                   ? TextFormField(
//                       controller: _dateController,
//                       decoration: const InputDecoration(
//                         hintText: 'MM/DD/YYYY',
//                         border: OutlineInputBorder(),
//                       ),
//                     )
//                   : Text(
//                       saleInfo.date,
//                       style: theme.textTheme.titleMedium,
//                     ),
//             ),

//             const SizedBox(height: 24),

//             // Vehicle Section
//             _buildSection(
//               title: 'Vehicle',
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Vehicle Name
//                   Text(
//                     '${widget.vehicle.make} ${widget.vehicle.model}',
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Price and Received Price
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildAmountField(
//                           label: 'Price',
//                           controller: _priceController,
//                           isEditing: _isEditing,
//                           value: saleInfo.price,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: _buildAmountField(
//                           label: 'Received',
//                           controller: _receivedPriceController,
//                           isEditing: _isEditing,
//                           value: saleInfo.receivedPrice,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),

//                   // Payment Mode
//                   _buildInfoField(
//                     label: 'Payment Mode',
//                     controller: _paymentModeController,
//                     isEditing: _isEditing,
//                     value: saleInfo.modeOfPayment,
//                   ),
//                   const SizedBox(height: 12),

//                   // Customer Name
//                   _buildInfoField(
//                     label: 'Customer Name',
//                     controller: _nameController,
//                     isEditing: _isEditing,
//                     value: saleInfo.name,
//                   ),
//                   const SizedBox(height: 12),

//                   // Phone
//                   _buildInfoField(
//                     label: 'Phone',
//                     controller: _phoneController,
//                     isEditing: _isEditing,
//                     value: saleInfo.phone,
//                   ),
//                   const SizedBox(height: 12),

//                   // Address
//                   _buildInfoField(
//                     label: 'Address',
//                     controller: _addressController,
//                     isEditing: _isEditing,
//                     value: saleInfo.address,
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 32),

//             // Update Button (when not editing)
//             if (!_isEditing)
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _toggleEdit,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                   ),
//                   child: const Text('Update'),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSection({
//     required String title,
//     required Widget child,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: Theme.of(context).textTheme.titleLarge?.copyWith(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         child,
//       ],
//     );
//   }

//   Widget _buildAmountField({
//     required String label,
//     required TextEditingController controller,
//     required bool isEditing,
//     required String value,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: Theme.of(context).textTheme.bodySmall?.copyWith(
//             color: Colors.grey[600],
//           ),
//         ),
//         const SizedBox(height: 4),
//         isEditing
//             ? TextFormField(
//                 controller: controller,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   prefixText: '₹ ',
//                   border: OutlineInputBorder(),
//                 ),
//               )
//             : Text(
//                 '₹ $value',
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//       ],
//     );
//   }

//   Widget _buildInfoField({
//     required String label,
//     required TextEditingController controller,
//     required bool isEditing,
//     required String value,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: Theme.of(context).textTheme.bodySmall?.copyWith(
//             color: Colors.grey[600],
//           ),
//         ),
//         const SizedBox(height: 4),
//         isEditing
//             ? TextFormField(
//                 controller: controller,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//               )
//             : Text(
//                 value,
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//       ],
//     );
//   }
// }