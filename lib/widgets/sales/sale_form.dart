// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_new_project/application/broker/broker_provider.dart';

// import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
// import 'package:my_new_project/core/constants/constant.dart';
// import 'package:my_new_project/core/models/broker.dart';
// import 'package:my_new_project/core/models/sales.dart';
// import 'package:my_new_project/core/models/vehicle.dart';
// import 'package:my_new_project/infrastructure/vehicle/vehicle_repositary.dart';

// class SaleForm extends ConsumerStatefulWidget {
//   final Vehicle vehicle;

//   const SaleForm({Key? key, required this.vehicle}) : super(key: key);

//   @override
//   ConsumerState<SaleForm> createState() => _SaleFormState();
// }

// class _SaleFormState extends ConsumerState<SaleForm> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _dateController = TextEditingController();


//   // Dropdown values
//   String? _advancePayment;
//   String? _selectedMode;
//   final List<String> _paymentModes = ['Cash', 'Online', 'Cheque'];

//   // Constants for spacing
//   static const KHeight = SizedBox(height: 10);
//   static const KHeight16 = SizedBox(height: 16);
//   static const KHeight20 = SizedBox(height: 20);

//   // Pick date
//   Future<void> _pickDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _dateController.text =
//             "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
//       });
//     }
//   }

//   List<Map<String, dynamic>> brokersList = [];

//   //paid partial pending
//   // Controllers (declare in your state class)
//   final TextEditingController salePriceController = TextEditingController();
//   final TextEditingController receivedAmountController =
//       TextEditingController();
//   final TextEditingController paymentStatusController = TextEditingController(
//     text: 'Pending',

//   );

//   bool isReceivedEnabled = false;

//   // In initState (optional)
//   @override
//   void initState() {
//     super.initState();

//     salePriceController.addListener(() {
//       final isNotEmpty =
//           salePriceController.text.trim().isNotEmpty &&
//           int.tryParse(salePriceController.text) != null;

//       setState(() {
//         isReceivedEnabled = isNotEmpty;
//       });

//       _updatePaymentStatus();
//     });

//     receivedAmountController.addListener(_updatePaymentStatus);

//     //broker
//     // ref.read(brokerProvider.notifier).loadBrokers();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref
//           .read(brokerProvider.notifier)
//           .loadBrokers(); // ✅ Brokers loaded globally
//     });
//   }

//   // Update function
//   void _updatePaymentStatus() {
//     final sale = int.tryParse(salePriceController.text);
//     final received = int.tryParse(receivedAmountController.text);

//     String status = 'Pending';

//     if (sale == null || sale == 0 || received == null || received == 0) {
//       status = 'Pending';
//     } else if (received >= sale) {
//       status = 'Paid';
//     } else if (received < sale) {
//       status = 'Partial';
//     }

//     paymentStatusController.text = status;
//   }

//   @override
//   Widget build(BuildContext context) {
//     //broker
//     final brokerState = ref.watch(brokerProvider);
//     final List<Broker> brokers = brokerState.brokers;

//     final vehicleNotifier = ref.read(vehicleProvider.notifier);

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Sale Info Title
//                   const Text(
//                     "Sale Information",
//                     style: TextStyle(
//                       fontSize: 30,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                   KHeight20,

//                   const Text(
//                     "Customer & Payment",
//                     style: TextStyle(fontSize: 15, color: Colors.black),
//                   ),
//                   KHeight,
//                   const Divider(color: Colors.black),
//                   KHeight20,

//                   const Text("Select Advance Payment"),
//                   DropdownButtonFormField<String>(
//                     value: _advancePayment,
//                     hint: const Text("Manual Entry / No Advance"),
//                     items: ["Manual Entry / No Advance"].map((method) {
//                       return DropdownMenuItem(
//                         value: method,
//                         child: Text(method),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _advancePayment = value;
//                       });
//                     },
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   KHeight20,

//                   // Customer Name
//                   const Text(
//                     "Customer Name *",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   KHeight,
//                   TextFormField(
//                     controller: _nameController,
//                     style: const TextStyle(color: Colors.black),
//                     decoration: const InputDecoration(
//                       hintText: "Enter customer name",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   KHeight20,

