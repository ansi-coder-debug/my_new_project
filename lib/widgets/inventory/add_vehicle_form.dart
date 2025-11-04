import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/application/partner/partner_provider.dart';
import 'package:my_new_project/application/partnership/partnership_form_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_form_notifier.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/constants/vehicle_make.dart';
import 'package:my_new_project/core/constants/vehicle_model.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/core/models/purchase.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/widgets/accounts/edit_account_dialog.dart';
import 'package:my_new_project/widgets/inventory/screen_vehicle_details.dart';
import 'package:my_new_project/widgets/partnerships/add_partnership_details.dart'; // Assuming this exists
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:uuid/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AddVehicleForm extends ConsumerStatefulWidget {
  final Vehicle? vehicleToEdit;
  final Key? formKey;
  final VoidCallback? onCancel;
  final VoidCallback onAddComplete;

  const AddVehicleForm({
    super.key,
    this.formKey,
    this.onCancel,
    required this.onAddComplete,
    this.vehicleToEdit,
  });

  @override
  ConsumerState<AddVehicleForm> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends ConsumerState<AddVehicleForm> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  Widget _buildImagePreview(String imagePath) {
    if (kIsWeb || imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      return Image.file(
        File(imagePath),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
    Function(DateTime?) onDateSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.black,
              onSurface: kDarkText,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedDate =
          "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      controller.text = formattedDate;
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    
     final isEditing = widget.vehicleToEdit != null;
     
    final formNotifier = ref.watch(
      addVehicleFormNotifierProvider(widget.vehicleToEdit).notifier,
    );
    final formState = ref.watch(
      addVehicleFormNotifierProvider(widget.vehicleToEdit),
    );
    final accountState = ref.watch(accountProvider);
    final accountNotifier = ref.read(accountProvider.notifier);

    final enteredAmount =
        double.tryParse(formState.purchasePaidAmountController.text) ?? 0;

    return Scaffold(
      backgroundColor: kLightGreyBackground,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "Add Vehicle",
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics:
                      const ClampingScrollPhysics(), // Prevents jumpy behavior

                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Vehicle Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kDarkText,
                        ),
                      ),
                      const Divider(thickness: 1, color: kInputBorderColor),
                      KHeight20,

                      DropdownButtonFormField<String>(
                        value: formState.vehicleType.isNotEmpty?formState.vehicleType:null,
                        decoration: kInputDecoration.copyWith(hintText: "Bike"),
                        items: ['Bike', 'Car', 'Truck', 'Other']
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type,
                                  style: const TextStyle(color: kDarkText),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            formNotifier.setVehicleType(value);
                          }
                        },
                        style: const TextStyle(color: kDarkText, fontSize: 15),
                        dropdownColor: Colors.white,
                      ),
                      KHeight16,

                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          final makes = VehicleMakes.getMakesForVehicleType(
                            formState.vehicleType,
                          );
                          return makes.where((String option) {
                            return option.toLowerCase().contains(
                              textEditingValue.text.toLowerCase(),
                            );
                          });
                        },
                        onSelected: (String selection) {
                          formNotifier.state.makeController.text = selection;
                        },
                        fieldViewBuilder:
                            (
                              BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted,
                            ) {
                              textEditingController.text =
                                  formState.makeController.text;
                              return TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                decoration: kInputDecoration.copyWith(
                                  hintText: "Select Make",
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: kLightText,
                                  ),
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Please select make'
                                    : null,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (value) {
                                  formNotifier.state.makeController.text =
                                      value; // Update the controller
                                },
                              );
                            },
                        optionsViewBuilder:
                            (
                              BuildContext context,
                              AutocompleteOnSelected<String> onSelected,
                              Iterable<String> options,
                            ) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4.0,
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      maxHeight: 200,
                                    ),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                            final String option = options
                                                .elementAt(index);
                                            return ListTile(
                                              title: Text(
                                                option,
                                                style: const TextStyle(
                                                  color: kDarkText,
                                                ),
                                              ),
                                              onTap: () {
                                                onSelected(option);
                                              },
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              );
                            },
                      ),
                      KHeight16,

                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          final models = VehicleModels.getModelsForMake(
                            formState.vehicleType,
                            formState.makeController.text,
                          );
                          return models.where((String option) {
                            return option.toLowerCase().contains(
                              textEditingValue.text.toLowerCase(),
                            );
                          });
                        },
                        onSelected: (String selection) {
                          formNotifier.state.modelController.text = selection;
                        },
                        fieldViewBuilder:
                            (
                              BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted,
                            ) {
                              textEditingController.text =
                                  formState.modelController.text;
                              return TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                decoration: kInputDecoration.copyWith(
                                  hintText: "Select Model",
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: kLightText,
                                  ),
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Please select model'
                                    : null,
                                style: const TextStyle(color: kDarkText),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\s]'),
                                  ),
                                ],
                                onChanged: (value) {
                                  formNotifier.state.modelController.text =
                                      value; // Update the controller
                                },
                              );
                            },
                        optionsViewBuilder:
                            (
                              BuildContext context,
                              AutocompleteOnSelected<String> onSelected,
                              Iterable<String> options,
                            ) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4.0,
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      maxHeight: 200,
                                    ),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      itemBuilder: (context, index) {
                                        final String option = options.elementAt(
                                          index,
                                        );
                                        return ListTile(
                                          title: Text(
                                            option,
                                            style: const TextStyle(
                                              color: kDarkText,
                                            ),
                                          ),
                                          onTap: () {
                                            onSelected(option);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                      ),
                      KHeight16,

                      TextFormField(
                        controller: formState.yearController,
                        keyboardType: TextInputType.number,
                        decoration: kInputDecoration.copyWith(
                          hintText: "Year (e.g., 2022)",
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter year'
                            : null,
                        style: const TextStyle(color: kDarkText),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      KHeight16,

                      TextFormField(
                        controller: formState.colorController,
                        decoration: kInputDecoration.copyWith(
                          hintText: "Color",
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter color'
                            : null,
                        style: const TextStyle(color: kDarkText),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ),
                        ],
                      ),
                      KHeight16,

                      TextFormField(
                        controller: formState.registrationIdController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: kInputDecoration.copyWith(
                          hintText: "Registration No.",
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter registration number'
                            : null,
                        style: const TextStyle(color: kDarkText),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]'),
                          ),
                        ],
                      ),
                      KHeight16,

                      TextFormField(
                        controller: formState.mileageController,
                        keyboardType: TextInputType.number,
                        decoration: kInputDecoration.copyWith(
                          hintText: "Kilometre Driven",
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter kilometre driven'
                            : null,
                        style: const TextStyle(color: kDarkText),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      KHeight16,

                      TextFormField(
                        controller: formState.engineNumberController,
                        keyboardType: TextInputType.text,
                        decoration: kInputDecoration.copyWith(
                          hintText: "Engine Number (Optional)",
                        ),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      KHeight16,

                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: formState.chassisNumberController,
                        keyboardType: TextInputType.text,
                        decoration: kInputDecoration.copyWith(
                          hintText: "Chassis Number (Optional)",
                        ),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 5, 2, 2),
                        ),
                      ),
                      KHeight16,

                      DropdownButtonFormField<String>(
                        value: formState.fuelType.isNotEmpty?formState.fuelType:null,
                        decoration: kInputDecoration.copyWith(
                          hintText: "Petrol",
                        ),
                        items: ['Petrol', 'Diesel', 'Hybrid', 'Electric']
                            .map(
                              (fuel) => DropdownMenuItem(
                                value: fuel,
                                child: Text(
                                  fuel,
                                  style: const TextStyle(color: kDarkText),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            formNotifier.setFuelType(value);
                          }
                        },
                        style: const TextStyle(color: kDarkText, fontSize: 15),
                        dropdownColor: Colors.white,
                      ),
                      KHeight16,

                      TextFormField(
                        controller: formState.expectedSellingAmountController,
                        keyboardType: TextInputType.number,
                        decoration: kInputDecoration.copyWith(
                          hintText: "Expected Selling Amount",
                          suffixIcon: const Icon(
                            Icons.calculate_outlined,
                            color: kLightText,
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter amount'
                            : null,
                        style: const TextStyle(color: kDarkText),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      KHeight16,

                      TextFormField(
                        controller: formState.additionalNotesController,
                        maxLines: 3,
                        decoration: kInputDecoration.copyWith(
                          hintText: "Additional Notes (optional)",
                        ),
                        style: const TextStyle(color: kDarkText),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ),
                        ],
                      ),
                      KHeight16,

                      GestureDetector(
                        onTap: formNotifier.pickImage,
                        child: InputDecorator(
                          decoration: kInputDecoration.copyWith(
                            hintText: formState.pickedImages.isEmpty
                                ? "No file chosen"
                                : "${formState.pickedImages.length} file(s) chosen",
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 14.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: kInputBorderColor,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: kInputBorderColor,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: kPrimaryBlue,
                                width: 1,
                              ),
                            ),
                            prefixIconConstraints:
                                BoxConstraints.tightForFinite(width: 100),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                              ),
                              child: Container(
                                alignment: Alignment.center,

                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFE6E8EA,
                                  ), // Light grey background
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ),
                                child: const Text(
                                  'Choose Files',
                                  style: TextStyle(
                                    color: kDarkText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          child: Text(
                            formState.pickedImages.isEmpty
                                ? ""
                                : "${formState.pickedImages.length} file(s) chosen",
                            style: const TextStyle(
                              color: kLightText,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      if (formState.pickedImages.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: formState.pickedImages
                                .asMap()
                                .entries
                                .map((entry) {
                                  return Stack(
                                    children: [
                                      Container(
                                        width: 80, // Smaller preview
                                        height: 80,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: _buildImagePreview(
                                            entry.value,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -5,
                                        right: -5,
                                        child: GestureDetector(
                                          onTap: () => formNotifier.removeImage(
                                            entry.key,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red.withOpacity(
                                                0.7,
                                              ),
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
                                })
                                .toList(),
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
                        onTap: () => _selectDate(
                          context,
                          formState.purchaseDateController,
                          (date) {
                            formNotifier.setPurchaseDate(date);
                          },
                        ),
                        child: AbsorbPointer(
                          // Prevents TextFormField from being editable directly
                          child: TextFormField(
                            controller: formState.purchaseDateController,
                            decoration: kInputDecoration.copyWith(
                              hintText: "Date",
                              suffixIcon: const Icon(
                                Icons.calendar_today_outlined,
                                color: kLightText,
                              ),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please select a date'
                                : null,
                            style: const TextStyle(color: kDarkText),
                          ),
                        ),
                      ),
                      KHeight16,

                      // Seller Name
                      TextFormField(
                        controller: formState.sellerNameController,
                        decoration: kInputDecoration.copyWith(
                          hintText: "Seller Name",
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter seller name'
                            : null,
                        style: const TextStyle(color: kDarkText),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ),
                        ],
                      ),
                      KHeight16,

                      // Seller Phone
                      TextFormField(
                        controller: formState.sellerPhoneController,
                        keyboardType: TextInputType.phone,
                        decoration: kInputDecoration.copyWith(
                          hintText: "Seller Phone",
                        ),
                        style: const TextStyle(color: kDarkText),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter seller phone';
                          } else if (value.length != 10) {
                            return 'Phone number must be 10 digits';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      KHeight16,

                      // Seller Address
                      TextFormField(
                        controller: formState.sellerAddressController,
                        maxLines: 3,
                        decoration: kInputDecoration.copyWith(
                          hintText: "Seller Address",
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter seller address'
                            : null,
                        style: const TextStyle(color: kDarkText),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ),
                        ],
                      ),
                      KHeight16,

                      // Purchase Amount
                      TextFormField(
                        controller: formState.purchaseAmountController,
                        keyboardType: TextInputType.number,
                        decoration: kInputDecoration.copyWith(
                          hintText: "Purchase Amount",
                          suffixIcon: const Icon(
                            Icons.calculate_outlined,
                            color: kLightText,
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter purchase amount'
                            : null,
                        style: const TextStyle(color: kDarkText),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      KHeight16,

                      // Purchase Paid Amount
                     // Purchase Paid Amount
TextFormField(
  controller: formState.purchasePaidAmountController,
  keyboardType: TextInputType.number,
  decoration: kInputDecoration.copyWith(
    hintText: "Purchase Paid Amount",
    suffixIcon: const Icon(
      Icons.calculate_outlined,
      color: kLightText,
    ),
  ),
  style: const TextStyle(color: kDarkText),
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
  ],
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter paid amount';
    }
    
    final paidAmount = double.tryParse(value) ?? 0;
    final purchaseAmount = double.tryParse(formState.purchaseAmountController.text) ?? 0;
    
    if (paidAmount > purchaseAmount) {
      return 'Paid amount cannot exceed purchase amount';
    }
    
    return null;
  },
  onChanged: (value) {
    // Real-time validation to prevent typing beyond purchase amount
    if (value.isNotEmpty) {
      final paidAmount = double.tryParse(value) ?? 0;
      final purchaseAmount = double.tryParse(formState.purchaseAmountController.text) ?? 0;
      
      if (paidAmount > purchaseAmount) {
        // Automatically trim to purchase amount
        final trimmedValue = purchaseAmount.toStringAsFixed(0);
        formState.purchasePaidAmountController.text = trimmedValue;
        formState.purchasePaidAmountController.selection = TextSelection.collapsed(
          offset: trimmedValue.length,
        );
        
        // Show warning
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Paid amount cannot exceed purchase amount'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  },
),

                      KHeight16,

                      // From Account Dropdown
                      DropdownButtonFormField<Account>(
                        selectedItemBuilder: (context) {
                          return accountState.accounts.map((account) {
                            return Text(
                              account.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            );
                          }).toList();
                        },
                        decoration: kInputDecoration.copyWith(
                          hintText: 'From Account',
                          border: const OutlineInputBorder(),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        // value: formState.selectedAccount,
                        value: formState.selectedAccount == null
    ? null
    : accountState.accounts.firstWhere(
        (a) => a.id == formState.selectedAccount!.id,
      
      ),

                        // onChanged: (account) {
                        //   formNotifier.setSelectedAccount(account);
                        //   if (account != null &&
                        //       account.amount < enteredAmount) {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //         content: Text(
                        //           'Insufficient balance! Please add money.',
                        //         ),
                        //         backgroundColor: Colors.redAccent,
                        //         duration: Duration(seconds: 2),
                        //       ),
                        //     );
                        //   }
                        // },
                        onChanged: (account) {
  if (account == null) return;

  final hasInsufficientBalance = account.amount < enteredAmount;

  if (hasInsufficientBalance) {
    // Show message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${account.name} has insufficient balance (₹${account.amount}). Please select another account.',
        ),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );

    // Immediately reset dropdown (disappear selection)
    Future.delayed(const Duration(milliseconds: 200), () {
      formNotifier.setSelectedAccount(null);
    });
  } else {
    // ✅ Normal behavior (valid selection)
    formNotifier.setSelectedAccount(account);
  }
},

                        items: accountState.accounts.map((account) {
                          final hasInsufficientBalance =
                              account.amount < enteredAmount;
                          return DropdownMenuItem<Account>(
                            value: account,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      account.name,
                                      style: TextStyle(
                                        color: hasInsufficientBalance
                                            ? Colors.orange
                                            : Colors.grey.shade800,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '₹${account.amount}',
                                        style: TextStyle(
                                          color: hasInsufficientBalance
                                              ? Colors.black
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      GestureDetector(
                                        onTap: () async {
                                          // Close dropdown first
                                          Navigator.pop(context);
                                          final result = await showDialog(
                                            context: context,
                                            builder: (ctx) => EditAccountDialog(
                                              account: account,
                                            ),
                                          );
                                          if (result == true)
                                            accountNotifier.loadAccounts();
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        validator: (value) =>
                            value == null ? 'Please select an account' : null,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                        ),
                        dropdownColor: Colors.white,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey,
                        ),
                        isExpanded: true,
                      ),
                      KHeight16,

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
                        value: formState.isPartnershipEnabled,
                        onChanged: (value) {
                          formNotifier.togglePartnership(value);
                        },
                        activeColor: kPrimaryBlue,
                        contentPadding: EdgeInsets.zero,
                      ),
                      KHeight16,














                      // Partnership Card (Conditional)
                      if (formState.isPartnershipEnabled)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: kInputBorderColor,
                              width: 1,
                            ),
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
                              if (formState.partnerships.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    "No partners have been added yet.",
                                    style: TextStyle(color: kLightText),
                                  ),
                                )
                              else
                                Column(
                                  children: formState.partnerships.map((
                                    partnership,
                                  ) {
                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: kInputFillColor,
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
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: kDarkText,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "Contribution ₹${partnership.contribution}",
                                                    style: const TextStyle(
                                                      color: kDarkText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              color: kErrorRed,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              formNotifier.removePartnership(
                                                partnership,
                                              );
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
                                    backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFF333333),
                                    ),
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                  ),
                                  onPressed: () async {

                                    // 🧹 Reset all form providers before opening dialog
  ref.read(partnershipFormProvider.notifier).resetForm();
  ref.read(selectedPartnerProvider.notifier).state = null;
  ref.read(accountProvider.notifier).setSelectedAccount(null);


                                    final selectedPartnership = await showDialog<Partnership>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        final mq = MediaQuery.of(context);
                                        return Dialog(
                                          insetPadding: EdgeInsets.zero,
                                          backgroundColor: Colors.transparent,
                                          alignment: Alignment.center,
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              final fullWidth = mq.size.width;
                                              return Center(
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxWidth: fullWidth,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      bottom:
                                                          mq.viewInsets.bottom,
                                                    ),
                                                    child: SingleChildScrollView(
                                                      child: Material(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        elevation: 6,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                16.0,
                                                              ),
                                                          child: AddPartnershipDetails(
                                                            purchasePrice: double.tryParse(formState.purchaseAmountController.text) ?? 0.0,
                          ownerPaidAmount: double.tryParse(formState.purchasePaidAmountController.text) ?? 0.0,
                          existingPartnerships: formState.partnerships,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );

                                    // if (selectedPartnership != null) {
                                    //   formNotifier.addPartnership(
                                    //     selectedPartnership,
                                    //   );
                                    // }
                                    if (selectedPartnership != null) {
  formNotifier.addPartnership(selectedPartnership);
  print("Partnerships count: ${formState.partnerships.length}");
}

                                  },
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 28,
                                  ),
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
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF333333),
                            ), // Dark blue as in image
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final paymentStatus = formState.paymentStatus;
                              if (![
                                'unpaid',
                                'partial',
                                'paid',
                              ].contains(paymentStatus)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Invalid payment status'),
                                  ),
                                );
                                return;
                              }

                              final newVehicle = Vehicle(
                                id: isEditing
                                    ? widget.vehicleToEdit!.id
                                    : const Uuid().v4(),
                                make: formState.makeController.text,
                                model: formState.modelController.text,
                                photos: formState.pickedImages,
                                mileage:
                                    double.tryParse(
                                      formState.mileageController.text,
                                    ) ??
                                    0.0,
                                fuelType: formState.fuelType,
                                year: formState.yearController.text,
                                price: formState
                                    .expectedSellingAmountController
                                    .text,
                                registrationId:
                                    formState.registrationIdController.text,
                                color: formState.colorController.text,
                                description:
                                    formState.additionalNotesController.text,
                                status: 'available', // Default status

                                purchaseInfo: Purchase(
                                  id: '',
                                  vehicleId: isEditing
                                      ? widget.vehicleToEdit!.id
                                      : const Uuid().v4(),
                                  userId:
                                      '', // You need to get the actual user ID from authProvider
                                  accountId:
                                      formState.selectedAccount?.id ??
                                      '', // Corrected to send account ID
                                  name: formState.sellerNameController.text,
                                  phone: formState.sellerPhoneController.text,
                                  address:
                                      formState.sellerAddressController.text,
                                  date:
                                      formState.purchaseDate ?? DateTime.now(),
                                  price:
                                      double.tryParse(
                                        formState.purchaseAmountController.text,
                                      ) ??
                                      0.0,
                                  modeOfPayment:
                                      formState.selectedAccount?.id ??
                                      '', // Corrected
                                  paymentStatus:
                                      paymentStatus, // Use derived status
                                  paidAmount:
                                      double.tryParse(
                                        formState
                                            .purchasePaidAmountController
                                            .text,
                                      ) ??
                                      0.0,
                                ),
                                partnerships: formState.isPartnershipEnabled
                                    ? formState.partnerships
                                    : [],
                                engineNumber:
                                    formState
                                        .engineNumberController
                                        .text
                                        .isNotEmpty
                                    ? formState.engineNumberController.text
                                    : null,
                                chassisNumber:
                                    formState
                                        .chassisNumberController
                                        .text
                                        .isNotEmpty
                                    ? formState.chassisNumberController.text
                                    : null,
                              );

                              print(
                                'Purchase payload: ${newVehicle.purchaseInfo.toJson()}',
                              );

                              try {
                                Vehicle createdVehicle = await ref
                                    .read(vehicleProvider.notifier)
                                    .addVehicle(newVehicle);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Vehicle added successfully!',
                                    ),
                                  ),
                                );

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ScreenVehicleDetails(
                                      vehicle: createdVehicle,
                                      onBack: () => Navigator.of(context).pop(),
                                    ),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString()}'),
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}
