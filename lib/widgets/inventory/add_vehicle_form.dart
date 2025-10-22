
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/application/auth/auth_provider.dart';

import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/core/models/purchase.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:my_new_project/core/constants/constant.dart'; // We'll replace/augment this

import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/sales.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/widgets/partnerships/add_partner_form.dart'; // Assuming this exists
import 'package:my_new_project/widgets/partnerships/add_partnership_details.dart'; // Assuming this exists
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:uuid/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Ensure CustomHeader is imported if it's in a separate file
// import 'package:my_new_project/widgets/reusable/custom_header.dart'; // If you moved it

class AddVehicleForm extends ConsumerStatefulWidget {
  final Key? formKey;
  final VoidCallback? onCancel; // This was "View Report" in your original code, which we'll remove
  final VoidCallback onAddComplete;
  final Vehicle? vehicleToEdit;
  final Vehicle? vehicle; // Duplicate? vehicleToEdit should be sufficient

  const AddVehicleForm({
    super.key,
    this.formKey,
    this.onCancel, // This will no longer be "View Report" based on new design
    required this.onAddComplete,
    this.vehicleToEdit,
    this.vehicle, // Keep consistent with existing logic if needed
  });

  @override
  ConsumerState<AddVehicleForm> createState() => AddVehicleFormState();
}

class AddVehicleFormState extends ConsumerState<AddVehicleForm> {
  List<String> _pickedImages = []; // Stores paths of picked images
  bool _isPartnershipEnabled = false;
  List<Partnership> _partnerships = [];
  Account? _selectedAccount; // For "From Account" dropdown

  // State for form fields
  final _formKey = GlobalKey<FormState>();
  String _vehicleType = 'Bike'; // Default for the dropdown in Vehicle Details
  String _fuelType = 'Petrol'; // Default for the dropdown in Vehicle Details
  DateTime? _purchaseDate; // For the purchase date picker

  // Controllers (your existing ones are fine, just make sure they're used correctly)
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _registrationIdController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _expectedSellingAmountController = TextEditingController(); // NEW: For expected selling price
  final TextEditingController _additionalNotesController = TextEditingController(); // NEW: For additional notes

  final TextEditingController _sellerNameController = TextEditingController();
  final TextEditingController _sellerPhoneController = TextEditingController();
  final TextEditingController _sellerAddressController = TextEditingController();
  final TextEditingController _purchaseAmountController = TextEditingController();
  final TextEditingController _purchasePaidAmountController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController(); // For displaying the date
  final TextEditingController _statusController = TextEditingController();


