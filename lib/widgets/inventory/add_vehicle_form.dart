// import 'dart:io';

// //new
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
// import 'package:my_new_project/core/models/purchase.dart';

// import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/core/models/partnership.dart';
// import 'package:my_new_project/core/models/sales.dart';
// import 'package:my_new_project/core/models/vehicle.dart';
// import 'package:uuid/uuid.dart';

// class AddVehicleForm extends ConsumerStatefulWidget {
//   final Key? formKey;
//   final VoidCallback? onCancel;
//   final VoidCallback onAddComplete;
//   final Vehicle? vehicleToEdit;
//   final Vehicle? vehicle;

//   const AddVehicleForm({
//     super.key,
//     this.formKey,
//     this.onCancel,
//     required this.onAddComplete,
//     this.vehicleToEdit,
//     this.vehicle,
//   });

//   @override
//   ConsumerState<AddVehicleForm> createState() => AddVehicleFormState();
// }

// class AddVehicleFormState extends ConsumerState<AddVehicleForm> {
//   File? _pickedImage;
//   bool _showPartnershipFields = false;
//   bool _showSalesForm = false;
//   DateTime? _startDate;
//   final _formKey = GlobalKey<FormState>(); //for validate
//   bool _formWasReset = false;

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();

//     final PickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (PickedFile != null) {
//       setState(() {
//         _pickedImage = File(PickedFile.path);
//       });
//     }
//   }

//   String _status = 'Available';

//   // String? selectedStatus;

//   final TextEditingController _makeController = TextEditingController();
//   final TextEditingController _modelController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _registrationIdController =
//       TextEditingController();
//   final TextEditingController _colorController = TextEditingController();
//   final TextEditingController _vinController = TextEditingController();
//   final TextEditingController _imageUrlController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _purchaseDateController = TextEditingController();
//   final TextEditingController _idController = TextEditingController();
//   final TextEditingController _yearController = TextEditingController();
//   // Partnership controllers
//   final TextEditingController _partnerNameController = TextEditingController();
//   final TextEditingController _contactPersonController =
//       TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _sharePercentageController =
//       TextEditingController();
//   //new code purchase
//   final TextEditingController _sellerNameController = TextEditingController();
//   final TextEditingController _sellerPhoneController = TextEditingController();
//   final TextEditingController _sellerAddressController =
//       TextEditingController();
//   final TextEditingController _paymentModeController = TextEditingController();
//   // sales
//   final TextEditingController _buyerNameController = TextEditingController();
//   final TextEditingController _buyerPhoneController = TextEditingController();
//   final TextEditingController _buyerAddressController = TextEditingController();
//   final TextEditingController _modeOfPaymentController =
//       TextEditingController();
//   final TextEditingController _saleDateController = TextEditingController();

//   @override
//   void dispose() {
//     //n
//     _makeController.dispose();
//     _modelController.dispose();
//     _priceController.dispose();
//     _registrationIdController.dispose();
//     _colorController.dispose();
//     _vinController.dispose();
//     _imageUrlController.dispose();
//     _idController.dispose();
//     _yearController.dispose();
//     //partnership dispose
//     _partnerNameController.dispose();
//     _contactPersonController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _sharePercentageController.dispose();
//     //sales
//     _buyerNameController.dispose();
//     _buyerPhoneController.dispose();
//     _buyerAddressController.dispose();
//     _modeOfPaymentController.dispose();
//     _saleDateController.dispose();

//     super.dispose();
//   }
// @override
// void initState() {
//   super.initState();
//    print('🚨 initState called in AddVehicleForm');

//   // RESET ALL CONTROLLERS IMMEDIATELY
//    resetFormFields();

//  // Only AFTER reset, check if editing
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     final vehicle = ref.read(vehicleProvider).vehicleToEdit;

//     if (vehicle != null) {
//       print('✏️ Editing existing vehicle');
//       _makeController.text = vehicle.title;
//       _imageUrlController.text = vehicle.imageUrl;
//       _yearController.text = vehicle.year;
//       _priceController.text = vehicle.price;
//       _registrationIdController.text = vehicle.registrationId;
//       _colorController.text = vehicle.color;
//       _vinController.text = vehicle.vin;
//       _status = vehicle.status;

//       final purchaseList = Hive.box<Purchase>('purchases')
//           .values
//           .cast<Purchase>()
//           .where((p) => p.vehicleId == vehicle.id)
//           .toList();

//       if (purchaseList.isNotEmpty) {
//         final purchase = purchaseList.first;
//         _purchaseDateController.text = purchase.date;
//         _sellerNameController.text = purchase.name;
//         _sellerPhoneController.text = purchase.phone;
//         _sellerAddressController.text = purchase.address;
//         _paymentModeController.text = purchase.modeOfPayment;
//       }
//     } else {
//        print('🆕 Fresh add form');
//        // Ensure fresh ID for new vehicle
//       final uuid = Uuid();
//       _idController.text = uuid.v4();

//     }
//   });
// }

//   // @override
//   // void initState() {
//   //   super.initState();

//   //   // Get vehicle from Riverpod instead of widget
//   //   final vehicle = ref.read(vehicleProvider).vehicleToEdit;

//   //   if (vehicle != null) {
//   //     //Editing existing vehicle — populate fields from the vehicle object
//   //     _makeController.text = vehicle.title;
//   //     _imageUrlController.text = vehicle.imageUrl;
//   //     _yearController.text = vehicle.year;
//   //     _priceController.text = vehicle.price;
//   //     _registrationIdController.text = vehicle.registrationId;
//   //     _colorController.text = vehicle.color;
//   //     _vinController.text = vehicle.vin;
//   //     // selectedStatus = vehicle.status;
//   //     _status = vehicle.status;

