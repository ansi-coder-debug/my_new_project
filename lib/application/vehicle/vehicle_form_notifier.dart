import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/purchase.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:my_new_project/core/constants/vehicle_make.dart';
import 'package:my_new_project/core/constants/vehicle_model.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';

// ------------------- State Class for AddVehicleForm -------------------
class AddVehicleFormState {
  final List<String> pickedImages;
  final bool isPartnershipEnabled;
  final List<Partnership> partnerships;
  final String vehicleType;
  final String fuelType;
  final DateTime? purchaseDate;
  final Account? selectedAccount;
  final String paymentStatus; // Derived payment status

  // Controllers (managed by the notifier, but exposed for the UI)
  final TextEditingController makeController;
  final TextEditingController modelController;
  final TextEditingController yearController;
  final TextEditingController colorController;
  final TextEditingController registrationIdController;
  final TextEditingController mileageController;
  final TextEditingController expectedSellingAmountController;
  final TextEditingController additionalNotesController;
  final TextEditingController sellerNameController;
  final TextEditingController sellerPhoneController;
  final TextEditingController sellerAddressController;
  final TextEditingController purchaseAmountController;
  final TextEditingController purchasePaidAmountController;
  final TextEditingController purchaseDateController;
  final TextEditingController engineNumberController;
  final TextEditingController chassisNumberController;

  AddVehicleFormState({
    required this.pickedImages,
    required this.isPartnershipEnabled,
    required this.partnerships,
    required this.vehicleType,
    required this.fuelType,
    this.purchaseDate,
    this.selectedAccount,
    required this.paymentStatus,
    required this.makeController,
    required this.modelController,
    required this.yearController,
    required this.colorController,
    required this.registrationIdController,
    required this.mileageController,
    required this.expectedSellingAmountController,
    required this.additionalNotesController,
    required this.sellerNameController,
    required this.sellerPhoneController,
    required this.sellerAddressController,
    required this.purchaseAmountController,
    required this.purchasePaidAmountController,
    required this.purchaseDateController,
    required this.engineNumberController,
    required this.chassisNumberController,
  });

  AddVehicleFormState copyWith({
    List<String>? pickedImages,
    bool? isPartnershipEnabled,
    List<Partnership>? partnerships,
    String? vehicleType,
    String? fuelType,
    DateTime? purchaseDate,
    Account? selectedAccount,
    String? paymentStatus,
    TextEditingController? makeController, // Typically not copied, but included for completeness
    TextEditingController? modelController,
    TextEditingController? yearController,
    TextEditingController? colorController,
    TextEditingController? registrationIdController,
    TextEditingController? mileageController,
    TextEditingController? expectedSellingAmountController,
    TextEditingController? additionalNotesController,
    TextEditingController? sellerNameController,
    TextEditingController? sellerPhoneController,
    TextEditingController? sellerAddressController,
    TextEditingController? purchaseAmountController,
    TextEditingController? purchasePaidAmountController,
    TextEditingController? purchaseDateController,
    TextEditingController? engineNumberController,
    TextEditingController? chassisNumberController,
  }) {
    return AddVehicleFormState(
      pickedImages: pickedImages ?? this.pickedImages,
      isPartnershipEnabled: isPartnershipEnabled ?? this.isPartnershipEnabled,
      partnerships: partnerships ?? this.partnerships,
      vehicleType: vehicleType ?? this.vehicleType,
      fuelType: fuelType ?? this.fuelType,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      makeController: makeController ?? this.makeController,
      modelController: modelController ?? this.modelController,
      yearController: yearController ?? this.yearController,
      colorController: colorController ?? this.colorController,
      registrationIdController: registrationIdController ?? this.registrationIdController,
      mileageController: mileageController ?? this.mileageController,
      expectedSellingAmountController: expectedSellingAmountController ?? this.expectedSellingAmountController,
      additionalNotesController: additionalNotesController ?? this.additionalNotesController,
      sellerNameController: sellerNameController ?? this.sellerNameController,
      sellerPhoneController: sellerPhoneController ?? this.sellerPhoneController,
      sellerAddressController: sellerAddressController ?? this.sellerAddressController,
      purchaseAmountController: purchaseAmountController ?? this.purchaseAmountController,
      purchasePaidAmountController: purchasePaidAmountController ?? this.purchasePaidAmountController,
      purchaseDateController: purchaseDateController ?? this.purchaseDateController,
      engineNumberController: engineNumberController ?? this.engineNumberController,
      chassisNumberController: chassisNumberController ?? this.chassisNumberController,
    );
  }
}