//                   // Phone
//                   const Text(
//                     "Customer Phone *",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   KHeight,
//                   TextFormField(
//                     controller: _phoneController,
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     decoration: const InputDecoration(
//                       hintText: "Enter phone number",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   KHeight20,

//                   // Address
//                   const Text(
//                     "Customer Address",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   KHeight,
//                   TextFormField(
//                     controller: _addressController,
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     decoration: const InputDecoration(
//                       hintText: "Enter customer address",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   KHeight16,

//                   const Text(
//                     "Payment Mode *",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                   ),
//                   KHeight,
//                   DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 14,
//                       ),
//                     ),
//                     hint: const Text("Select Payment Mode"),
//                     value: _selectedMode,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedMode = newValue;
//                       });
//                     },
//                     validator: (value) =>
//                         value == null ? 'Please select a payment mode' : null,
//                     items: _paymentModes.map((String mode) {
//                       return DropdownMenuItem<String>(
//                         value: mode,
//                         child: Text(mode),
//                       );
//                     }).toList(),
//                   ),
//                   KHeight20,

//                   const Text(
//                     "Sale Details",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   KHeight,
//                   const Divider(color: Colors.black),
//                   KHeight20,

//                   const Text(
//                     "Sale Date*",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   KHeight,
//                   TextFormField(
//                     controller: _dateController,
//                     readOnly: true,
//                     decoration: const InputDecoration(
//                       hintText: "dd-MM-yyyy",
//                       suffixIcon: Icon(Icons.calendar_today),
//                       border: OutlineInputBorder(),
//                     ),
//                     onTap: () => _pickDate(context),
//                   ),
//                   KHeight20,

//                   const Text(
//                     "Sale Price(INR)*",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   KHeight,
//                   TextFormField(
//                     controller: salePriceController,
//                     style: Kblack,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       hintText: "e.g. 500000",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   KHeight20,

//                   const Text(
//                     "Received Amount(INR)*",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   KHeight,
//                   TextFormField(
//                     controller: receivedAmountController,
//                     style: Kblack,
//                     keyboardType: TextInputType.number,
//                     enabled: isReceivedEnabled,
//                     decoration: InputDecoration(
//                       hintText: isReceivedEnabled
//                           ? "e.g. 100000"
//                           : "Enter Sale Price first",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   KHeight20,

//                   const Text(
//                     "Payment Status*",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   KHeight,
//                   TextFormField(
//                     controller: paymentStatusController,
//                     style: Kblack,
//                     readOnly: true,
//                     enabled: false, // Fully disabled so user can't type
//                     decoration: InputDecoration(border: OutlineInputBorder()),
//                   ),
//                   KHeight20,

//                   const Text(
//                     "Brokerage Details",
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   KHeight,
//                   const Divider(color: Colors.black),
//                   KHeight20,

//                   // Show Select Broker (Always)
//                   const Text(
//                     "Select Broker",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   KHeight,

//                   DropdownButtonFormField<int>(
//                     value: brokersList.isNotEmpty
//                         ? brokersList[0]["brokerId"]
//                         : null,
//                     items: brokers.map((broker) {
//                       return DropdownMenuItem<int>(
//                         value: broker.id,
//                         child: Text(broker.name),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         // If list is empty, initialize it
//                         if (brokersList.isEmpty) {
//                           brokersList.add({
//                             "brokerId": value,
//                             "brokerName": brokers
//                                 .firstWhere((b) => b.id == value!)
//                                 .name,
//                             "amount": TextEditingController(),
//                             "remarks": TextEditingController(),
//                           });
//                         } else {
//                           brokersList[0]["brokerId"] = value;
//                           brokersList[0]["brokerName"] = brokers
//                               .firstWhere((b) => b.id == value!)
//                               .name;
//                         }
//                       });
//                     },
//                     decoration: const InputDecoration(
//                       hintText: "Select Broker (Optional)",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   KHeight,

//                   // Show Amount and Remarks only if broker selected
//                   if (brokersList.isNotEmpty &&
//                       brokersList[0]["brokerId"] != null) ...[
//                     const Text("Brokerage Amount (INR) *"),
//                     KHeight,
//                     TextFormField(
//                       controller: brokersList[0]["amount"],
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         hintText: "e.g., 5000",
//                         suffixIcon: Icon(Icons.calculate),
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     KHeight,

//                     const Text("Brokerage Remarks"),
//                     KHeight,
//                     TextFormField(
//                       controller: brokersList[0]["remarks"],
//                       decoration: const InputDecoration(
//                         hintText: "Optional remarks",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     KHeight20,
//                   ],

//                   Center(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 30,
//                           vertical: 15,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),

//                       onPressed: () async {
//                         if (_formKey.currentState!.validate()) {
//                           final saleInfo = SaleInfo(
//                             name: _nameController.text.trim().toLowerCase(),
//                             phone: _phoneController.text.trim().toLowerCase(),
//                             address: _addressController.text
//                                 .trim()
//                                 .toLowerCase(),
//                             date: _dateController.text.trim(),
//                             price: salePriceController.text.trim(),
//                             receivedPrice: receivedAmountController.text
//                                 .trim()
//                                 .toLowerCase(),
//                             modeOfPayment: _selectedMode?.toLowerCase() ?? '',
//                             paymentStatus: paymentStatusController.text
//                                 .trim()
//                                 .toLowerCase(),

//                           );

//                           final brokerEntry = brokersList.isNotEmpty
//                               ? brokersList.first
//                               : null;

//                           final saleData = {
//                             'status': 'sold',
//                             'sale_name': saleInfo.name,
//                             'sale_phone': saleInfo.phone,
//                             'sale_address': saleInfo.address,
//                             'sale_date': saleInfo.date,
//                             'sale_price': saleInfo.price.replaceAll(',', ''),
//                             'sale_received_price': saleInfo.receivedPrice
//                                 .replaceAll(',', ''),
//                             'sale_mode_of_payment': saleInfo.modeOfPayment,
//                             'sale_payment_status': saleInfo.paymentStatus,
  
                            

//                             // Single broker flattened fields
//                             if (brokerEntry != null &&
//                                 brokerEntry["brokerId"] != null)
//                               "broker_id": brokerEntry["brokerId"],
//                             if (brokerEntry != null &&
//                                 brokerEntry["amount"]?.text.trim().isNotEmpty ==
//                                     true)
//                               "brokerage_amount": brokerEntry["amount"].text
//                                   .trim(),
//                             if (brokerEntry != null)
//                               "brokerage_remarks":
//                                   brokerEntry["remarks"]?.text.trim() ?? "",
//                           };

//                           try {
//                             await ref
//                                 .read(vehicleRepositoryProvider)
//                                 .markVehicleAsSold(widget.vehicle.id, saleData);

//                             if (mounted) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text("✅ Vehicle marked as Sold"),
//                                 ),
//                               );
//                               Navigator.of(context).pop(); // close the form
//                             }
//                           } catch (e) {
//                             if (mounted) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text("❌ Error: $e")),
//                               );
//                             }
//                           }
//                         }
//                       },

//                       child: const Text(
//                         "Submit",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/application/advance/advance_provider.dart';
import 'package:my_new_project/application/broker/broker_provider.dart';
import 'package:my_new_project/application/finance/finance_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/core/models/advance.dart';
import 'package:my_new_project/core/models/broker.dart';
import 'package:my_new_project/core/models/finance.dart';
import 'package:my_new_project/core/models/sales.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/infrastructure/vehicle/vehicle_repositary.dart';

class SaleForm extends ConsumerStatefulWidget {
  final Vehicle vehicle;
   final VoidCallback? onSubmitSuccess;

  const SaleForm({Key? key, required this.vehicle,
  this.onSubmitSuccess}) : super(key: key);

  @override
  ConsumerState<SaleForm> createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends ConsumerState<SaleForm> {
  final _formKey = GlobalKey<FormState>();

  // State variables for form fields
  String? _selectedAdvanceId;
  final TextEditingController _buyerNameController = TextEditingController();
  final TextEditingController _buyerPhoneController = TextEditingController();
  final TextEditingController _buyerAddressController = TextEditingController();
  DateTime _saleDate = DateTime.now();
  final TextEditingController _saleAmountController = TextEditingController();
  final TextEditingController _receivedAmountController = TextEditingController();
  String? _selectedToAccount;
  String? _selectedBrokerId;
  final TextEditingController _brokerageAmountController = TextEditingController();
  final TextEditingController _brokerageRemarksController = TextEditingController();
  bool _isFinanced = false;
  String? _selectedFinancierId;
  final TextEditingController _financeAmountController = TextEditingController();
  final TextEditingController _financeReceivedAmountController = TextEditingController();
  String? _selectedFinanceToAccount;

  bool _isLoading = false;

  // Dynamic field states
  bool get _isReceivedAmountEnabled => _saleAmountController.text.trim().isNotEmpty && (double.tryParse(_saleAmountController.text) ?? 0) > 0;
  bool get _isFinanceReceivedEnabled => _financeAmountController.text.trim().isNotEmpty && (double.tryParse(_financeAmountController.text) ?? 0) > 0;
  bool get _isSalePaymentMade => (double.tryParse(_receivedAmountController.text) ?? 0) > 0;
  bool get _isFinancePaymentMade => (double.tryParse(_financeReceivedAmountController.text) ?? 0) > 0;

  @override
  void initState() {
    super.initState();
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(advanceProvider.notifier).loadAdvances();
      ref.read(brokerProvider.notifier).loadBrokers();
    });

    // Add listeners for dynamic field enabling
    _saleAmountController.addListener(() => setState(() {}));
    _financeAmountController.addListener(() => setState(() {}));
    _receivedAmountController.addListener(() => setState(() {}));
    _financeReceivedAmountController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _buyerNameController.dispose();
    _buyerPhoneController.dispose();
    _buyerAddressController.dispose();
    _saleAmountController.dispose();
    _receivedAmountController.dispose();
    _brokerageAmountController.dispose();
    _brokerageRemarksController.dispose();
    _financeAmountController.dispose();
    _financeReceivedAmountController.dispose();
    super.dispose();
  }

  void _handleAdvanceSelection(Advance? advance) {
    setState(() {
      _selectedAdvanceId = advance?.id?.toString();
      if (advance != null) {
        _buyerNameController.text = advance.buyerName;
        _buyerPhoneController.text = advance.buyerPhone ?? '';
        _buyerAddressController.text = advance.buyerAddress ?? '';
      } else {
        _buyerNameController.clear();
        _buyerPhoneController.clear();
        _buyerAddressController.clear();
      }
    });
  }

  Future<void> _submitSale() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create sale data
        final saleData = await _buildSaleData();
        
        // Mark vehicle as sold
        await ref.read(vehicleProvider.notifier).markVehicleAsSold(
          widget.vehicle.id,
          saleData,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Vehicle marked as Sold'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<Map<String, dynamic>> _buildSaleData() async {
    final saleInfo = SaleInfo(
      name: _buyerNameController.text.trim(),
      phone: _buyerPhoneController.text.trim(),
      address: _buyerAddressController.text.trim(),
      date: DateFormat('yyyy-MM-dd').format(_saleDate),
      price: _saleAmountController.text.trim(),
      receivedPrice: _receivedAmountController.text.trim(),
      modeOfPayment: _selectedToAccount ?? '',
      paymentStatus: _getSalePaymentStatus(),
    );

    final Map<String, dynamic> saleData = {
      'status': 'sold',
      'sale_name': saleInfo.name,
      'sale_phone': saleInfo.phone,
      'sale_address': saleInfo.address,
      'sale_date': saleInfo.date,
      'sale_price': saleInfo.price.replaceAll(',', ''),
      'sale_received_price': saleInfo.receivedPrice.replaceAll(',', ''),
      'sale_to_account': saleInfo.modeOfPayment,
      'sale_payment_status': saleInfo.paymentStatus,
      'is_financed': _isFinanced,
    };

    // Add finance data if financed
    if (_isFinanced) {
      saleData['financier_id'] = _selectedFinancierId;
      saleData['finance_amount'] = _financeAmountController.text.trim().replaceAll(',', '');
      saleData['finance_received_price'] = _financeReceivedAmountController.text.trim().replaceAll(',', '');
      saleData['finance_to_account'] = _selectedFinanceToAccount;
    }

    // Add brokerage data if broker selected
    if (_selectedBrokerId != null) {
      saleData['broker_id'] = _selectedBrokerId;
      saleData['brokerage_amount'] = _brokerageAmountController.text.trim().replaceAll(',', '');
      if (_brokerageRemarksController.text.trim().isNotEmpty) {
        saleData['brokerage_remarks'] = _brokerageRemarksController.text.trim();
      }
    }

    return saleData;
  }

  String _getSalePaymentStatus() {
    final saleAmount = double.tryParse(_saleAmountController.text) ?? 0;
    final receivedAmount = double.tryParse(_receivedAmountController.text) ?? 0;
    
    if (receivedAmount <= 0) return 'pending';
    if (receivedAmount < saleAmount) return 'partial';
    return 'paid';
  }

  @override
  Widget build(BuildContext context) {
    final advanceState = ref.watch(advanceProvider);
    final brokerState = ref.watch(brokerProvider);
    final accountState = ref.watch(accountProvider);
    final financeState = ref.watch(financeProvider);

    final availableAdvances = advanceState.advances.where((advance) => advance.vehicleId?.toString() == widget.vehicle.id).toList();
    final brokers = brokerState.brokers;
    final accounts = accountState.accounts;

    return 
      
     SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
             
      
              // Sale Information Section
              // const Text(
              //   'Sale Information',
              //  style: TextStyle(
              //   fontSize: 20, 
              //   fontWeight: FontWeight.bold,
              //   color: Colors.black
              // )),
              const Divider(),
              const Text(
                'Customer & Payment',
                 style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w600,
                color: Colors.black
                  )),
              
              // Advance Selection
              _buildAdvanceDropdown(availableAdvances),
              
              _buildStyledTextField(
                controller: _buyerNameController,
                hintText: 'Customer name *',
                validator: (value) => value!.isEmpty && _selectedAdvanceId == null ? 'Required' : null,
                
              ),
              _buildStyledTextField(
                controller: _buyerPhoneController,
                hintText: 'Phone number *',
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty && _selectedAdvanceId == null ? 'Required' : null,
              ),
              _buildStyledTextField(
                controller: _buyerAddressController,
                hintText: 'Customer address',
                isOptional: true,
              ),
      
              const SizedBox(height: 20),
              // Sale Details Section
              const Text('Sale Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black)),
              _buildDateField(
                label: 'Sale Date *',
                selectedDate: _saleDate,
                onDateSelected: (date) {
                  setState(() {
                    _saleDate = date;
                  });
                },
              ),
              _buildStyledTextField(
                controller: _saleAmountController,
                hintText: 'Sale Amount (INR) *',
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
                suffixIcon: Icons.calculate,
              ),
              _buildStyledTextField(
                controller: _receivedAmountController,
                hintText: _isReceivedAmountEnabled ? 'Received Amount (INR)' : 'Enter Sale Amount first',
                keyboardType: TextInputType.number,
                isOptional: true,
                enabled: _isReceivedAmountEnabled,
                suffixIcon: Icons.calculate,
              ),
              _buildAccountDropdown(
                accounts: accounts,
                selectedAccount: _selectedToAccount,
                hintText: 'Payment To Account',
                onChanged: (value) => setState(() => _selectedToAccount = value),
                required: _isSalePaymentMade,
                enabled: _isSalePaymentMade,
              ),
      
              const SizedBox(height: 20),
              // Brokerage Details Section
              const Text('Brokerage Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black)),
              _buildBrokerDropdown(brokers),
              if (_selectedBrokerId != null) ...[
                _buildStyledTextField(
                  controller: _brokerageAmountController,
                  hintText: 'Brokerage Amount (INR) *',
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                  suffixIcon: Icons.calculate,
                ),
                _buildStyledTextField(
                  controller: _brokerageRemarksController,
                  hintText: 'Optional brokerage remarks',
                  isOptional: true,
                ),
              ],
      
              const SizedBox(height: 20),
              // Financed Sale Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Financed Sale', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black)),
                  Switch(
                    value: _isFinanced,
                    onChanged: (value) {
                      setState(() {
                        _isFinanced = value;
                      });
                    },
                  ),
                ],
              ),
      
              // Finance Details Section (conditionally rendered)
              if (_isFinanced) ...[
                const SizedBox(height: 20),
                const Text('Finance Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black)),
                _buildStyledTextField( // Placeholder for Financier - you can implement similar to broker dropdown
                  controller: TextEditingController(text: _selectedFinancierId),
                  hintText: 'Select a Financier *',
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                  onTap: () { 
                    // TODO: Implement financier selection
                    print('Select Financier clicked'); 
                  }
                ),
                _buildStyledTextField(
                  controller: _financeAmountController,
                  hintText: 'Finance Amount (INR) *',
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                  suffixIcon: Icons.calculate,
                ),
                _buildStyledTextField(
                  controller: _financeReceivedAmountController,
                  hintText: _isFinanceReceivedEnabled ? 'Finance Received Amount (INR)' : 'Enter Finance Amount first',
                  keyboardType: TextInputType.number,
                  enabled: _isFinanceReceivedEnabled,
                  suffixIcon: Icons.calculate,
                ),
                _buildAccountDropdown(
                  
                  accounts: accounts,
                  selectedAccount: _selectedFinanceToAccount,
                  hintText: 'Finance To Account',
                  onChanged: (value) => setState(() => _selectedFinanceToAccount = value),
                  required: _isFinancePaymentMade,
                  enabled: _isFinancePaymentMade,
                ),
              ],
      
              const SizedBox(height: 30),
            Center(
  child: ConstrainedBox(
    constraints: BoxConstraints(minWidth: 150),
    child: ElevatedButton(
      onPressed: _isLoading || _submitSale == null ? null : _submitSale,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          : const Text(
              'SUBMIT SALE',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
    ),
  ),
)

            ],
          ),
        ),
    
    );
  }

 Widget _buildAdvanceDropdown(List<Advance> advances) {
  // Safely find the selected advance
  Advance? selectedAdvance;
  if (_selectedAdvanceId != null) {
    try {
      selectedAdvance = advances.firstWhere(
        (advance) => advance.id?.toString() == _selectedAdvanceId,
      );
    } catch (e) {
      // If not found, selectedAdvance remains null
      selectedAdvance = null;
    }
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownButtonFormField<Advance?>(
      style: const TextStyle(color: Colors.black),
    
      isExpanded: true,
      value: selectedAdvance,
      decoration: InputDecoration(
        hintText: 'Select an Advance by Buyer Name',
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: [
        DropdownMenuItem<Advance?>(
          value: null,
          child: Text('Manual Entry / No Advance', style: TextStyle(color: Colors.grey)),
        ),
        ...advances.map((advance) {
          return DropdownMenuItem<Advance?>(
            value: advance,
            child: Text('${advance.buyerName} - ₹${advance.amount}'),
          );
        }).toList(),
      ],
      onChanged: _handleAdvanceSelection,
      validator: (value) => null, // Optional field
    ),
  );
}

  Widget _buildBrokerDropdown(List<Broker> brokers) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        style: const TextStyle(color: Colors.black),

        value: _selectedBrokerId,
        decoration: InputDecoration(
          hintText: 'Select a Broker (Optional)',
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        items: [
          const DropdownMenuItem<String>(
            value: null,
            child: Text('No Broker', style: TextStyle(color: Colors.grey)),
          ),
          ...brokers.map((broker) {
            return DropdownMenuItem<String>(
              value: broker.id?.toString(),
              child: Text(broker.name),
            );
          }).toList(),
        ],
        onChanged: (value) => setState(() => _selectedBrokerId = value),
        validator: (value) => null, // Optional field
      ),
    );
  }

  Widget _buildAccountDropdown({
    required List<Account> accounts,
    required String? selectedAccount,
    required String hintText,
    required Function(String?) onChanged,
    bool required = false,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        style: const TextStyle(color: Colors.black),

        value: selectedAccount,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: enabled ? Colors.grey : Colors.grey[400]),
          filled: true,
          fillColor: enabled ? Colors.grey[100] : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        items: [
          if (!required) const DropdownMenuItem<String>(
            
            value: null,
            child: Text('Select Account', style: TextStyle(color: Colors.grey)),
          ),
          ...accounts.map((account) {
            return DropdownMenuItem<String>(
              value: account.id,
              child: Text('${account.name} (${account.type})'),
            );
          }).toList(),
        ],
        onChanged: enabled ? onChanged : null,
        validator: required ? (value) => value == null ? 'Required' : null : null,
      ),
    );
  }

  Widget _buildStyledTextField({
    
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool isOptional = false,
    bool enabled = true,
    IconData? suffixIcon,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          absorbing: onTap != null,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: onTap != null,
            enabled: enabled,
            style: const TextStyle(color: Colors.black),

            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: enabled ? Colors.grey : Colors.grey[400]),
              filled: true,
              fillColor: enabled ? Colors.grey[100] : Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: enabled ? Colors.grey : Colors.grey[400]) : null,
            ),
            validator: validator,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null && pickedDate != selectedDate) {
            onDateSelected(pickedDate);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            style: const TextStyle(color: Colors.black),

            readOnly: true,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.black54),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
            ),
            controller: TextEditingController(text: DateFormat('dd/MM/yyyy').format(selectedDate)),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
        ),
      ),
    );
  }
}