//   //     //Attempt to find a matching purchase record by vehicle ID
//   //     Purchase? purchase;
//   //     final PurchaseList = Hive.box<Purchase>('purchases').values
//   //         .cast<Purchase>()
//   //         .where((p) => p.vehicleId == vehicle.id)
//   //         .toList();

//   //     if (PurchaseList.isNotEmpty) {
//   //       purchase = PurchaseList.first;
//   //     }

//   //     // If a matching purchase was found, fill the form fields
//   //     if (purchase != null) {
//   //       _purchaseDateController.text = purchase.date;
//   //       _sellerNameController.text = purchase.name;
//   //       _sellerPhoneController.text = purchase.phone;
//   //       _sellerAddressController.text = purchase.address;
//   //       _paymentModeController.text = purchase.modeOfPayment;
//   //     }
//   //   } else {
//   //     // new vehicle case auto generate a new unique id
//   //     final uuid = Uuid();
//   //     _idController.text = uuid.v4(); // ✅ Auto-generate a new unique ID
//   //   }
//   // }

//   //partnership field _buildtextfield
//   Widget _buildTextField(TextEditingController controller, String label) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(color: Colors.black)),
//         SizedBox(height: 4),
//         TextFormField(
//           controller: controller,
//           style: TextStyle(color: Colors.black),
//           decoration: InputDecoration(
//             contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//             border: OutlineInputBorder(),
//           ),
//         ),

//         SizedBox(height: 16),
//       ],
//     );
//   }

//   // condition to check partnership field is empty or not if empty vehicle details save
//   bool isPartnershipFilled() {
//     return _partnerNameController.text.trim().isNotEmpty ||
//         _contactPersonController.text.trim().isNotEmpty ||
//         _emailController.text.trim().isNotEmpty ||
//         _phoneController.text.trim().isNotEmpty ||
//         _sharePercentageController.text.trim().isNotEmpty ||
//         _startDate != null;
//   }

//   // //clear controllers add button
//   void resetFormFields() {
//      setState(() {
//      print('🧹 resetFormFields CALLED');
//     _formKey.currentState?.reset();
//     _makeController.clear();
//     _modelController.clear();
//     _yearController.clear();
//     _priceController.clear();
//     _registrationIdController.clear();
//     _colorController.clear();
//     _vinController.clear();
//     _imageUrlController.clear();
//     _descriptionController.clear();
//     _purchaseDateController.clear();
//     _partnerNameController.clear();
//     _contactPersonController.clear();
//     _emailController.clear();
//     _phoneController.clear();
//     _sharePercentageController.clear();
//     _sellerNameController.clear();
//     _sellerPhoneController.clear();
//     _sellerAddressController.clear();
//     _paymentModeController.clear();
//     _buyerNameController.clear();
//     _buyerPhoneController.clear();
//     _buyerAddressController.clear();
//     _modeOfPaymentController.clear();
//     _saleDateController.clear();

//       _pickedImage = null;
//       _status = 'Available';
//       _showPartnershipFields = false;
//       _showSalesForm = false;
//       _startDate = null;
//     });
//     print('🧼 resetFormFields() called');
//   }

//   //update

//   @override
//   Widget build(BuildContext context) {
//       print('🧱 build() called in AddVehicleForm');
//    // Watch vehicleProvider to listen to changes in state
//     final VehicleState = ref.watch(vehicleProvider); //1
//     final vehicleToEdit = ref
//         .watch(vehicleProvider)
//         .vehicleToEdit; // gets current vehicle being edited
//     print('🚘 vehicleToEdit at build: $vehicleToEdit');

//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   if (vehicleToEdit == null && !_formWasReset) {
//     //     resetFormFields();
//     //     _idController.text = const Uuid().v4();
//     //     _formWasReset = true;
//     //     print('🧼 Form reset in build()');
//     //   }
//     //   // Allow resetting again when switching to edit mode
//     //   if (vehicleToEdit != null && _formWasReset) {
//     //     _formWasReset = false;
//     //   }
//     // });

//     print('🚘 vehicleToEdit at build: $vehicleToEdit');
//     final isEditing = vehicleToEdit != null;
//     debugPrint('✏️ Form mode: ${isEditing ? "EDIT" : "ADD NEW"}');
//     //
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16),

//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               if (!_showSalesForm) ...[
//                 // it is making fields disappear when Sold staus updated
//                 Text('Vehicle ID', style: TextStyle(color: Colors.black)),
//                 TextFormField(
//                   controller: _idController,
//                   readOnly: true, // Optional: prevent users from modifying it
//                   style: TextStyle(color: Colors.black),
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 KHeight16,

//                 Text('Make', style: TextStyle(color: Colors.black)),
//                 TextFormField(
//                   controller: _makeController,
//                   style: TextStyle(color: Colors.black),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the make';
//                     }
//                     return null;
//                   },

//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),

//                 KHeight16,
//                 Text('Model', style: TextStyle(color: Colors.black)),
//                 TextFormField(
//                   controller: _modelController,
//                   style: TextStyle(color: Colors.black),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the model';
//                     }
//                     return null;
//                   },

//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 KHeight16,
//                 Text('Year', style: TextStyle(color: Colors.black)),
//                 TextFormField(
//                   controller: _yearController,
//                   style: TextStyle(color: Colors.black),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the year';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 KHeight16,

//                 // Price
//                 Text('Price', style: TextStyle(color: Colors.black)),
//                 TextFormField(
//                   controller: _priceController,
//                   style: TextStyle(color: Colors.black),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the price';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 KHeight16,

//                 // Mileage
//                 Text('RegistrationId', style: TextStyle(color: Colors.black)),
//                 TextFormField(
//                   controller: _registrationIdController,
//                   style: TextStyle(color: Colors.black),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the registrationId';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 KHeight16,

