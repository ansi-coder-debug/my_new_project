import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/core/constants/constant.dart';

class PurchaseEditScreen extends ConsumerStatefulWidget {
  final Vehicle vehicle;
  final bool isEditMode;

  const PurchaseEditScreen({
    Key? key,
    required this.vehicle,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  ConsumerState<PurchaseEditScreen> createState() => _PurchaseEditScreenState();
}

class _PurchaseEditScreenState extends ConsumerState<PurchaseEditScreen> {
  final dateController = TextEditingController();
  final vehicleController = TextEditingController();
  final priceController = TextEditingController();
  final paidAmountController = TextEditingController();
  final paymentModeController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final accountController = TextEditingController();

  late bool isEditMode;
  String? selectedAccountId;

  @override
  void initState() {
    super.initState();
    isEditMode = widget.isEditMode;

    final purchase = widget.vehicle.purchaseInfo;
    final account = accountProvider.notifier;

    if (purchase != null) {
      dateController.text = DateFormat('MM/dd/yyyy').format(purchase.date);
      vehicleController.text = '${widget.vehicle.make} ${widget.vehicle.model}';
      priceController.text = purchase.price.toString();
      paidAmountController.text = purchase.paidAmount.toString();
      // paymentModeController.text = purchase.modeOfPayment;
      nameController.text = purchase.name;
      phoneController.text = purchase.phone;
      addressController.text = purchase.address;
      // account.read(accountProvider.notifier);
      // NEW: initialize selected account
      selectedAccountId =
          purchase.accountId; // <-- if you store account ID in purchase

      final accounts = ref.read(accountProvider).accounts;
      if (selectedAccountId != null) {
        final match = accounts.firstWhere(
          (a) => a.id == selectedAccountId,
          orElse: () => Account(id: null, name: '', type: ''),
        );
        accountController.text = match.name;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                KHeight30,
                Row(
                  children: [
                    _buildIconButton(
                      Icons.arrow_back,
                      () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      isEditMode
                          ? 'Edit Purchase Record'
                          : 'View Purchase Record',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                KHeight,

                // Form fields
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: size.width * 0.5,
                            child: _buildTextField(
                              label: 'Purchase Date',
                              controller: dateController,
                              readOnly: !isEditMode,
                              onTap: isEditMode ? _selectDate : null,
                            ),
                          ),
                        ),
                        KHeight,

                        _buildTextField(
                          // label: 'Vehicle',
                          controller: vehicleController,
                          readOnly: true,
                        ),
                        _buildTextField(
                          label: 'Purchase Amount',
                          controller: priceController,
                          readOnly: !isEditMode,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          suffixIcon: const Icon(
                            Icons.calculate_outlined,
                            size: 18,
                          ),
                        ),
                        _buildTextField(
                          label: ' Purchase Paid Amount',
                          controller: paidAmountController,
                          readOnly: !isEditMode,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          suffixIcon: const Icon(
                            Icons.calculate_outlined,
                            size: 18,
                          ),
                        ),
                        _buildTextField(
                          label: 'Seller Name *',
                          controller: nameController,
                          readOnly: !isEditMode,
                        ),
                        _buildTextField(
                          Hint: 'Seller Address',
                          controller: addressController,
                          readOnly: !isEditMode,
                          maxLines: 2,
                        ),
                        _buildTextField(
                          Hint: 'Phone',
                          controller: phoneController,
                          readOnly: !isEditMode,
                          keyboardType: TextInputType.phone,
                        ),
                        // _buildTextField(
                        //   Hint: 'paid from Account ',
                        //   controller: accountController,
                        //   readOnly: !isEditMode,

                        // ),
                        _buildAccountDropdown(),
                      ],
                    ),
                  ),
                ),

                if (isEditMode) KHeight,
                if (isEditMode)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _updatePurchaseRecord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A0A33),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Update",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                KHeight,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🧱 Text Field Builder (same as in Sales screen)
  Widget _buildTextField({
    String label = '',
    String Hint = '',
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B1B3A),
                ),
              ),
            ),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(
              color: Color(0xFF1B1B3A),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              filled: true,
              fillColor: readOnly ? Color(0xFFF5F5F5) : Colors.white,
              suffixIcon: suffixIcon,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF0A0A33),
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🗓 Date Picker
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(dateController.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  // 💾 Update logic
  Future<void> _updatePurchaseRecord() async {
    final notifier = ref.read(vehicleProvider.notifier);

    final purchaseData = {
      "date": dateController.text,
      "price": double.tryParse(priceController.text) ?? 0.0,
      "paid_amount": double.tryParse(paidAmountController.text) ?? 0.0,
      "accountId": selectedAccountId,
      "name": nameController.text,
      "phone": phoneController.text,
      "address": addressController.text,
    };

    try {
      // await notifier.markVehicleAsPurchased(
      //   vehicleId: widget.vehicle.id,
      //   purchaseData: purchaseData,
      // );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase record updated')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
      }
    }
  }

  // ⏪ Back Button
  Widget _buildIconButton(IconData icon, VoidCallback? onPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: SizedBox(
        width: 36,
        height: 36,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            padding: EdgeInsets.zero,
            iconSize: 18,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    vehicleController.dispose();
    priceController.dispose();
    paidAmountController.dispose();
    paymentModeController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Widget _buildAccountDropdown() {
    final accounts = ref.watch(accountProvider).accounts;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text(
              'Paid From Account',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B1B3A),
              ),
            ),
          ),
          DropdownButtonFormField<String>(
            value: selectedAccountId,
            items: accounts.map((a) {
              return DropdownMenuItem<String>(value: a.id, child: Text(a.name));
            }).toList(),
            onChanged: isEditMode
                ? (String? id) {
                    if (id != null) {
                      setState(() {
                        selectedAccountId = id;
                        final account = accounts.firstWhere((a) => a.id == id);
                        accountController.text = account.name;
                      });
                    }
                  }
                : null,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              filled: true,
              fillColor: isEditMode ? Colors.white : const Color(0xFFF5F5F5),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF0A0A33),
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