// ------------------- Notifier for AddVehicleForm -------------------
class AddVehicleFormNotifier extends StateNotifier<AddVehicleFormState> {
  final Ref _ref; // To access other providers
  final Vehicle? vehicleToEdit;

  AddVehicleFormNotifier(this._ref, {this.vehicleToEdit})
      : super(
          AddVehicleFormState(
            pickedImages: [],
            isPartnershipEnabled: false,
            partnerships: [],
            vehicleType: '',
            fuelType: '',
            purchaseDate: DateTime.now(),
            paymentStatus: 'unpaid', // Initial payment status
            selectedAccount: null,
            makeController: TextEditingController(),
            modelController: TextEditingController(),
            yearController: TextEditingController(),
            colorController: TextEditingController(),
            registrationIdController: TextEditingController(),
            mileageController: TextEditingController(),
            expectedSellingAmountController: TextEditingController(),
            additionalNotesController: TextEditingController(),
            sellerNameController: TextEditingController(),
            sellerPhoneController: TextEditingController(),
            sellerAddressController: TextEditingController(),
            purchaseAmountController: TextEditingController(),
            purchasePaidAmountController: TextEditingController(),
            purchaseDateController: TextEditingController(),
            engineNumberController: TextEditingController(),
            chassisNumberController: TextEditingController(),
          ),
        ) {
    _initializeForm();
    // Listen for changes in purchase amount or paid amount to update payment status
    state.purchaseAmountController.addListener(_updatePaymentStatus);
    state.purchasePaidAmountController.addListener(_updatePaymentStatus);
  }

  void _initializeForm() {
    final vehicle = vehicleToEdit;
    if (vehicle != null) {
      state.makeController.text = vehicle.make;
      state.modelController.text = vehicle.model;
      state.yearController.text = vehicle.year;
      state.colorController.text = vehicle.color;
      state.registrationIdController.text = vehicle.registrationId;
      state.mileageController.text = vehicle.mileage.toString();
      state.expectedSellingAmountController.text = vehicle.price;
      state.additionalNotesController.text = vehicle.description.toString();
      state.engineNumberController.text = vehicle.engineNumber ?? '';
      state.chassisNumberController.text = vehicle.chassisNumber ?? '';
      state.sellerNameController.text = vehicle.purchaseInfo.name;
      state.sellerPhoneController.text = vehicle.purchaseInfo.phone;
      state.sellerAddressController.text = vehicle.purchaseInfo.address;
      state.purchaseAmountController.text = vehicle.purchaseInfo.price.toString();
      state.purchasePaidAmountController.text = vehicle.purchaseInfo.paidAmount.toString();

      final purchaseDate = vehicle.purchaseInfo.date;
      state.purchaseDateController.text =
          "${purchaseDate.month.toString().padLeft(2, '0')}/${purchaseDate.day.toString().padLeft(2, '0')}/${purchaseDate.year}";

      state = state.copyWith(
        pickedImages: List<String>.from(vehicle.photos),
        isPartnershipEnabled: vehicle.partnerships?.isNotEmpty ?? false,
        partnerships: vehicle.partnerships ?? [],
       
        fuelType: vehicle.fuelType,
        purchaseDate: purchaseDate,
        paymentStatus: vehicle.purchaseInfo.paymentStatus,
      );

      // Set _selectedAccount if it exists
      final accountState = _ref.read(accountProvider);
      if (vehicle.purchaseInfo.modeOfPayment.isNotEmpty) {
        try {
          final account = accountState.accounts.firstWhere(
            (acc) => acc.id == vehicle.purchaseInfo.modeOfPayment,
          );
          state = state.copyWith(selectedAccount: account);
        } catch (e) {
          debugPrint('⚠️ From Account not found for ID: ${vehicle.purchaseInfo.modeOfPayment}');
        }
      }
    } else {
      // Default for new vehicle
      final now = DateTime.now();
      state.purchaseDateController.text =
          "${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}";
      state = state.copyWith(purchaseDate: now);
    }
  }