//                 // VIN
//                 Text('VIN', style: TextStyle(color: Colors.black)),
//                 TextFormField(
//                   controller: _vinController,
//                   style: TextStyle(color: Colors.black),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the vin';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 KHeight16,
//                 // Color
//                 Text('Color', style: TextStyle(color: Colors.black)),
//                 TextFormField(
//                   controller: _colorController,
//                   style: TextStyle(color: Colors.black),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the color';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ],
//               KHeight16,

//               // Status
//               Text('Status', style: TextStyle(color: Colors.black)),
//               DropdownButtonFormField<String>(
//                 value: _status,
//                 decoration: InputDecoration(
//                   // labelText: 'Status',
//                   border: OutlineInputBorder(),
//                 ),

//                 items:
//                     (vehicleToEdit != null
//                             ? [
//                                 'Available',
//                                 'Pending Sale',
//                                 'Sold',
//                                 'In Maintenance',
//                               ]
//                             : ['Available', 'Pending Sale', 'In Maintenance'])
//                         .map((status) {
//                           return DropdownMenuItem(
//                             value: status,
//                             child: Text(status),
//                           );
//                         })
//                         .toList(),

//                 onChanged: (value) {
//                   setState(() {
//                     _status = value!;
//                     _showSalesForm = _status == 'Sold';
//                   });
//                 },
//               ),

//               //sales
//               if (_showSalesForm)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     KHeight16,

//                     Text('Buyer Name', style: TextStyle(color: Colors.black)),
//                     TextFormField(
//                       controller: _buyerNameController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter buyer name';
//                         }
//                         return null;
//                       },

//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(
//                           vertical: 8,
//                           horizontal: 12,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 3, color: Colors.red),
//                         ),
//                       ),
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     KHeight16,

//                     Text('Buyer Phone', style: TextStyle(color: Colors.black)),
//                     TextFormField(
//                       controller: _buyerPhoneController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter buyer phone';
//                         }
//                         return null;
//                       },
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(
//                           vertical: 8,
//                           horizontal: 12,
//                         ),

//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 3, color: Colors.red),
//                         ),
//                       ),
//                       style: TextStyle(color: Colors.black),
//                     ),

//                     KHeight16,
//                     Text(
//                       'Buyer Address',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     TextFormField(
//                       controller: _buyerAddressController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter buyer address';
//                         }
//                         return null;
//                       },
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(
//                           vertical: 8,
//                           horizontal: 12,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 3, color: Colors.red),
//                         ),
//                       ),
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     KHeight16,
//                     Text(
//                       'Mode Of Payment',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     TextFormField(
//                       controller: _modeOfPaymentController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Mode of payment';
//                         }
//                         return null;
//                       },
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(
//                           vertical: 8,
//                           horizontal: 12,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 3, color: Colors.red),
//                         ),
//                       ),
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     KHeight16,
//                     Text('Sale Date', style: TextStyle(color: Colors.black)),
//                     TextFormField(
//                       controller: _saleDateController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Sale Date';
//                         }
//                         return null;
//                       },

//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(
//                           vertical: 8,
//                           horizontal: 12,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 3, color: Colors.red),
//                         ),
//                       ),
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ],
//                 ),

//               // KHeight16,
//               if (_showSalesForm)
//                 Column(
//                   children: [
//                     KHeight16,

//                     Row(
//                       children: [
//                         SizedBox(width: 90),
//                         ElevatedButton(
//                           onPressed: () {
//                             widget.onCancel?.call();
//                             resetFormFields();
//                           },
//                           child: Text(
//                             'Cancel',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.zero,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 20),

//                         ElevatedButton(
//                           onPressed: () async {
//                             if (!_formKey.currentState!.validate()) {
//                               // stop if any required field is empty
//                               return;
//                             }
//                             // manual deleted like widget.(something vehicleToEdit)changed and all to riverpod
//                             final vehicleToEdit = ref
//                                 .watch(vehicleProvider)
//                                 .vehicleToEdit;

//                             final vehicle = vehicleToEdit ?? widget.vehicle;
//                             if (_status == 'Sold' && vehicle != null) {
//                               final currentVehicle = vehicle;

//                               final salesBox = Hive.box<Sales>('sales');

//                               final newSale = Sales(
//                                 id: Uuid().v4(),
//                                 vehicleId: vehicle.id,
//                                 buyerName: _buyerNameController.text,
//                                 buyerPhone: _buyerPhoneController.text,
//                                 buyerAddress: _buyerAddressController.text,
//                                 modeOfPayment: _modeOfPaymentController.text,
//                                 date: _saleDateController.text,
//                               );

//                               await Hive.box<Sales>(
//                                 'sales',
//                               ).put(newSale.id, newSale);

//                               final updatedVehicle = currentVehicle.copyWith(
//                                 status: 'Sold',
//                                 salesId: newSale.id,
//                               );

//                               // it is hive we change to riverpod
//                               await ref
//                                   .read(vehicleProvider.notifier)
//                                   .updateVehicle(updatedVehicle);

//                               //3 purchase save
//                               final newPurchase = Purchase(
//                                 id: Uuid().v4(),
//                                 vehicleId: currentVehicle.id,
//                                 name: _sellerNameController.text,
//                                 phone: _sellerPhoneController.text,
//                                 address: _sellerAddressController.text,
//                                 date: _purchaseDateController.text,
//                                 price: _priceController.text,
//                                 modeOfPayment: _paymentModeController.text,
//                               );

//                               await Hive.box<Purchase>(
//                                 'purchases',
//                               ).put(newPurchase.id, newPurchase);
//                             }
//                             // Update Vehicle's status and salesId using copyWith

//                             // complete time
//                             if (_status == 'Sold') {
//                               widget.onAddComplete();
//                             }
//                           },

//                           child: Text(
//                             'Update Sale',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.zero,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),

//               if (!_showSalesForm) ...[
//                 KHeight16,

//                 //new code of purchase list
//                 Text('Seller Name', style: TextStyle(color: Colors.black)),
//                 TextFormField(
//                   controller: _sellerNameController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the Seller Name';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                   style: TextStyle(color: Colors.black),
//                 ),

//                 Text('Seller Phone', style: TextStyle(color: Colors.black)),
//                 TextFormField(
//                   controller: _sellerPhoneController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the seller phone';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                   style: TextStyle(color: Colors.black),
//                 ),

//                 Text('Seller Address', style: TextStyle(color: Colors.black)),
//                 TextFormField(
//                   controller: _sellerAddressController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the seller address';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                   style: TextStyle(color: Colors.black),
//                 ),

//                 Text('Mode of Payment', style: TextStyle(color: Colors.black)),
//                 TextFormField(
//                   controller: _paymentModeController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the mode of payment';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                   style: TextStyle(color: Colors.black),
//                 ),

//                 // Description
//                 Text('Description', style: TextStyle(color: Colors.black)),
//                 TextFormField(
//                   controller: _descriptionController,
//                   maxLines: 3, // multi-line for description
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 KHeight16,

//                 // Photos (could be a custom widget or placeholder for now)
//                 Text('Photos', style: TextStyle(color: Colors.black)),

//                 TextFormField(
//                   controller: _imageUrlController,
//                   validator: (value) {
//                     final isNewImagePicked = _pickedImage != null;
//                     final isExistingImageAvailable =
//                         _imageUrlController.text.isNotEmpty;
//                     if (!isNewImagePicked && !isExistingImageAvailable) {
//                       return 'Please insert image';
//                     }

//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     hintText: 'Add photo URL or use file picker',
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 12,
//                     ),
//                     border: OutlineInputBorder(),
//                     suffixIcon: Padding(
//                       padding: const EdgeInsets.only(right: 4),

//                       child: ElevatedButton.icon(
//                         onPressed: _pickImage,
//                         label: Text(
//                           'Add',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.zero,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 if (_pickedImage != null)
//                   Container(
//                     height: 150,
//                     width: double.infinity,
//                     margin: EdgeInsets.only(right: 8),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                     ),
//                     child: Image.file(_pickedImage!, fit: BoxFit.cover),
//                   ),

//                 KHeight,

//                 //partnership listtile can also use
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _showPartnershipFields = !_showPartnershipFields;
//                     });
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.black, width: 1),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.group_add, color: Colors.blue),
//                         SizedBox(width: 10),
//                         Text(
//                           'Add Partnership (Optional)',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black,
//                             // fontWeight: FontWeight.bold
//                           ),
//                         ),
//                         Spacer(),
//                         Icon(
//                           _showPartnershipFields
//                               ? Icons.expand_less
//                               : Icons.expand_more,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 //dropdown of partnership fields
//                 if (_showPartnershipFields)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 10),
//                       _buildTextField(_partnerNameController, 'Partner Name'),
//                       _buildTextField(
//                         _contactPersonController,
//                         'Contact Person',
//                       ),
//                       _buildTextField(_emailController, 'Email'),
//                       _buildTextField(_phoneController, 'Phone'),
//                       _buildTextField(_sharePercentageController, 'Share %'),
//                       Padding(
//                         padding: EdgeInsets.only(top: 4, bottom: 16),
//                         child: InkWell(
//                           onTap: () async {
//                             DateTime? picked = await showDatePicker(
//                               context: context,
//                               initialDate: DateTime.now(),
//                               firstDate: DateTime(2000),
//                               lastDate: DateTime.now(),
//                             );
//                             if (picked != null) {
//                               setState(() {
//                                 _startDate = picked;
//                               });
//                             }
//                           },
//                           child: InputDecorator(
//                             decoration: InputDecoration(
//                               labelText: 'Start Date',
//                               border: OutlineInputBorder(),
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 8,
//                               ),
//                             ),
//                             child: Text(
//                               _startDate != null
//                                   ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
//                                   : 'Select Start Date',
//                               style: TextStyle(color: Colors.black),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                 KHeight,