  @override
  void initState() {
    super.initState();
    final vehicle = widget.vehicleToEdit ?? widget.vehicle;
    if (vehicle != null) {
      // Prefill for editing
      _makeController.text = vehicle.make;
      _modelController.text = vehicle.model;
      _yearController.text = vehicle.year;
      _colorController.text = vehicle.color;
      _registrationIdController.text = vehicle.registrationId;
      _mileageController.text = vehicle.mileage.toString();
      _fuelType = vehicle.fuelType; // Set dropdown value
      _expectedSellingAmountController.text = vehicle.price; // Assuming vehicle.price is expected selling
      _additionalNotesController.text = vehicle.description.toString(); // Assuming vehicle.description is additional notes

      _sellerNameController.text = vehicle.purchaseInfo.name;
      _sellerPhoneController.text = vehicle.purchaseInfo.phone;
      _sellerAddressController.text = vehicle.purchaseInfo.address;
      _purchaseAmountController.text = vehicle.purchaseInfo.price.toString();
      _purchasePaidAmountController.text = vehicle.purchaseInfo.paidAmount.toString();
      _purchaseDate = vehicle.purchaseInfo.date;
      _purchaseDateController.text = _purchaseDate != null
          ? "${_purchaseDate!.month.toString().padLeft(2, '0')}/${_purchaseDate!.day.toString().padLeft(2, '0')}/${_purchaseDate!.year}"
          : '';

      if (vehicle.photos.isNotEmpty) {
        _pickedImages = List<String>.from(vehicle.photos);
      }
      _isPartnershipEnabled = vehicle.partnerships?.isNotEmpty ?? false;
      _partnerships = vehicle.partnerships ?? [];

      // Set _selectedAccount if it exists
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final accountState = ref.read(accountProvider);
        if (vehicle.purchaseInfo.modeOfPayment.isNotEmpty) {
          try {
            _selectedAccount = accountState.accounts.firstWhere(
              (acc) => acc.id == vehicle.purchaseInfo.modeOfPayment,
            );
          } catch (e) {
            debugPrint('⚠️ From Account not found for ID: ${vehicle.purchaseInfo.modeOfPayment}');
          }
        }
        setState(() {}); // Trigger rebuild to show selected account
      });

    } else {
      // Default for new vehicle
      _purchaseDate = DateTime.now();
      _purchaseDateController.text =
          "${_purchaseDate!.month.toString().padLeft(2, '0')}/${_purchaseDate!.day.toString().padLeft(2, '0')}/${_purchaseDate!.year}";
    }
  }


  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _registrationIdController.dispose();
    _mileageController.dispose();
    _expectedSellingAmountController.dispose();
    _additionalNotesController.dispose();
    _sellerNameController.dispose();
    _sellerPhoneController.dispose();
    _sellerAddressController.dispose();
    _purchaseAmountController.dispose();
    _purchasePaidAmountController.dispose();
    _purchaseDateController.dispose();
    super.dispose();
  }

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

  Widget _buildImagePreview(String imagePath) {
    if (kIsWeb || imagePath.startsWith('http')) {
      return CachedNetworkImage( // Use CachedNetworkImage for network images
        imageUrl: imagePath,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      return Image.file(File(imagePath), width: 100, height: 100, fit: BoxFit.cover);
    }
  }


  // Helper function to show date picker and update controller
  Future<void> _selectDate(BuildContext context, TextEditingController controller, Function(DateTime?) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryBlue, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: kDarkText, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kPrimaryBlue, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedDate = "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      controller.text = formattedDate;
      onDateSelected(picked);
    }
  }


  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountProvider);
    final isEditing = widget.vehicleToEdit != null; // Simpler way to check editing mode

    return Scaffold(
      backgroundColor: kLightGreyBackground, // Global background color
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            CustomHeader(
              title: "Add Vehicle",
              onBack: () {
                Navigator.of(context).pop();
              },
            ),

            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0), // Padding for the whole form
                  children: [
                    // --- Vehicle Details Section ---
                    const Text(
                      "Vehicle Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kDarkText,
                      ),
                    ),
                    const Divider(thickness: 1, color: kInputBorderColor), // Subtle divider
                    KHeight20,

                    // Vehicle Type Dropdown
                    DropdownButtonFormField<String>(
                      value: _vehicleType,
                      decoration: kInputDecoration.copyWith(hintText: "Bike"), // Changed hint to match default value
                      items: ['Bike', 'Car', 'Truck', 'Other'] // Example vehicle types
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type, style: const TextStyle(color: kDarkText)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _vehicleType = value!;
                        });
                      },
                      style: const TextStyle(color: kDarkText, fontSize: 15),
                      dropdownColor: Colors.white,
                    ),
                    KHeight16,

                    // Select Make
                    TextFormField(
                      controller: _makeController,
                      decoration: kInputDecoration.copyWith(hintText: "Select Make"),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter make' : null,
                      style: const TextStyle(color: kDarkText),
                    ),
                    KHeight16,

                    // Select Model
                    TextFormField(
                      controller: _modelController,
                      decoration: kInputDecoration.copyWith(hintText: "Select Model"),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter model' : null,
                      style: const TextStyle(color: kDarkText),
                    ),
                    KHeight16,

                    // Year
                    TextFormField(
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      decoration: kInputDecoration.copyWith(hintText: "Year (e.g., 2022)"),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter year' : null,
                      style: const TextStyle(color: kDarkText),
                    ),
                    KHeight16,

                    // Color
                    TextFormField(
                      controller: _colorController,
                      decoration: kInputDecoration.copyWith(hintText: "Color"),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter color' : null,
                      style: const TextStyle(color: kDarkText),
                    ),
                    KHeight16,

                    // Registration No.
                    TextFormField(
                      controller: _registrationIdController,
                      decoration: kInputDecoration.copyWith(hintText: "Registration No."),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter registration number' : null,
                      style: const TextStyle(color: kDarkText),
                    ),
                    KHeight16,

                    // Kilometre Driven
                    TextFormField(
                      controller: _mileageController,
                      keyboardType: TextInputType.number,
                      decoration: kInputDecoration.copyWith(hintText: "Kilometre Driven"),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter kilometre driven' : null,
                      style: const TextStyle(color: kDarkText),
                    ),
                    KHeight16,

                    // Fuel Type Dropdown
                    DropdownButtonFormField<String>(
                      value: _fuelType,
                      decoration: kInputDecoration.copyWith(hintText: "Petrol"),
                      items: ['Petrol', 'Diesel', 'Hybrid', 'Electric']
                          .map((fuel) => DropdownMenuItem(
                                value: fuel,
                                child: Text(fuel, style: const TextStyle(color: kDarkText)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _fuelType = value!;
                        });
                      },
                      style: const TextStyle(color: kDarkText, fontSize: 15),
                      dropdownColor: Colors.white,
                    ),
                    KHeight16,

                    // Expected Selling Amount
                    TextFormField(
                      controller: _expectedSellingAmountController,
                      keyboardType: TextInputType.number,
                      decoration: kInputDecoration.copyWith(
                        hintText: "Expected Selling Amount",
                        suffixIcon: const Icon(Icons.calculate_outlined, color: kLightText),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter amount' : null,
                      style: const TextStyle(color: kDarkText),
                    ),
                    KHeight16,

                    // Additional Notes (optional)
                    TextFormField(
                      controller: _additionalNotesController,
                      maxLines: 3, // Allow multiple lines
                      decoration: kInputDecoration.copyWith(
                        hintText: "Additional Notes (optional)",
                      ),
                      style: const TextStyle(color: kDarkText),
                    ),
                    KHeight16,

                    // Choose Files
                    GestureDetector(
                      onTap: _pickImage,
                      child: InputDecorator(
                        decoration: kInputDecoration.copyWith(
                          hintText: _pickedImages.isEmpty ? "No file chosen" : "${_pickedImages.length} file(s) chosen",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          border: OutlineInputBorder( // Ensure border is visible for this "pseudo-button"
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: kInputBorderColor, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: kInputBorderColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: kPrimaryBlue, width: 1),
                          ),
                          prefixIconConstraints: BoxConstraints.tightForFinite(width: 100), // Give space for "Choose Files" button
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6E8EA), // Light grey background
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.withOpacity(0.4)),
                              ),
                              child: const Text('Choose Files', style: TextStyle(color: kDarkText, fontSize: 14, fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                        child: Text(
                          _pickedImages.isEmpty ? "" : "${_pickedImages.length} file(s) chosen",
                          style: const TextStyle(color: kLightText, fontSize: 15),
                        ),
                      ),
                    ),
                    if (_pickedImages.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _pickedImages.asMap().entries.map((entry) {
                            return Stack(
                              children: [
                                Container(
                                  width: 80, // Smaller preview
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: _buildImagePreview(entry.value),
                                  ),
                                ),
                                Positioned(
                                  top: -5,
                                  right: -5,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(entry.key),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.7),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(3),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    KHeight30, // Big spacer before next section

                    // --- Purchase Details Section ---
                    const Text(
                      "Purchase Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kDarkText,
                      ),
                    ),
                    const Divider(thickness: 1, color: kInputBorderColor),
                    KHeight20,

                    // Date Picker
                    GestureDetector(
                      onTap: () => _selectDate(context, _purchaseDateController, (date) {
                        setState(() {
                          _purchaseDate = date;
                        });
                      }),
                      child: AbsorbPointer( // Prevents TextFormField from being editable directly
                        child: TextFormField(
                          controller: _purchaseDateController,
                          decoration: kInputDecoration.copyWith(
                            hintText: "Date",
                            suffixIcon: const Icon(Icons.calendar_today_outlined, color: kLightText),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Please select a date' : null,
                          style: const TextStyle(color: kDarkText),
                        ),
                      ),
                    ),
                    KHeight16,

                    // Seller Name
                    TextFormField(
                      controller: _sellerNameController,
                      decoration: kInputDecoration.copyWith(hintText: "Seller Name"),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter seller name' : null,
                      style: const TextStyle(color: kDarkText),
                    ),
                    KHeight16,

                    // Seller Phone
                   TextFormField(
  controller: _sellerPhoneController,
  keyboardType: TextInputType.phone,
  decoration: kInputDecoration.copyWith(hintText: "Seller Phone"),
  style: const TextStyle(color: kDarkText),
  
  // Validator for required and length
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter seller phone';
    } else if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }
    return null;
  },

  // Limit input to digits only and max 10 characters
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ],
),
                    KHeight16,

                    // Seller Address
                    TextFormField(
                      controller: _sellerAddressController,
                      maxLines: 3,
                      decoration: kInputDecoration.copyWith(hintText: "Seller Address"),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter seller address' : null,
                      style: const TextStyle(color: kDarkText),
                    ),
                    KHeight16,

                  // Purchase Amount