  // --- Image Handling ---
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (pickedFile != null) {
      state = state.copyWith(pickedImages: [...state.pickedImages, pickedFile.path]);
    }
  }

  void removeImage(int index) {
    final updatedImages = List<String>.from(state.pickedImages)..removeAt(index);
    state = state.copyWith(pickedImages: updatedImages);
  }

  // --- Form Field Updaters ---
  void setVehicleType(String type) {
    state = state.copyWith(vehicleType: type);
    state.makeController.clear(); // Clear make when type changes
    state.modelController.clear(); // Clear model when type changes
  }

  void setFuelType(String type) {
    state = state.copyWith(fuelType: type);
  }

  void setPurchaseDate(DateTime? date) {
    state = state.copyWith(purchaseDate: date);
  }

  void setSelectedAccount(Account? account) {
    state = state.copyWith(selectedAccount: account);
  }

  void togglePartnership(bool value) {
    state = state.copyWith(isPartnershipEnabled: value);
  }

  void addPartnership(Partnership partnership) {
    state = state.copyWith(partnerships: [...state.partnerships, partnership]);
  }

  void removePartnership(Partnership partnership) {
    final updatedPartnerships = List<Partnership>.from(state.partnerships)..remove(partnership);
    state = state.copyWith(partnerships: updatedPartnerships);
  }

  // Helper to derive payment status based on amounts
  void _updatePaymentStatus() {
    final purchaseAmount = double.tryParse(state.purchaseAmountController.text.trim()) ?? 0.0;
    final paidAmount = double.tryParse(state.purchasePaidAmountController.text.trim()) ?? 0.0;

    String status;
    if (paidAmount <= 0) {
      status = 'unpaid';
    } else if (paidAmount < purchaseAmount) {
      status = 'partial';
    } else {
      status = 'paid';
    }
    if (state.paymentStatus != status) {
      state = state.copyWith(paymentStatus: status);
    }
  }

  // --- Dispose Controllers ---
  @override
  void dispose() {
    state.makeController.removeListener(_updatePaymentStatus);
    state.modelController.removeListener(_updatePaymentStatus);
    state.yearController.removeListener(_updatePaymentStatus);
    state.colorController.removeListener(_updatePaymentStatus);
    state.registrationIdController.removeListener(_updatePaymentStatus);
    state.mileageController.removeListener(_updatePaymentStatus);
    state.expectedSellingAmountController.removeListener(_updatePaymentStatus);
    state.additionalNotesController.removeListener(_updatePaymentStatus);
    state.sellerNameController.removeListener(_updatePaymentStatus);
    state.sellerPhoneController.removeListener(_updatePaymentStatus);
    state.sellerAddressController.removeListener(_updatePaymentStatus);
    state.purchaseAmountController.removeListener(_updatePaymentStatus);
    state.purchasePaidAmountController.removeListener(_updatePaymentStatus);
    state.purchaseDateController.removeListener(_updatePaymentStatus);
    state.engineNumberController.removeListener(_updatePaymentStatus);
    state.chassisNumberController.removeListener(_updatePaymentStatus);


    state.makeController.dispose();
    state.modelController.dispose();
    state.yearController.dispose();
    state.colorController.dispose();
    state.registrationIdController.dispose();
    state.mileageController.dispose();
    state.expectedSellingAmountController.dispose();
    state.additionalNotesController.dispose();
    state.sellerNameController.dispose();
    state.sellerPhoneController.dispose();
    state.sellerAddressController.dispose();
    state.purchaseAmountController.dispose();
    state.purchasePaidAmountController.dispose();
    state.purchaseDateController.dispose();
    state.engineNumberController.dispose();
    state.chassisNumberController.dispose();
    super.dispose();
  }
}

// ------------------- Provider for the Notifier -------------------
final addVehicleFormNotifierProvider = StateNotifierProvider.family<AddVehicleFormNotifier, AddVehicleFormState, Vehicle?>(
  (ref, vehicleToEdit) {
    return AddVehicleFormNotifier(ref, vehicleToEdit: vehicleToEdit);
  },
);