//                 Row(
//                   children: [
//                     SizedBox(width: 90),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {

//                           print('🟥 Cancel pressed');

//                           ref.read(vehicleProvider.notifier).setVehicleToEdit(null);
//                           // clear all form values
//                           resetFormFields();
//                           // Clear any vehicle being edited
//                           ref
//                               .watch(vehicleProvider.notifier)
//                               .clearVehicleToEdit();
//                           // Hide the add form
//                           ref
//                               .watch(vehicleProvider.notifier)
//                               .setShowAddForm(false);

//                           widget.onCancel
//                               ?.call(); //  Notify parent widget (optional)
//                         },
//                         child: Text(
//                           'Cancel',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.zero,
//                           ),
//                         ),
//                       ),
//                     ),
//                     KWidth12,

//                     Expanded(
//                       child: ElevatedButton(

//                         onPressed: () async {
//                           ref.read(vehicleProvider.notifier).setVehicleToEdit(null);//nnnnnnnnnnnnnnnnnnnnnnn

//                           // Validate the form — if any field is invalid, stop here
//                           if (!_formKey.currentState!.validate()) {
//                             return;
//                           }

//                           // Build a Vehicle object using the values from controllers
//                           final newVehicle = Vehicle(
//                             id: _idController.text,
//                             title:
//                                 '${_makeController.text}${_modelController.text}',
//                             // where gallery adding saving logic
//                             imageUrl: _pickedImage != null
//                                 ? _pickedImage!.path
//                                 : _imageUrlController.text,

//                             year: _yearController.text,
//                             price: _priceController.text,
//                             registrationId: _registrationIdController.text,
//                             color: _colorController.text,
//                             vin: _vinController.text,
//                             description: _descriptionController.text,
//                             purchaseDate: _purchaseDateController.text,

