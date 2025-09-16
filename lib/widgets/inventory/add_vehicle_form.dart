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
import 'package:my_new_project/widgets/partnerships/add_partner_form.dart';
import 'package:my_new_project/widgets/partnerships/add_partnership_details.dart';
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

  final List<String> _paymentModes = ['cash', 'card', 'cheque', 'finance'];
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

       _sellerNameController.text = vehicle.purchaseInfo.name;
_sellerPhoneController.text = vehicle.purchaseInfo.phone;
_sellerAddressController.text = vehicle.purchaseInfo.address;
_sellerPurchaseAdressController.text = vehicle.purchaseInfo.address;
_purchaseDateController.text = vehicle.purchaseInfo.date.toIso8601String().split('T').first;
_sellerPurchasePriceController.text = vehicle.purchaseInfo.price.toString();
_selectedPaymentMode = vehicle.purchaseInfo.modeOfPayment;
_purchasePaymentStatus = vehicle.purchaseInfo.paymentStatus;

        if (vehicle.photos.isNotEmpty && !_formWasReset) {
          setState(() {
            _pickedImages = List<String>.from(vehicle.photos);
            _formWasReset = true; // ensures prefill happens only once
          });
        }

        if (vehicle.partnerships != null) {
          _partnerships = vehicle.partnerships!; // wrap in a list
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

  bool _isPartnershipEnabled = false;

  List<Partnership> _partnerships = [];

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
                  items: ['petrol', 'diesel', 'hybrid', 'electric']
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
                        if (value == null || value.isEmpty)
                          return 'Please enter the price';
                        return null;
                      },
                      decoration: kCommonInputDecoration.copyWith(
                        hintText: "Expected selling price",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
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
                                  child: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.white,
                                  ),
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          suffixIcon: Icon(
                            Icons.upload_file,
                            color: Colors.grey,
                          ),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),

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

                  Text("Purchase Price", style: TextStyle(color: Colors.black)),
                  TextFormField(
                    controller: _sellerPurchasePriceController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter purchase price';
                      return null;
                    },
                    decoration: kCommonInputDecoration.copyWith(
                      hintText: "Purchase Price",
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
                        print(
                          "Selected Payment Mode: $_selectedPaymentMode",
                        ); // 👈 Add this
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
















                  SwitchListTile(
                    title: Text(
                      "Enable Partnership",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    value: _isPartnershipEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isPartnershipEnabled = value;
                      });
                    },
                  ),

                  if (_isPartnershipEnabled)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Partners",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          KHeight16,

                          if (_partnerships.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text("No partners have been added yet."),
                            )
                          else
                            Column(
                              children: _partnerships.map((partnership) {
                                return Container(
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "${partnership.partnerName}: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "Contribution ₹${partnership.contribution}",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _partnerships.remove(partnership);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),

                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                final selectedPartnership =
                                    await showModalBottomSheet<Partnership>(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (context) => Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(
                                            context,
                                          ).viewInsets.bottom,
                                        ),
                                        child: AddPartnershipDetails(
                                          vehicleId:_idController.text ,
                                        ),
                                      ),
                                    );

                                if (selectedPartnership != null) {
                                  setState(() {
                                    _partnerships.add(selectedPartnership);
                                  });
                                }
                              },

                              child: Text("Add Partner"), //partnership details
                            ),
                          ),
                        ],
                      ),
                    ),
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

                                Partnership? selectedPartner;

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




                                  // purchaseDate: _purchaseDateController.text,
                                  // // task: '0',
                                  // purchaseName: _sellerNameController.text,
                                  // purchasePhone: _sellerPhoneController.text,
                                  // purchaseAddress:
                                  //     _sellerAddressController.text,
                                  // purchasePaymentStatus:
                                  //     _purchasePaymentStatus ?? 'pending',
                                  // purchasePrice: _priceController.text,
                                  // purchaseMode:
                                  //     _selectedPaymentMode?.toLowerCase() ?? '',
                                  // ✅ NEW: purchaseInfo object
  purchaseInfo: Purchase(
    id: '', // Leave empty if it's a new purchase
    vehicleId: _idController.text,
    userId: '', // Set current user ID here if available
    name: _sellerNameController.text,
    phone: _sellerPhoneController.text,
    address: _sellerAddressController.text,
    date: DateTime.tryParse(_purchaseDateController.text) ?? DateTime.now(),
    price: double.tryParse(_priceController.text.replaceAll(',', '')) ?? 0.0,
    modeOfPayment: _selectedPaymentMode?.toLowerCase() ?? '',
    paymentStatus: _purchasePaymentStatus ?? 'pending',
  ),






                                  status: _status.toLowerCase(),

                                  partnerships: _isPartnershipEnabled
                                      ? _partnerships
                                      : [],




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
