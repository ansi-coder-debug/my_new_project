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
import 'package:cached_network_image/cached_network_image.dart';

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
  String? _purchasePaymentStatus = 'pending';

  
final List<String> _paymentModes = ['Cash', 'Card', 'Cheque', 'Finance'];
  String? _selectedPaymentMode;


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

        if (vehicle.photos.isNotEmpty && !_formWasReset) {
          setState(() {
            _pickedImages = List<String>.from(vehicle.photos);
            _formWasReset = true; // ensures prefill happens only once
          });
        }
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final vehicleToEdit = ref.watch(vehicleProvider).vehicleToEdit;
    final isEditing = vehicleToEdit != null;

    return Scaffold(
      // backgroundColor: Colors.grey.shade200,// background outside container
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                if (!_showSalesForm) ...[
                  // ✅ Back Arrow + View Report Row
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Back Arrow Button (first row, only arrow)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: widget.onCancel,
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                      KHeight,
                      // 🔹 Row with "Add New Vehicle" and "View Report"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add New Vehicle",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onCancel,
                            child: Text(
                              "View Report",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      KHeight16,
                      // 🔹 Section Title with Underline
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Vehicle Details",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Divider(thickness: 1, color: Colors.black),
                        ],
                      ),
                    ],
                  ),
                  KHeight30,

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
                    decoration: kCommonInputDecoration.copyWith(
                      hintText: "Select Make ",
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
                    decoration: kCommonInputDecoration.copyWith(
                      hintText: "Select Model ",
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
                    decoration: kCommonInputDecoration.copyWith(
                      hintText: "Year(e.g.2022) ",
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
                    decoration: kCommonInputDecoration.copyWith(
                      hintText: "color ",
                    ),
                  ),
                ],
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
                  decoration: kCommonInputDecoration.copyWith(
                    hintText: "registration no ",
                  ),
                ),
                KHeight16,

                Text('Mileage', style: TextStyle(color: Colors.black)),
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: _mileageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter mileage';
                    return null;
                  },
                  decoration: kCommonInputDecoration.copyWith(
                    hintText: "mileage(in Km) ",
                  ),
                ),
                KHeight16,

                Text('Fuel Type', style: TextStyle(color: Colors.black)),
                DropdownButtonFormField<String>(
                  value: _fuelTypeController.text.isNotEmpty
                      ? _fuelTypeController.text
                      : null,
                  items: ['Petrol', 'Diesel', 'Hybrid', 'Electric']
                      .map(
                        (fuel) => DropdownMenuItem(
                          value: fuel,
                          child: Text(
                            fuel,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _fuelTypeController.text =
                          value; // keep using same controller for saving
                    }
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Select fuel type'
                      : null,
                  decoration: kCommonInputDecoration.copyWith(
                    hintText: "Select Fuel Type",
                  ),
                ),
                KHeight16,

                // Text('Price', style: TextStyle(color: Colors.black)),
                // TextFormField(
                //   controller: _priceController,
                //   style: TextStyle(color: Colors.black),
                //   validator: (value) {
                //     if (value == null || value.isEmpty)
                //       return 'Please enter the price';
                //     return null;
                //   },
                //   decoration: kCommonInputDecoration.copyWith(
                //     hintText: "Expected selling price ",
                //   ),
                // ),
                // KHeight16,

               Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Price Section
    Text(
      'Price',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    SizedBox(height: 8),
    TextFormField(
      controller: _priceController,
      style: TextStyle(color: Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter the price';
        return null;
      },
      decoration: kCommonInputDecoration.copyWith(
        hintText: "Expected selling price",
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
    ),
    SizedBox(height: 20),
































    // Photos Section
    Text(
      'Photos',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    SizedBox(height: 8),
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _pickedImages.asMap().entries.map((entry) {
        return Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildImagePreview(entry.value),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _removeImage(entry.key),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    ),
    SizedBox(height: 12),
    InkWell(
      onTap: _pickImage,
      child: InputDecorator(
        decoration: kCommonInputDecoration.copyWith(
          hintText: "Choose files",
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          suffixIcon: Icon(Icons.upload_file, color: Colors.grey),
        ),
        child: const Text(
          "Choose Files",
          style: TextStyle(color: Colors.black54),
        ),
      ),
    ),
    SizedBox(height: 20),

    // Additional Notes
    Text(
      'Additional Notes',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    SizedBox(height: 8),
    TextFormField(
      controller: _descriptionController,
      // maxLines: 3,
      style: TextStyle(color: Colors.black),
      decoration: kCommonInputDecoration.copyWith(
        hintText: "Additional notes",
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    ),
    SizedBox(height: 20),
  ],
),





























                // if (_showSalesForm) ...[
                //   KHeight16,
                //   Text('Buyer Name', style: TextStyle(color: Colors.black)),
                //   TextFormField(
                //     controller: _buyerNameController,
                //     validator: (value) {
                //       if (value == null || value.isEmpty)
                //         return 'Enter buyer name';
                //       return null;
                //     },
                //     decoration: kCommonInputDecoration.copyWith(
                //       hintText: "buyer name ",
                //     ),
                //     style: TextStyle(color: Colors.black),
                //   ),
                //   KHeight16,

                //   Text('Buyer Phone', style: TextStyle(color: Colors.black)),
                //   TextFormField(
                //     controller: _buyerPhoneController,
                //     validator: (value) {
                //       if (value == null || value.isEmpty)
                //         return 'Enter buyer phone';
                //       return null;
                //     },
                //     decoration: kCommonInputDecoration.copyWith(
                //       hintText: "buyer phone ",
                //     ),
                //     style: TextStyle(color: Colors.black),
                //   ),
                //   KHeight16,

                //   Text('Buyer Address', style: TextStyle(color: Colors.black)),
                //   TextFormField(
                //     controller: _buyerAddressController,
                //     validator: (value) {
                //       if (value == null || value.isEmpty)
                //         return 'Enter buyer address';
                //       return null;
                //     },
                //     decoration: kCommonInputDecoration.copyWith(
                //       hintText: "buyer address ",
                //     ),
                //     style: TextStyle(color: Colors.black),
                //   ),
                //   KHeight16,

                //   Text(
                //     'Mode Of Payment',
                //     style: TextStyle(color: Colors.black),
                //   ),
                //   TextFormField(
                //     controller: _modeOfPaymentController,
                //     validator: (value) {
                //       if (value == null || value.isEmpty)
                //         return 'Enter payment mode';
                //       return null;
                //     },
                //     decoration: kCommonInputDecoration.copyWith(
                //       hintText: "mode of payment ",
                //     ),
                //     style: TextStyle(color: Colors.black),
                //   ),
                //   KHeight16,

                //   Text('Sale Date', style: TextStyle(color: Colors.black)),
                //   TextFormField(
                //     controller: _saleDateController,
                //     validator: (value) {
                //       if (value == null || value.isEmpty)
                //         return 'Enter sale date';
                //       return null;
                //     },
                //     decoration: InputDecoration(
                //       contentPadding: EdgeInsets.symmetric(
                //         vertical: 8,
                //         horizontal: 12,
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: BorderSide(width: 3, color: Colors.red),
                //       ),
                //     ),
                //     style: TextStyle(color: Colors.black),
                //   ),
                //   KHeight16,

                //   Row(
                //     children: [
                //       SizedBox(width: 90),
                //       ElevatedButton(
                //         onPressed: () {
                //           widget.onCancel?.call();
                //           resetFormFields();
                //         },
                //         child: Text(
                //           'Cancel',
                //           style: TextStyle(color: Colors.black),
                //         ),
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.white,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.zero,
                //           ),
                //         ),
                //       ),
                //       SizedBox(width: 20),
                //       ElevatedButton(
                //         onPressed: () async {
                //           if (!_formKey.currentState!.validate()) return;

                //           final vehicle =
                //               ref.read(vehicleProvider).vehicleToEdit ??
                //               widget.vehicle;
                //           if (_status == 'Sold' && vehicle != null) {
                //             final newSale = Sales(
                //               id: Uuid().v4(),
                //               vehicleId: vehicle.id,
                //               buyerName: _buyerNameController.text,
                //               buyerPhone: _buyerPhoneController.text,
                //               buyerAddress: _buyerAddressController.text,
                //               modeOfPayment: _modeOfPaymentController.text,
                //               date: _saleDateController.text,
                //             );

                //             await Hive.box<Sales>(
                //               'sales',
                //             ).put(newSale.id, newSale);

                //             final updatedVehicle = vehicle.copyWith(
                //               status: 'Sold',
                //               salesId: newSale.id,
                //             );

                //             await ref
                //                 .read(vehicleProvider.notifier)
                //                 .updateVehicle(updatedVehicle);

                //             final newPurchase = Purchase(
                //               id: Uuid().v4(),
                //               vehicleId: vehicle.id,
                //               userId:
                //                   "current_user_id", // Get from your auth system
                //               name: _sellerNameController.text,
                //               phone: _sellerPhoneController.text,
                //               address: _sellerAddressController.text,
                //               date: DateTime.parse(
                //                 _purchaseDateController.text,
                //               ),
                //               price: double.parse(_priceController.text),
                //               modeOfPayment: _paymentModeController.text,
                //               paymentStatus:
                //                   _purchasePaymentStatus ?? 'pending',
                //             );

                //             await Hive.box<Purchase>(
                //               'purchases',
                //             ).put(newPurchase.id, newPurchase);
                //           }

                //           if (_status == 'Sold') {
                //             widget.onAddComplete();
                //           }
                //         },
                //         child: Text(
                //           'Update Sale',
                //           style: TextStyle(color: Colors.white),
                //         ),
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.blue,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.zero,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ],

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Purchase Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Divider(thickness: 1, color: Colors.black),
                  ],
                ),
                KHeight30,

                if (!_showSalesForm) ...[
                  Text('Seller Name', style: TextStyle(color: Colors.black)),
                  TextFormField(
                    controller: _sellerNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter seller name';
                      return null;
                    },
                    decoration: kCommonInputDecoration.copyWith(
                      hintText: "seller name ",
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                 KHeight20,

                  Text('Seller Phone', style: TextStyle(color: Colors.black)),
                  TextFormField(
                    controller: _sellerPhoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter seller phone';
                      return null;
                    },
                    decoration: kCommonInputDecoration.copyWith(
                      hintText: "seller phone",
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  KHeight20,

                  Text('Seller Address', style: TextStyle(color: Colors.black)),
                  TextFormField(
                    controller: _sellerAddressController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter seller address';
                      return null;
                    },
                    decoration: kCommonInputDecoration.copyWith(
                      hintText: "seller address",
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                KHeight20,




                  Text("Purchase Price",style: TextStyle(color: Colors.black),),
                  TextFormField(
                    controller: _sellerPurchasePriceController,
                    validator: (value) {
                      if(value == null || value.isEmpty)
                      return 'Enter purchase price';
                      return null;
                    },
                    decoration: kCommonInputDecoration.copyWith(
                      hintText: "Purchase Price"
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  KHeight20,

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
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
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
                  KHeight20,






                 

                  Text(
                    'Purchase Payment Mode',
                    style: TextStyle(color: Colors.black),
                  ),
                  DropdownButtonFormField<String>(
                    
                    value: _selectedPaymentMode,
                    decoration: kCommonInputDecoration.copyWith(
                      hintText: "Select Payment Mode",
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                    style: TextStyle(color: Colors.black),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Select a payment mode'
                        : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPaymentMode = newValue;
                         print("Selected Payment Mode: $_selectedPaymentMode"); // 👈 Add this
                      });
                    },
                    items: _paymentModes.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                 KHeight20,

                  Text('Payment Status', style: TextStyle(color: Colors.black)),
                  DropdownButtonFormField<String>(
                    value: _purchasePaymentStatus,
                    decoration: kCommonInputDecoration.copyWith(
                      hintText: "payment status",
                    ),
                    items: ['paid', 'partial', 'pending'].map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(
                          status[0].toUpperCase() + status.substring(1),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _purchasePaymentStatus = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select payment status';
                      }
                      return null;
                    },
                  ),
                KHeight20,

                

                

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
                    buildTextField(_partnerNameController, 'Partner Name'),
                    buildTextField(_contactPersonController, 'Contact Person'),
                    buildTextField(_emailController, 'Email'),
                    buildTextField(_phoneController, 'Phone'),
                    buildTextField(_sharePercentageController, 'Share %'),
                    Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 16),
                      child: InkWell(
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
                                  "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Purchase Date',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ), // Add this
                          ),
                          child: Text(
                            _purchaseDateController.text.isEmpty
                                ? 'Select Purchase Date'
                                : _purchaseDateController.text,
                            style: TextStyle(
                              color: Colors.black,
                            ), // Add this for black text
                          ),
                        ),
                      ),
                    ),
                  ],
                 KHeight20,

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

                                // Create new vehicle object from form data
                                final newVehicle = Vehicle(
                                  id: _idController.text,
                                  make: _makeController.text,
                                  model: _modelController.text,
                                  photos: _pickedImages.toList(),

                                  mileage:
                                      double.tryParse(
                                        _mileageController.text,
                                      ) ??
                                      0.0,
                                  fuelType: _fuelTypeController.text,
                                  year: _yearController.text,
                                  price: _priceController.text,
                                  registrationId:
                                      _registrationIdController.text,
                                  color: _colorController.text,
                                  // vin: _vinController.text,
                                  description: _descriptionController.text,
                                  purchaseDate: _purchaseDateController.text,
                                  // task: '0',
                                  purchaseName: _sellerNameController.text,
                                  purchasePhone: _sellerPhoneController.text,
                                  purchaseAddress:
                                      _sellerAddressController.text,
                                  purchasePaymentStatus:
                                      _purchasePaymentStatus ?? 'pending',
                                  purchasePrice: _priceController.text,
                                  purchaseMode: _selectedPaymentMode?.toLowerCase()??'',
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
                                }

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
      ),
    );
  }
}