//                             task: '0',
//                             status: _status ?? 'Available',

//                             // If partnership fields are filled, create a Partnership object
//                             partnership: isPartnershipFilled()
//                                 ? Partnership(
//                                     id: _idController.text,
//                                     partnerName: _partnerNameController.text,
//                                     contactPerson:
//                                         _contactPersonController.text,
//                                     email: _emailController.text,
//                                     phone: _phoneController.text,
//                                     sharePercentage:
//                                         _sharePercentageController.text,
//                                     vehicleId: _idController.text,
//                                     startDate: (_startDate ?? DateTime.now())
//                                         .toIso8601String(),
//                                   )
//                                 : null,
//                           );

//                           // check we are editing or adding a new vehicle
//                           final isEditing =
//                               ref.watch(vehicleProvider).vehicleToEdit != null;
//                           print('✏️ vehicleToEdit set to: vehicle id');

//                           // If editing, update the existing vehicle
//                           if (isEditing) {
//                             await ref
//                                 .watch(vehicleProvider.notifier)
//                                 .updateVehicle(newVehicle);
//                             print('Vehicle Updated');
//                           } else {
//                             // otherwise add newvehicle
//                             await ref
//                                 .watch(vehicleProvider.notifier)
//                                 .addVehicle(newVehicle);
//                             print('Vehicle added');
//                           }

//                           //  Save the Partnership in Hive if it exists

//                           if (newVehicle.partnership != null) {
//                             await Hive.box<Partnership>('partnerships').put(
//                               newVehicle.partnership!.id,
//                               newVehicle.partnership!,
//                             );
//                           }

//                           // Build a Purchase object from seller details and save it
//                           final purchase = Purchase(
//                             id: Uuid().v4(),
//                             vehicleId: newVehicle.id,
//                             // vehicleId: (widget.vehicleToEdit ?? widget.vehicle)!.id,
//                             name: _sellerNameController.text,
//                             phone: _sellerPhoneController.text,
//                             address: _sellerAddressController.text,
//                             date: _purchaseDateController.text,
//                             price: _priceController.text,
//                             modeOfPayment: _paymentModeController.text,
//                           );

//                           //Save to Hive
//                           await Hive.box<Purchase>(
//                             'purchases',
//                           ).put(purchase.id, purchase);

//                           //  Clear the editing state
//                           ref
//                               .read(vehicleProvider.notifier)
//                               .clearVehicleToEdit();

//                           //close the form( calls the parent method)
//                           widget.onAddComplete();