TextFormField(
  controller: _purchaseAmountController,
  keyboardType: TextInputType.number,
  decoration: kInputDecoration.copyWith(
    hintText: "Purchase Amount",
    suffixIcon: const Icon(Icons.calculate_outlined, color: kLightText),
  ),
  validator: (value) => value == null || value.isEmpty ? 'Please enter purchase amount' : null,
  style: const TextStyle(color: kDarkText),
  onChanged: (value) {
    setState(() {
      _statusController.text = _getPaymentStatus();
    });
  },
),
KHeight16,

// Purchase Paid Amount
TextFormField(
  controller: _purchasePaidAmountController,
  keyboardType: TextInputType.number,
  decoration: kInputDecoration.copyWith(
    hintText: "Purchase Paid Amount",
    suffixIcon: const Icon(Icons.calculate_outlined, color: kLightText),
  ),
  style: const TextStyle(color: kDarkText),
  validator: (value) => value == null || value.isEmpty ? 'Please enter paid amount' : null,
  onChanged: (value) {
    setState(() {
      _statusController.text = _getPaymentStatus();
    });
  },
),

                    KHeight16,

                    // From Account Dropdown
                    DropdownButtonFormField<Account>(
                      decoration: kInputDecoration.copyWith(
                        hintText: "From Account",
                      ),
                      value: _selectedAccount,
                      onChanged: (Account? newAccount) {
                        setState(() {
                          _selectedAccount = newAccount;
                        });
                      },
                      items: accountState.accounts.map((account) {
                        return DropdownMenuItem<Account>(
                          value: account,
                          child: Text("${account.name} (${account.type})", style: const TextStyle(color: kDarkText)),
                        );
                      }).toList(),
                      validator: (value) => value == null ? 'Please select an account' : null,
                      style: const TextStyle(color: kDarkText, fontSize: 15),
                      dropdownColor: Colors.white,
                    ),
                    KHeight16,

                    // Payment Status (Read-only, derived from amounts)
                    // The image doesn't show a dedicated "Payment Status" field.
                    // If you want to display it, you can keep your _statusController
                    // and use it in a read-only TextFormField.
                    // For now, I'm assuming it's handled internally or in the backend.
                    // If you need it visible, style it like other TextFormFields.
                    TextFormField(
                      controller: _statusController,
                      readOnly: true,
                      decoration: kInputDecoration.copyWith(hintText: "Payment Status"),
                      style: const TextStyle(color: kDarkText),
                    ),
                    KHeight20,

                    // Enable Partnership Toggle
                    SwitchListTile(
                      title: const Text(
                        "Enable Partnership",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkText,
                        ),
                      ),
                      value: _isPartnershipEnabled,
                      onChanged: (value) {
                        setState(() {
                          _isPartnershipEnabled = value;
                        });
                      },
                      activeColor: kPrimaryBlue, // Blue for active state
                      contentPadding: EdgeInsets.zero, // Remove default padding
                    ),
                    KHeight16,

                    // Partnership Card (Conditional)
                    if (_isPartnershipEnabled)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white, // White background for the card
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: kInputBorderColor, width: 1), // Subtle border
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Partners",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kDarkText,
                              ),
                            ),
                            KHeight16,
                            if (_partnerships.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text("No partners have been added yet.", style: TextStyle(color: kLightText)),
                              )
                            else
                              Column(
                                children: _partnerships.map((partnership) {
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: kInputFillColor, // Light grey background for each partner item
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "${partnership.partnerName}: ",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: kDarkText,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "Contribution ₹${partnership.contribution}",
                                                  style: const TextStyle(color: kDarkText),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.clear, color: kErrorRed, size: 20),
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
                            KHeight16,
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: kPrimaryButtonStyle.copyWith(
                                  backgroundColor: MaterialStateProperty.all(const Color(0xFF333333)), // Darker blue for '+' button
                                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)), // Larger padding
                                ),
                                onPressed: () async {
                                  final selectedPartnership = await showModalBottomSheet<Partnership>(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (context) => Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom,
                                      ),
                                      child: AddPartnershipDetails(
                                        vehicleId: isEditing ? widget.vehicleToEdit!.id : '', // Pass vehicle ID
                                      ),
                                    ),
                                  );

                                  if (selectedPartnership != null) {
                                    setState(() {
                                      _partnerships.add(selectedPartnership);
                                    });
                                  }
                                },
                                child: const Icon(Icons.add, color: Colors.white, size: 28), // Just a '+' icon
                              ),
                            ),
                          ],
                        ),
                      ),
                    KHeight30, // Spacer before submit

                    // Submit Button
                    SizedBox(
                      width: double.infinity, // Make button full width
                      child: ElevatedButton(
                        style: kPrimaryButtonStyle.copyWith(
                          backgroundColor: MaterialStateProperty.all(const Color(0xFF333333)), // Dark blue as in image
                        ),
                        onPressed: () async {
                          
                          if (_formKey.currentState!.validate()) {

                            final paymentStatus = _getPaymentStatus();
if (!['pending','partial','paid'].contains(paymentStatus)) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Invalid payment status')),
  );
  return;
}


                            // Collect data and submit
                            final newVehicle = Vehicle(
                              id: isEditing ? widget.vehicleToEdit!.id : const Uuid().v4(),
                              make: _makeController.text,
                              model: _modelController.text,
                              photos: _pickedImages,
                              mileage: double.tryParse(_mileageController.text) ?? 0.0,
                              fuelType: _fuelType,
                              year: _yearController.text,
                              price: _expectedSellingAmountController.text,
                              registrationId: _registrationIdController.text,
                              color: _colorController.text,
                              description: _additionalNotesController.text,
                              status: 'available', // Default status
                              purchaseInfo: Purchase(
                                id: '', // Generated on backend or if you have a purchase ID
                                vehicleId: isEditing ? widget.vehicleToEdit!.id : const Uuid().v4(),
                              //  userId: ref.read(authNotifierProvider).user?.id ?? '',
                              userId: '',
                                  accountId: _selectedAccount?.id ?? '',
                                name: _sellerNameController.text,
                                phone: _sellerPhoneController.text,
                                address: _sellerAddressController.text,
                                date: _purchaseDate ?? DateTime.now(),
                                price: double.tryParse(_purchaseAmountController.text) ?? 0.0,
                                modeOfPayment: _selectedAccount?.id ?? '',
                                paymentStatus: _getPaymentStatus(), // Use the derived status
                                paidAmount: double.tryParse(_purchasePaidAmountController.text) ?? 0.0,
                                
                              ),
                              
                              partnerships: _isPartnershipEnabled ? _partnerships : [],
                            );


                             // --- ADD THIS DEBUG PRINT ---
        print('Purchase payload: ${newVehicle.purchaseInfo.toJson()}');
                            try {
                              if (isEditing) {
                                await ref.read(vehicleProvider.notifier).updateVehicle(newVehicle);
                              } else {
                                await ref.read(vehicleProvider.notifier).addVehicle(newVehicle);
                              }
                              ref.read(vehicleProvider.notifier).clearVehicleToEdit();
                              widget.onAddComplete();
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error saving vehicle: ${e.toString()}')),
                              );
                            }
                          }
                        },
                        child: Text(isEditing ? 'Update Vehicle' : 'Submit'),
                      ),
                    ),
                    KHeight30, // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to derive payment status based on amounts
