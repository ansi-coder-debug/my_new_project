import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/sale/sale_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/sales.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/infrastructure/vehicle/vehicle_repositary.dart';

class SaleForm extends ConsumerStatefulWidget {
  final Vehicle vehicle;

  const SaleForm({Key? key, required this.vehicle}) : super(key: key);

  @override
  ConsumerState<SaleForm> createState() => _SaleFormState();
}

class _SaleFormState extends ConsumerState<SaleForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateController = TextEditingController();

  // Dropdown values
  String? _advancePayment;
  String? _selectedMode;
  final List<String> _paymentModes = ['Cash', 'Online', 'Cheque'];

  // Constants for spacing
  static const KHeight = SizedBox(height: 10);
  static const KHeight16 = SizedBox(height: 16);
  static const KHeight20 = SizedBox(height: 20);

  // Pick date
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
      });
    }
  }

  //paid partial pending
  // Controllers (declare in your state class)
  final TextEditingController salePriceController = TextEditingController();
  final TextEditingController receivedAmountController =
      TextEditingController();
  final TextEditingController paymentStatusController = TextEditingController(
    text: 'Pending',
  );

  bool isReceivedEnabled = false;

  // In initState (optional)
  @override
  void initState() {
    super.initState();

    salePriceController.addListener(() {
      final isNotEmpty =
          salePriceController.text.trim().isNotEmpty &&
          int.tryParse(salePriceController.text) != null;

      setState(() {
        isReceivedEnabled = isNotEmpty;
      });

      _updatePaymentStatus();
    });

    receivedAmountController.addListener(_updatePaymentStatus);
  }

  // Update function
  void _updatePaymentStatus() {
    final sale = int.tryParse(salePriceController.text);
    final received = int.tryParse(receivedAmountController.text);

    String status = 'Pending';

    if (sale == null || sale == 0 || received == null || received == 0) {
      status = 'Pending';
    } else if (received >= sale) {
      status = 'Paid';
    } else if (received < sale) {
      status = 'Partial';
    }

    paymentStatusController.text = status;
  }

  @override
  Widget build(BuildContext context) {

    
    final vehicleNotifier = ref.read(vehicleProvider.notifier);

    

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sale Info Title
                  const Text(
                    "Sale Information",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  KHeight20,

                  const Text(
                    "Customer & Payment",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  KHeight,
                  const Divider(color: Colors.black),
                  KHeight20,

                  const Text("Select Advance Payment"),
                  DropdownButtonFormField<String>(
                    value: _advancePayment,
                    hint: const Text("Manual Entry / No Advance"),
                    items: ["Manual Entry / No Advance"].map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _advancePayment = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  KHeight20,

                  // Customer Name
                  const Text(
                    "Customer Name *",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  KHeight,
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: "Enter customer name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  KHeight20,

                  // Phone
                  const Text(
                    "Customer Phone *",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  KHeight,
                  TextFormField(
                    controller: _phoneController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Enter phone number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  KHeight20,

                  // Address
                  const Text(
                    "Customer Address",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  KHeight,
                  TextFormField(
                    controller: _addressController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Enter customer address",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  KHeight16,

                  const Text(
                    "Payment Mode *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  KHeight,
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    hint: const Text("Select Payment Mode"),
                    value: _selectedMode,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMode = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a payment mode' : null,
                    items: _paymentModes.map((String mode) {
                      return DropdownMenuItem<String>(
                        value: mode,
                        child: Text(mode),
                      );
                    }).toList(),
                  ),
                  KHeight20,

                  const Text(
                    "Sale Details",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  KHeight,
                  const Divider(color: Colors.black),
                  KHeight20,

                  const Text(
                    "Sale Date*",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  KHeight,
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: "dd-MM-yyyy",
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    onTap: () => _pickDate(context),
                  ),
                  KHeight20,

                  const Text(
                    "Sale Price(INR)*",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  KHeight,
                  TextFormField(
                    controller: salePriceController,
                    style: Kblack,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "e.g. 500000",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  KHeight20,

                  const Text(
                    "Received Amount(INR)*",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  KHeight,
                  TextFormField(
                    controller: receivedAmountController,
                    style: Kblack,
                    keyboardType: TextInputType.number,
                    enabled: isReceivedEnabled,
                    decoration: InputDecoration(
                      hintText: isReceivedEnabled
                          ? "e.g. 100000"
                          : "Enter Sale Price first",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  KHeight20,

                  const Text(
                    "Payment Status*",
                    style: TextStyle(color: Colors.black),
                  ),
                  KHeight,
                  TextFormField(
                    controller: paymentStatusController,
                    style: Kblack,
                    readOnly: true,
                    enabled: false, // Fully disabled so user can't type
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                  KHeight20,

                  const Text(
                    "Brokerage Details",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  KHeight,
                  const Divider(color: Colors.black),
                  KHeight20,

                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: "Select Broker (optional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  KHeight,

                 
                   Center(
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 15,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),



   onPressed: () async {
  if (_formKey.currentState!.validate()) {
    final saleInfo = SaleInfo(
      name: _nameController.text.trim().toLowerCase(),
      phone: _phoneController.text.trim().toLowerCase(),
      address: _addressController.text.trim().toLowerCase(),
      date: _dateController.text.trim(),
      price: salePriceController.text.trim(),
      receivedPrice: receivedAmountController.text.trim().toLowerCase(),
      modeOfPayment: _selectedMode?.toLowerCase()??'',
      paymentStatus: paymentStatusController.text.trim().toLowerCase(),
    );

    final saleData = {
      'status': 'sold',
      'sale_name': saleInfo.name,
      'sale_phone': saleInfo.phone,
      'sale_address': saleInfo.address,
      'sale_date': saleInfo.date,
      'sale_price': saleInfo.price.replaceAll(',', ''),
      'sale_received_price': saleInfo.receivedPrice.replaceAll(',', ''),
      'sale_mode_of_payment': saleInfo.modeOfPayment,
      'sale_payment_status': saleInfo.paymentStatus,
    };

    try {
      await ref.read(vehicleRepositoryProvider).markVehicleAsSold(
        widget.vehicle.id,
        saleData,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Vehicle marked as Sold")),
        );
        Navigator.of(context).pop(); // close the form
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error: $e")),
        );
      }
    }
  }
},






    child: const Text(
      "Submit",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
)


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