//                         },
//                         child: Text(
//                           isEditing ? 'Update Vehicle' : 'Add Vehicle',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.zero,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ], // end of status Sold
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /*
// new code here


import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/models/purchase.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/sales.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:uuid/uuid.dart';

class AddVehicleForm extends ConsumerStatefulWidget {
  final Key? formKey;
  final VoidCallback? onCancel;
  final VoidCallback onAddComplete;
  final Vehicle? vehicleToEdit;
  final Vehicle? vehicle;

  const AddVehicleForm({
    super.key,
    this.formKey,
    this.onCancel,
    required this.onAddComplete,
    this.vehicleToEdit,
    this.vehicle,
  });

  @override
  ConsumerState<AddVehicleForm> createState() => AddVehicleFormState();
}

class AddVehicleFormState extends ConsumerState<AddVehicleForm> {
  // List<File> _pickedImages = [];
  List<String> _pickedImages = [];

  bool _showPartnershipFields = false;
  bool _showSalesForm = false;
  DateTime? _startDate;
  final _formKey = GlobalKey<FormState>();
  bool _formWasReset = false;
  String _status = 'available';
  String?_purchasePaymentStatus = 'pending';

  // Controllers
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _registrationIdController =
      TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _vinController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final TextEditingController _partnerNameController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _sharePercentageController =
      TextEditingController();
  final TextEditingController _sellerNameController = TextEditingController();
  final TextEditingController _sellerPhoneController = TextEditingController();
  final TextEditingController _sellerPurchaseAdressController =
      TextEditingController();
  final TextEditingController _sellerPurchasePriceController =
      TextEditingController();
  final TextEditingController _sellerPurchaseModeController =
      TextEditingController();
  final TextEditingController _sellerAddressController =
      TextEditingController();
  final TextEditingController _paymentModeController = TextEditingController();
  final TextEditingController _buyerNameController = TextEditingController();
  final TextEditingController _buyerPhoneController = TextEditingController();
  final TextEditingController _buyerAddressController = TextEditingController();
  final TextEditingController _modeOfPaymentController =
      TextEditingController();
  final TextEditingController _saleDateController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (pickedFile != null) {
      setState(() {
        _pickedImages.add(pickedFile.path);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  bool isPartnershipFilled() {
    return _partnerNameController.text.trim().isNotEmpty ||
        _contactPersonController.text.trim().isNotEmpty ||
        _emailController.text.trim().isNotEmpty ||
        _phoneController.text.trim().isNotEmpty ||
        _sharePercentageController.text.trim().isNotEmpty ||
        _startDate != null;
  }

  void resetFormFields() {
    setState(() {
      _formKey.currentState?.reset();
      _makeController.clear();
      _modelController.clear();
      _yearController.clear();
      _priceController.clear();
      _registrationIdController.clear();
      _colorController.clear();
      _vinController.clear();
      _descriptionController.clear();
      _purchaseDateController.clear();
      _partnerNameController.clear();
      _contactPersonController.clear();
      _emailController.clear();
      _phoneController.clear();
      _sharePercentageController.clear();
      _sellerNameController.clear();
      _sellerPhoneController.clear();
      _sellerAddressController.clear();
      _paymentModeController.clear();
      _buyerNameController.clear();
      _buyerPhoneController.clear();
      _buyerAddressController.clear();
      _modeOfPaymentController.clear();

      _sellerPurchasePriceController.clear();
      _sellerPurchaseModeController.clear();
      _saleDateController.clear();
      _mileageController.clear();
      _fuelTypeController.clear();
      _pickedImages.clear();
      _status = 'available';
      _showPartnershipFields = false;
      _showSalesForm = false;
      _startDate = null;
    });
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _registrationIdController.dispose();
    _colorController.dispose();
    _vinController.dispose();
    _idController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    _fuelTypeController.dispose();
    _partnerNameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _sharePercentageController.dispose();
    _buyerNameController.dispose();
    _buyerPhoneController.dispose();
    _buyerAddressController.dispose();
    _modeOfPaymentController.dispose();
    _saleDateController.dispose();
    _sellerNameController.dispose();
    _sellerPhoneController.dispose();
    _sellerAddressController.dispose();
    _paymentModeController.dispose();
    _descriptionController.dispose();
    _purchaseDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Generate new ID by default
    final vehicle = widget.vehicleToEdit ?? widget.vehicle;
    if (vehicle != null && vehicle.id.isNotEmpty) {
      _idController.text = vehicle.id; // ✅ Use existing vehicle ID when editing
    } else {
      final uuid = Uuid();
      _idController.text = uuid.v4(); // ✅ Generate new ID when adding
    }

    // resetFormFields(); // now resets while keeping _idController.text set

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vehicle = ref.read(vehicleProvider).vehicleToEdit;
      if (vehicle != null) {
        _makeController.text = vehicle.make;
        _modelController.text = vehicle.model;
        _yearController.text = vehicle.year;
        _priceController.text = vehicle.price;
        _registrationIdController.text = vehicle.registrationId;
        _colorController.text = vehicle.color;
        // _vinController.text = vehicle.vin;
        _status = vehicle.status;
        _mileageController.text = vehicle.mileage.toString();
        _fuelTypeController.text = vehicle.fuelType;

        // Set purchase-related fields
      _sellerNameController.text = vehicle.purchaseName ?? '';
      _sellerPhoneController.text = vehicle.purchasePhone ?? '';
      _sellerAddressController.text = vehicle.purchaseAddress ?? '';
      _sellerPurchaseAdressController.text = vehicle.purchaseAddress ?? '';
      _purchaseDateController.text = vehicle.purchaseDate ?? '';
      _sellerPurchasePriceController.text = vehicle.purchasePrice ?? '';
      _paymentModeController.text = vehicle.purchaseMode ?? '';
      _purchasePaymentStatus = vehicle.purchasePaymentStatus ?? 'pending';
        


        if (vehicle.photos.isNotEmpty) {
          _pickedImages = vehicle.photos.toList();
        }

       

        


        
      }
    });
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.black)),
        SizedBox(height: 4),
        TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildImagePreview(dynamic image) {
    String path;

    if (image is XFile) {
      path = image.path;
    } else if (image is String) {
      path = image;
    } else {
      return const SizedBox(); // fallback
    }

    if (kIsWeb || path.startsWith('http')) {
      return Image.network(path, width: 100, height: 100, fit: BoxFit.cover);
    } else {
      return Image.file(File(path), width: 100, height: 100, fit: BoxFit.cover);
    }
  }

  // In AddVehicleFormState
  // Widget _buildImagePreview(String path) {
  //   if (path.startsWith('http')) {
  //     return Image.network(path, fit: BoxFit.cover);
  //   } else {
  //     return Image.file(
  //       File(path),
  //       fit: BoxFit.cover,
  //     ); // Use File(path) instead of path directly
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final vehicleToEdit = ref.watch(vehicleProvider).vehicleToEdit;
    final isEditing = vehicleToEdit != null;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (!_showSalesForm) ...[
                Text('Vehicle ID', style: TextStyle(color: Colors.black)),
                TextFormField(
                  controller: _idController,
                  readOnly: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                KHeight16,

                Text('Make', style: TextStyle(color: Colors.black)),
                TextFormField(
                  controller: _makeController,
                  style: TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter the make';
                    return null;
                  },
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
                  controller: _modelController,
                  style: TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter the model';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                KHeight16,

                Text('Year', style: TextStyle(color: Colors.black)),
                TextFormField(
                  controller: _yearController,
                  style: TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter the year';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                KHeight16,

                Text('Price', style: TextStyle(color: Colors.black)),
                TextFormField(
                  controller: _priceController,
                  style: TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter the price';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                KHeight16,

                Text(
                  'Registration Number',
                  style: TextStyle(color: Colors.black),
                ),
                TextFormField(
                  controller: _registrationIdController,
                  style: TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter registration';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                KHeight16,

                // Text('VIN', style: TextStyle(color: Colors.black)),
                // TextFormField(
                //   controller: _vinController,
                //   style: TextStyle(color: Colors.black),
                //   validator: (value) {
                //     if (value == null || value.isEmpty)
                //       return 'Please enter the VIN';
                //     return null;
                //   },
                //   decoration: InputDecoration(
                //     contentPadding: EdgeInsets.symmetric(
                //       vertical: 8,
                //       horizontal: 12,
                //     ),
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                // KHeight16,
                Text('Mileage', style: TextStyle(color: Colors.black)),
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: _mileageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter mileage';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                KHeight16,

                Text('Fuel Type', style: TextStyle(color: Colors.black)),
                TextFormField(
                   style: TextStyle(color: Colors.black),
                  controller: _fuelTypeController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Enter fuel type';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                KHeight16,

                Text('Color', style: TextStyle(color: Colors.black)),
                TextFormField(
                  controller: _colorController,
                  style: TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter color';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              KHeight16,

              Text('Status', style: TextStyle(color: Colors.black)),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(border: OutlineInputBorder()),
                items:
                    (vehicleToEdit != null
                            ? [
                                'available',
                                'pending sale',
                                'sold',
                                'in maintenance',
                              ]
                            : ['available', 'pending sale', 'in maintenance'])
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(
                              status[0].toUpperCase() + status.substring(1),
                            ), // Capitalize display
                            // Text(status),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                    _showSalesForm = _status == 'sold';
                  });
                },
              ),

              if (_showSalesForm) ...[
                KHeight16,
                Text('Buyer Name', style: TextStyle(color: Colors.black)),
                TextFormField(
                  controller: _buyerNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Enter buyer name';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.red),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                KHeight16,

                Text('Buyer Phone', style: TextStyle(color: Colors.black)),
                TextFormField(
                  controller: _buyerPhoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Enter buyer phone';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.red),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                KHeight16,

                Text('Buyer Address', style: TextStyle(color: Colors.black)),
                TextFormField(
                  controller: _buyerAddressController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Enter buyer address';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.red),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                KHeight16,

                Text('Mode Of Payment', style: TextStyle(color: Colors.black)),
                TextFormField(
                  controller: _modeOfPaymentController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Enter payment mode';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.red),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                KHeight16,

                Text('Sale Date', style: TextStyle(color: Colors.black)),
                TextFormField(
                  controller: _saleDateController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Enter sale date';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.red),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                KHeight16,

                Row(
                  children: [
                    SizedBox(width: 90),
                    ElevatedButton(
                      onPressed: () {
                        widget.onCancel?.call();
                        resetFormFields();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final vehicle =
                            ref.read(vehicleProvider).vehicleToEdit ??
                            widget.vehicle;
                        if (_status == 'Sold' && vehicle != null) {
                          final newSale = Sales(
                            id: Uuid().v4(),
                            vehicleId: vehicle.id,
                            buyerName: _buyerNameController.text,
                            buyerPhone: _buyerPhoneController.text,
                            buyerAddress: _buyerAddressController.text,
                            modeOfPayment: _modeOfPaymentController.text,
                            date: _saleDateController.text,
                          );

                          await Hive.box<Sales>(
                            'sales',
                          ).put(newSale.id, newSale);

                          final updatedVehicle = vehicle.copyWith(
                            status: 'Sold',
                            salesId: newSale.id,
                          );

                          await ref
                              .read(vehicleProvider.notifier)
                              .updateVehicle(updatedVehicle);

                          final newPurchase = Purchase(
                            id: Uuid().v4(),
                            vehicleId: vehicle.id,
                            name: _sellerNameController.text,
                            phone: _sellerPhoneController.text,
                            address: _sellerAddressController.text,
                            date: _purchaseDateController.text,
                            price: _priceController.text,
                            modeOfPayment: _paymentModeController.text,
                          );

                          await Hive.box<Purchase>(
                            'purchases',
                          ).put(newPurchase.id, newPurchase);
                        }

                        if (_status == 'Sold') {
                          widget.onAddComplete();
                        }
                      },
                      child: Text(
                        'Update Sale',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              if (!_showSalesForm) ...[
                KHeight16,
                Text('Seller Name', style: TextStyle(color: Colors.black)),
                TextFormField(
                  controller: _sellerNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Enter seller name';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                KHeight16,

                Text('Seller Phone', style: TextStyle(color: Colors.black)),
                TextFormField(
                  controller: _sellerPhoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Enter seller phone';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                KHeight16,

                Text('Seller Address', style: TextStyle(color: Colors.black)),
                TextFormField(
                  controller: _sellerAddressController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Enter seller address';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                KHeight16,

                Text('Mode of Payment', style: TextStyle(color: Colors.black)),
                TextFormField(
                  controller: _paymentModeController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Enter payment mode';
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                KHeight16,

                Text('Payment Status', style: TextStyle(color: Colors.black)),
                DropdownButtonFormField<String>(
                  value: _purchasePaymentStatus,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12
                    ),
                    border: OutlineInputBorder(),
                  ),
                  items: ['paid','partial','pending'].map((status){
                    return DropdownMenuItem<String>(
                      value: status,
                      child:Text(
                        status[0].toUpperCase()+status.substring(1),
                      ),
                       );
                  }).toList(),
                   onChanged: (String? newValue){
                    setState(() {
                      _purchasePaymentStatus=newValue;
                    });
                   },
                   validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please select payment status';
    }
    return null;
  },
                   ),
                   KHeight16,

                   // Replace the purchase date TextFormField with this:
InkWell(
  onTap: () async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      _purchaseDateController.text = 
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2,'0')}-${pickedDate.day.toString().padLeft(2,'0')}";
    }
  },
  child: InputDecorator(
    decoration: InputDecoration(
      labelText: 'Purchase Date',
      border: OutlineInputBorder(),
    ),
    child: Text(
      _purchaseDateController.text.isEmpty
        ? 'Select Purchase Date'
        : _purchaseDateController.text,
    ),
  ),
),

                

                Text('Description', style: TextStyle(color: Colors.black)),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                KHeight16,

                Text('Photos', style: TextStyle(color: Colors.black)),
                Column(
                  children: [
                    Wrap(
                      spacing: 8,
                      children: _pickedImages.asMap().entries.map((entry) {
                        return Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _buildImagePreview(entry.value),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.close, size: 20),
                                onPressed: () => _removeImage(entry.key),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Add Photo'),
                    ),
                    if (_pickedImages.isEmpty)
                      Text(
                        'At least one photo is required',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
                KHeight,

                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPartnershipFields = !_showPartnershipFields;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.group_add, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(
                          'Add Partnership (Optional)',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Spacer(),
                        Icon(
                          _showPartnershipFields
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                      ],
                    ),
                  ),
                ),

                if (_showPartnershipFields) ...[
                  SizedBox(height: 10),
                  _buildTextField(_partnerNameController, 'Partner Name'),
                  _buildTextField(_contactPersonController, 'Contact Person'),
                  _buildTextField(_emailController, 'Email'),
                  _buildTextField(_phoneController, 'Phone'),
                  _buildTextField(_sharePercentageController, 'Share %'),
                  Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 16),
                    child: 
                    // InkWell(
                    //   onTap: () async {
                    //     DateTime? picked = await showDatePicker(
                    //       context: context,
                    //       initialDate: DateTime.now(),
                    //       firstDate: DateTime(2000),
                    //       lastDate: DateTime.now(),
                    //     );
                    //     if (picked != null) {
                    //       setState(() {
                    //         _startDate = picked;
                    //       });
                    //     }
                    //   },
                    //   child: InputDecorator(
                    //     decoration: InputDecoration(
                    //       labelText: 'Start Date',
                    //       border: OutlineInputBorder(),
                    //       contentPadding: EdgeInsets.symmetric(
                    //         horizontal: 12,
                    //         vertical: 8,
                    //       ),
                    //     ),
                    //     child: Text(
                    //       _startDate != null
                    //           ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                    //           : 'Select Start Date',
                    //       style: TextStyle(
                    //         color: Colors.black,
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w500,
                    //         ),
                    //     ),
                    //   ),
                    // ),

                    InkWell(
  onTap: () async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _purchaseDateController.text = 
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2,'0')}-${pickedDate.day.toString().padLeft(2,'0')}";
      });
    }
  },
  child: InputDecorator(
    decoration: InputDecoration(
      labelText: 'Purchase Date',
      border: OutlineInputBorder(),
      labelStyle: TextStyle(color: Colors.black), // Add this
    ),
    child: Text(
      _purchaseDateController.text.isEmpty
        ? 'Select Purchase Date'
        : _purchaseDateController.text,
      style: TextStyle(color: Colors.black), // Add this for black text
    ),
  ),
),
                  ),
                ],
                KHeight,

                Row(
                  children: [
                    SizedBox(width: 90),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ref
                              .read(vehicleProvider.notifier)
                              .setVehicleToEdit(null);
                          resetFormFields();
                          ref
                              .read(vehicleProvider.notifier)
                              .clearVehicleToEdit();
                          ref
                              .read(vehicleProvider.notifier)
                              .setShowAddForm(false);
                          widget.onCancel?.call();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                    ),
                    KWidth12,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (!mounted) return; //new line added at 13

                            try {
                              // Reset vehicleToEdit so form starts fresh next time
                              ref
                                  .read(vehicleProvider.notifier)
                                  .setVehicleToEdit(null);

                              // Validate form before saving
                              // if (!_formKey.currentState!.validate()) return;

                              // Create new vehicle object from form data
                              final newVehicle = Vehicle(
                                id: _idController.text,
                                make: _makeController.text,
                                model: _modelController.text,
                                photos: _pickedImages.toList(),
                                mileage:
                                    double.tryParse(_mileageController.text) ??
                                    0.0,
                                fuelType: _fuelTypeController.text,
                                year: _yearController.text,
                                price: _priceController.text,
                                registrationId: _registrationIdController.text,
                                color: _colorController.text,
                                // vin: _vinController.text,
                                description: _descriptionController.text,
                                purchaseDate: _purchaseDateController.text,
                                // task: '0',
                                purchaseName: _sellerNameController.text,
                                purchasePhone: _sellerPhoneController.text,
                                purchaseAddress: _sellerAddressController.text,
                                purchasePaymentStatus: _purchasePaymentStatus??'pending',
                                purchasePrice: _priceController.text,
                                purchaseMode: _paymentModeController.text.toLowerCase(),
                                status: _status.toLowerCase(),
                                partnership: isPartnershipFilled()
                                    ? Partnership(
                                        id: _idController.text,
                                        partnerName:
                                            _partnerNameController.text,
                                        contactPerson:
                                            _contactPersonController.text,
                                        email: _emailController.text,
                                        phone: _phoneController.text,
                                        sharePercentage:
                                            _sharePercentageController.text,
                                        vehicleId: _idController.text,
                                        startDate:
                                            (_startDate ?? DateTime.now())
                                                .toIso8601String(),
                                      )
                                    : null,
                              );
                              // Add or update vehicle
                              if (isEditing) {
                                await ref
                                    .read(vehicleProvider.notifier)
                                    .updateVehicle(newVehicle);
                              } else {
                                await ref
                                    .read(vehicleProvider.notifier)
                                    .addVehicle(newVehicle);
                              }

                              // Save partnership if it exists
                              if (newVehicle.partnership != null) {
                                final partnershipBox = Hive.box<Partnership>(
                                  'partnerships',
                                );
                                await partnershipBox.put(
                                  newVehicle.partnership!.id,
                                  newVehicle.partnership!,
                                );
                                // await Hive.box<Partnership>('partnerships')
                                //     .put(newVehicle.partnership!.id, newVehicle.partnership!);
                              }

                              // // Create and save purchase details
                              // final purchase = Purchase(
                              //   id: Uuid().v4(),
                              //   vehicleId: newVehicle.id,
                              //   name: _sellerNameController.text,
                              //   phone: _sellerPhoneController.text,
                              //   address: _sellerAddressController.text,
                              //   date: _purchaseDateController.text,
                              //   price: _priceController.text,
                              //   modeOfPayment: _paymentModeController.text,
                              // );

                              // await Hive.box<Purchase>(
                              //   'purchases',
                              // ).put(purchase.id, purchase);

                              // Clear form and notify parent widget
                              ref
                                  .read(vehicleProvider.notifier)
                                  .clearVehicleToEdit();
                              widget.onAddComplete();
                            } catch (e) {
                              // If something goes wrong, show error
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          isEditing ? 'Update Vehicle' : 'Add Vehicle',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