String _getPaymentStatus() {
  final purchaseAmount = double.tryParse(_purchaseAmountController.text.trim()) ?? 0.0;
  final paidAmount = double.tryParse(_purchasePaidAmountController.text.trim()) ?? 0.0;

  if (paidAmount <= 0) return 'pending';
  if (paidAmount < purchaseAmount) return 'partial';
  return 'paid';
}


  
  // Your existing _updatePaymentStatus is good, but make sure to call setState
  // when the internal _statusController or _purchasePaymentStatus needs updating.
  // I've removed the direct binding to _statusController as it's not present in the design.
  // The _getPaymentStatus() method above can be used when constructing the Purchase object.
} 
































































/*
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';

import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/models/account.dart';
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

  // final List<String> _paymentModes = ['cash', 'card', 'cheque', 'finance'];
  // String? _selectedPaymentMode;

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

  // (seeller and purchase )

  final TextEditingController _sellerNameController = TextEditingController();
  final TextEditingController _sellerPhoneController = TextEditingController();
  final TextEditingController _sellerPurchaseAdressController =
      TextEditingController();
  final TextEditingController _purchaseAmountController =
      TextEditingController();
  final TextEditingController _paidAmountController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
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

      _purchaseAmountController.clear();
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
       final accountState = ref.read(accountProvider); // ✅ Get account list


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
        _purchaseDateController.text = vehicle.purchaseInfo.date
            .toIso8601String()
            .split('T')
            .first;
         _purchaseAmountController.text = vehicle.purchaseInfo.price.toString();
          _paidAmountController.text = vehicle.purchaseInfo.paidAmount.toString();
          _statusController.text = vehicle.purchaseInfo.paymentStatus;
          //  bool purchasePaid = vehicle.purchaseInfo.purchasePaid;
        _purchaseAmountController.addListener(_updatePaymentStatus);
        _paidAmountController.addListener(_updatePaymentStatus);


         try {
    _selectedAccount = accountState.accounts.firstWhere(
      (acc) => acc.id == vehicle.purchaseInfo.modeOfPayment,
    );
  } catch (e) {
    print('⚠️ From Account not found for ID: ${vehicle.purchaseInfo.modeOfPayment}');
    _selectedAccount = null;
  }


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

  Account? _selectedAccount;

  @override
  Widget build(BuildContext context) {
    final vehicleToEdit = ref.watch(vehicleProvider).vehicleToEdit;
    final isEditing = vehicleToEdit != null;
     final accountState = ref.watch(accountProvider);

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
                          onPressed: (){
                             Navigator.of(context).pop(); // ✅ go back to previous screen
                          },
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

                  Text(
                    "Purchase Amount",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextFormField(
                    controller: _purchaseAmountController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter purchase Amount';
                      return null;
                    },
                    decoration: kCommonInputDecoration.copyWith(
                      hintText: "Purchase Amount",
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

                  TextFormField(
                    controller: _paidAmountController,
                    decoration: kCommonInputDecoration.copyWith(
                      hintText: "Paid Amount",
                    ),
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                  ),
                  KHeight16,

                  DropdownButtonFormField<Account>(
  decoration: kCommonInputDecoration.copyWith(
    hintText: "From Account",
  ),
  value: _selectedAccount, // You need to define this in your widget's state
  onChanged: (Account? newAccount) {
    setState(() {
      _selectedAccount = newAccount;
    });
  },
  items: ref.watch(accountProvider).accounts.map((account) {
    return DropdownMenuItem<Account>(
      value: account,
      child: Text("${account.name} (${account.type})"),
    );
  }).toList(),
  style: TextStyle(color: Colors.black),
  dropdownColor: Colors.white,
),

                  KHeight16,

                  TextFormField(
                    readOnly: true,
                    controller: _statusController,
                    decoration: kCommonInputDecoration.copyWith(
                      hintText: "Payment Status",
                    ),
                    style: TextStyle(color: Colors.black),
                     // read-only
                  ),

                  // DropdownButtonFormField<String>(
                  //   value: _selectedPaymentMode,
                  //   decoration: kCommonInputDecoration.copyWith(
                  //     hintText: "Select Payment Mode",
                  //   ),
                  //   icon: Icon(Icons.arrow_drop_down),
                  //   style: TextStyle(color: Colors.black),
                  //   validator: (value) => value == null || value.isEmpty
                  //       ? 'Select a payment mode'
                  //       : null,
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       _selectedPaymentMode = newValue;
                  //       print(
                  //         "Selected Payment Mode: $_selectedPaymentMode",
                  //       ); // 👈 Add this
                  //     });
                  //   },
                  //   items: _paymentModes.map<DropdownMenuItem<String>>((
                  //     String value,
                  //   ) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(value),
                  //     );
                  //   }).toList(),
                  // ),
                  // KHeight20,

                  // Text('Payment Status', style: TextStyle(color: Colors.black)),
                  // DropdownButtonFormField<String>(
                  //   value: _purchasePaymentStatus,
                  //   decoration: kCommonInputDecoration.copyWith(
                  //     hintText: "payment status",
                  //   ),
                  //   items: ['paid', 'partial', 'pending'].map((status) {
                  //     return DropdownMenuItem<String>(
                  //       value: status,
                  //       child: Text(
                  //         status[0].toUpperCase() + status.substring(1),
                  //       ),
                  //     );
                  //   }).toList(),
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       _purchasePaymentStatus = newValue;
                  //     });
                  //   },
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please select payment status';
                  //     }
                  //     return null;
                  //   },
                  // ),
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
                                          vehicleId: _idController.text,
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

                                    // purchase paid
                                    double price = double.tryParse(_priceController.text.replaceAll(',', '')) ?? 0.0;
      double paidAmount = double.tryParse(_paidAmountController.text.replaceAll(',', '')) ?? 0.0;
      bool purchasePaid = paidAmount >= price;

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
                                    userId:
                                        '', // Set current user ID here if available
                                    name: _sellerNameController.text,
                                    phone: _sellerPhoneController.text,
                                    address: _sellerAddressController.text,
                                    date:
                                        DateTime.tryParse(
                                          _purchaseDateController.text,
                                        ) ??
                                        DateTime.now(),
                                    price:
                                        double.tryParse(
                                          _priceController.text.replaceAll(
                                            ',',
                                            '',
                                          ),
                                        ) ??
                                        0.0,
                                        modeOfPayment: _selectedAccount?.id ?? '',// <-- Account ID here

                                    // modeOfPayment: _selectedPaymentMode?.toLowerCase() ?? '',
                                    paymentStatus:
                                        _purchasePaymentStatus ?? 'pending',

                                        // purchasePaid:purchasePaid
                                        paidAmount:  double.tryParse(_paidAmountController.text) ?? 0.0,

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

  //update payment
void _updatePaymentStatus() {
  final purchase = double.tryParse(_purchaseAmountController.text) ?? 0.0;
  final paid = double.tryParse(_paidAmountController.text) ?? 0.0;

  String status;
  if (paid == 0) {
    status = 'Pending';
  } else if (paid < purchase) {
    status = 'Partial';
  } else {
    status = 'Paid';
  }

  setState(() {
    _statusController.text = status;
    _purchasePaymentStatus = status; // ✅ also update backend value
  });

  print("DEBUG: purchase=$purchase, paid=$paid");
  print("DEBUG: status=$status");
}

}
*/