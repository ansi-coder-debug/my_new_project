import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/advance/advance_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/core/models/advance.dart';

class AddAdvanceDialog extends ConsumerStatefulWidget {
  const AddAdvanceDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<AddAdvanceDialog> createState() => _AddAdvanceDialogState();
}

class _AddAdvanceDialogState extends ConsumerState<AddAdvanceDialog> {
  final _formKey = GlobalKey<FormState>();

 String? _selectedVehicleId;

  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _buyerNameController = TextEditingController();
  final _buyerPhoneController = TextEditingController();
  final _buyerAddressController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _buyerNameController.dispose();
    _buyerPhoneController.dispose();
    _buyerAddressController.dispose();
    super.dispose();
  }

  void _submitForm() async {
  if (!_formKey.currentState!.validate()) return;

  try {
    final newAdvance = Advance(
      vehicleId: int.parse(_selectedVehicleId!), // ✅ Now included
      amount: double.parse(_amountController.text.trim()),
      date: _selectedDate,
      buyerName: _buyerNameController.text.trim(),
      buyerPhone: _buyerPhoneController.text.trim(),
      buyerAddress: _buyerAddressController.text.trim(),
    );

    print('📤 Sending advance: ${newAdvance.toJson()}'); // 👈 Print before sending

    await ref.read(advanceProvider.notifier).addAdvance(newAdvance);
    await ref.read(advanceProvider.notifier).loadAdvances();

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Advance added successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add advance: $e')),
    );
  }
}


  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF5F6FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicleState = ref.watch(vehicleProvider);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title + Close Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Advance",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B1B3A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF1B1B3A)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Vehicle Dropdown
                    vehicleState.isLoading
                        ? const CircularProgressIndicator()
                        : DropdownButtonFormField<String>(
                          isExpanded: true,
  value: _selectedVehicleId,  // Change to String? or String
  decoration: _inputDecoration("Select vehicle"),
  items: vehicleState.vehicles.map((vehicle) {
    return DropdownMenuItem<String>(
      
      value: vehicle.id,  // Now this is OK
      child: Text('${vehicle.make} ${vehicle.model} ~ ${vehicle.registrationId}'),
    );
  }).toList(),
  onChanged: (val) => setState(() => _selectedVehicleId = val),
  validator: (val) => val == null ? 'Please select a vehicle' : null,
),


                    KHeight16,

                    // Amount
                    TextFormField(
                      controller: _amountController,
                      style: TextStyle(color: Colors.black),
                      decoration: _inputDecoration("Amount"),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter amount';
                        }
                        final amount = double.tryParse(val.trim());
                        if (amount == null || amount <= 0) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Date Picker
                    InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: _inputDecoration("Date"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_selectedDate.toLocal()}".split(' ')[0],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Buyer Name
                    TextFormField(
                      controller: _buyerNameController,
                       style: TextStyle(color: Colors.black),
                      decoration: _inputDecoration("Buyer Name"),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter buyer name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Buyer Phone
                    TextFormField(
                      controller: _buyerPhoneController,
                       style: TextStyle(color: Colors.black),
                      decoration: _inputDecoration("Buyer Phone"),
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter buyer phone';
                        }
                        final phone = val.trim();
                        if (phone.length != 10 ||
                            !RegExp(r'^\d{10}$').hasMatch(phone)) {
                          return 'Phone must be exactly 10 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Buyer Address
                    TextFormField(
                      controller: _buyerAddressController,
                       style: TextStyle(color: Colors.black),
                      decoration: _inputDecoration("Buyer Address"),
                      maxLines: 2,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter buyer address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Buttons: Cancel + Submit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1B1B3A)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Color(0xFF1B1B3A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _submitForm,
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
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
