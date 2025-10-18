import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/core/constants/constant.dart';

class SalesEditScreen extends ConsumerStatefulWidget {
  final Vehicle vehicle;
  final bool isEditMode;

  const SalesEditScreen({
    Key? key,
    required this.vehicle,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  ConsumerState<SalesEditScreen> createState() => _SalesEditScreenState();
}

class _SalesEditScreenState extends ConsumerState<SalesEditScreen> {
  final dateController = TextEditingController();
  final vehicleController = TextEditingController();
  final priceController = TextEditingController();
  final recivedPriceController = TextEditingController();
  final bankController = TextEditingController();
  final buyerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();

  late bool isEditMode;
  String? selectedAccountId;


  void initState() {
    super.initState();
    isEditMode = widget.isEditMode;

    final sale = widget.vehicle.saleInfo;
    final account = accountProvider.notifier;
    selectedAccountId = sale?.accountId; // existing account

    print("Sale Info: $sale");
    print("Received in account: ${sale?.modeOfPayment}");
    print('Address: ${sale?.address}');

    // If SaleInfo has a `toString()` or override, this will show nicely
    print("Received in account (modeOfPayment): ${sale?.modeOfPayment}");

    // Also print your new field 'accountName' if you have it
    print("Received in account (accountName): ${sale?.accountName}");

    if (sale?.date != null && sale!.date.isNotEmpty) {
      final parsedDate = DateTime.tryParse(sale.date);
      if (parsedDate != null) {
        dateController.text = DateFormat('MM/dd/yyyy').format(parsedDate);
      }
    }

    vehicleController.text = '${widget.vehicle.make} ${widget.vehicle.model}';

    priceController.text = sale?.price ?? '';
    recivedPriceController.text = sale?.receivedPrice ?? '';

    // bankController.text = sale?.modeOfPayment ?? '';
   if (sale?.accountId != null) {
  final accounts = ref.read(accountProvider).accounts; 
  final match = accounts.firstWhere(
    (a) => a.id == sale!.accountId,
    orElse: () => Account(id: null, name: sale?.accountName ?? '', type: ''),
  );
  bankController.text = match.name;
}


    buyerNameController.text = sale?.name ?? '';
    phoneController.text = sale?.phone ?? '';
    descriptionController.text = sale?.address ?? '';
  }

  

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    final sale = widget.vehicle.saleInfo;
  final accounts = ref.watch(accountProvider).accounts;


if (sale?.accountId != null && accounts.isNotEmpty) {
  final match = accounts.firstWhere(
    (a) => a.id == sale!.accountId,
    orElse: () => Account(id: null, name: sale?.accountName ?? '', type: ''),
  );
  bankController.text = match.name;
}

print("Sale toAccount: ${sale?.accountId}, accountName: ${sale?.accountName}");


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
                // Top bar
                KHeight30,
                Row(
                  children: [
                    _buildIconButton(
                      Icons.arrow_back,
                      () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      isEditMode ? 'Edit Sale Record' : 'View Sale Record',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                KHeight,

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment:
                              Alignment.centerLeft, // Align left (optional)
                          child: SizedBox(
                            width:
                                MediaQuery.of(context).size.width *
                                0.5, // 50% width
                            child: _buildTextField(
                              label: 'Date',
                              controller: dateController,
                              readOnly: !isEditMode,
                              onTap: isEditMode ? _selectDate : null,
                            ),
                          ),
                        ),

                        KHeight,

                        _buildTextField(
                          label: 'Vehicle',
                          controller: vehicleController,
                          readOnly: true,
                        ),

                        _buildTextField(
                          // label: 'Price',
                          controller: priceController,
                          readOnly: !isEditMode,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          suffixIcon: const Icon(Icons.calculate_outlined),
                        ),

                        _buildTextField(
                          // label: 'Recieved Price',
                          controller: recivedPriceController,
                          readOnly: !isEditMode,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          suffixIcon: const Icon(Icons.calculate_outlined),
                        ),

                        // _buildTextField(
                        //   // label: 'Recieved in Account',
                        //   controller: bankController,
                        //   readOnly: !isEditMode,
                        // ),
                        _buildAccountDropdown(),


                        _buildTextField(
                          // label: 'Name',
                          controller: buyerNameController,
                          readOnly: !isEditMode,
                        ),

                        _buildTextField(
                          // label: 'Phone',
                          controller: phoneController,
                          readOnly: !isEditMode,
                          keyboardType: TextInputType.phone,
                        ),

                        _buildTextField(
                          // label: 'Address',
                          controller: descriptionController,
                          readOnly: !isEditMode,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),

                if (isEditMode) KHeight,

                // Update button
                if (isEditMode)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _updateSaleRecord,
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

  Widget _buildTextField({
    String label = '',
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

  Future<void> _updateSaleRecord() async {
    final notifier = ref.read(vehicleProvider.notifier);

    final saleData = {
      "date": dateController.text,
      "amount": double.tryParse(priceController.text) ?? 0.0,
      "paid": double.tryParse(recivedPriceController.text) ?? 0.0,
      "accountId": selectedAccountId, // 👈 use selected dropdown value
      "buyerName": buyerNameController.text,
      "phone": phoneController.text,
      "description": descriptionController.text,
    };

    try {
      await notifier.markVehicleAsSold(
        vehicleId: widget.vehicle.id,
        saleData: saleData,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sale record updated')));
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

  @override
  void dispose() {
    dateController.dispose();
    vehicleController.dispose();
    priceController.dispose();
    recivedPriceController.dispose();
    bankController.dispose();
    buyerNameController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

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
            'Received in Account',
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
            return DropdownMenuItem<String>(
              value: a.id,
              child: Text(a.name),
            );
          }).toList(),
          onChanged: isEditMode
              ? (String? id) {
                  if (id != null) {
                    setState(() {
                      selectedAccountId = id;
                      final account =
                          accounts.firstWhere((a) => a.id == id);
                      bankController.text = account.name;
                    });
                  }
                }
              : null, // read-only if not edit mode
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
