/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/advance/advance_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/core/models/advance.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class AddAdvanceDialog extends ConsumerStatefulWidget {
  final Advance advance;
  final bool isViewOnly;
  const AddAdvanceDialog({
    Key? key,
    required this.advance,
    this.isViewOnly = false,
  });
  @override
  ConsumerState<AddAdvanceDialog> createState() => _AddAdvanceDialogState();
}

class _AddAdvanceDialogState extends ConsumerState<AddAdvanceDialog> {
  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;
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

      print(
        '📤 Sending advance: ${newAdvance.toJson()}',
      ); // 👈 Print before sending

      await ref.read(advanceProvider.notifier).addAdvance(newAdvance);
      await ref.read(advanceProvider.notifier).loadAdvances();

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Advance added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add advance: $e')));
    }
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

    return CustomDialog(
      title: "Add Advance",
      onSubmit: _submitForm,
      onCancel: () => Navigator.of(context).pop(),
      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Vehicle Dropdown
              vehicleState.isLoading
                  ? const CircularProgressIndicator()
                  :
                    // Date Picker
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width *
                          0.5, // half of screen width (adjust as needed)
                      child: InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: buildInputDecoration("Date"),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${_selectedDate.toLocal()}".split(' ')[0],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black, // make text black
                                ),
                              ),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                    ),

              KHeight16,

              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedVehicleId, // Change to String? or String
                decoration: buildInputDecoration("Select vehicle"),
                items: vehicleState.vehicles.map((vehicle) {
                  return DropdownMenuItem<String>(
                    value: vehicle.id, // Now this is OK
                    child: Text(
                      '${vehicle.make} ${vehicle.model} ~ ${vehicle.registrationId}',
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedVehicleId = val),
                validator: (val) =>
                    val == null ? 'Please select a vehicle' : null,
              ),

              KHeight16,

              // Amount
              TextFormField(
                controller: _amountController,
                style: TextStyle(color: Colors.black),
                decoration: buildInputDecoration("Amount"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              KHeight16,

              // Buyer Name
              TextFormField(
                controller: _buyerNameController,
                style: TextStyle(color: Colors.black),
                decoration: buildInputDecoration("Buyer Name"),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter buyer name';
                  }
                  return null;
                },
              ),
              KHeight16,

              // Buyer Phone
              TextFormField(
                controller: _buyerPhoneController,
                style: TextStyle(color: Colors.black),
                decoration: buildInputDecoration("Buyer Phone"),
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
              KHeight16,
              // Buyer Address
              TextFormField(
                controller: _buyerAddressController,
                style: TextStyle(color: Colors.black),
                decoration: buildInputDecoration("Buyer Address"),
                maxLines: 2,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter buyer address';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/advance/advance_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/advance.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class AddAdvanceDialog extends ConsumerStatefulWidget {
  final Advance advance;
  final bool isViewOnly;
  const AddAdvanceDialog({
    Key? key,
    required this.advance,
    this.isViewOnly = false,
  }) : super(key: key);

  @override
  ConsumerState<AddAdvanceDialog> createState() => _AddAdvanceDialogState();
}

class _AddAdvanceDialogState extends ConsumerState<AddAdvanceDialog> {
  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;
  String? _selectedVehicleId;

  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _buyerNameController = TextEditingController();
  final _buyerPhoneController = TextEditingController();
  final _buyerAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isEdit = !widget.isViewOnly;

    // preload advance data if editing/viewing
    if (widget.advance.id != null) {
      _selectedVehicleId = widget.advance.vehicleId.toString();
      _amountController.text = widget.advance.amount.toString();
      _selectedDate = widget.advance.date;
      _buyerNameController.text = widget.advance.buyerName;
      _buyerPhoneController.text = widget.advance.buyerPhone.toString();
      _buyerAddressController.text = widget.advance.buyerAddress.toString();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _buyerNameController.dispose();
    _buyerPhoneController.dispose();
    _buyerAddressController.dispose();
    super.dispose();
  }

  Future<void> _addAdvance() async {
    if (!_formKey.currentState!.validate()) return;

    final newAdvance = Advance(
      vehicleId: int.parse(_selectedVehicleId!),
      amount: double.parse(_amountController.text.trim()),
      date: _selectedDate,
      buyerName: _buyerNameController.text.trim(),
      buyerPhone: _buyerPhoneController.text.trim(),
      buyerAddress: _buyerAddressController.text.trim(),
    );

    await ref.read(advanceProvider.notifier).addAdvance(newAdvance);
    await ref.read(advanceProvider.notifier).loadAdvances();

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Advance added successfully')),
      );
    }
  }

  Future<void> _updateAdvance() async {
    final updated = widget.advance.copyWith(
      vehicleId: int.parse(_selectedVehicleId!),
      amount: double.parse(_amountController.text.trim()),
      date: _selectedDate,
      buyerName: _buyerNameController.text.trim(),
      buyerPhone: _buyerPhoneController.text.trim(),
      buyerAddress: _buyerAddressController.text.trim(),
    );

    await ref.read(advanceProvider.notifier).updateAdvance(updated);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Advance updated successfully')),
      );
    }
  }

  Future<void> _deleteAdvance() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this advance record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(advanceProvider.notifier).deleteAdvance(widget.advance.id!);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Advance deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicleState = ref.watch(vehicleProvider);

    return CustomDialog(
      title: widget.isViewOnly
          ? "View Advance"
          : (widget.advance.id == null ? "Add Advance" : "Edit Advance"),
      onSubmit: widget.advance.id == null
          ? _addAdvance
          : (isEdit ? _updateAdvance : null),
      onCancel: () => Navigator.of(context).pop(),
      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Date Picker
              // Date
FractionallySizedBox(
  widthFactor: 0.5, // 50% width
  child: TextFormField(
    readOnly: true,
    enabled: !widget.isViewOnly,
    controller: TextEditingController(
      text:
          "${_selectedDate.month.toString().padLeft(2, '0')}/"
          "${_selectedDate.day.toString().padLeft(2, '0')}/"
          "${_selectedDate.year}",
    ),
    style: const TextStyle(color: Colors.black, fontSize: 14),
    decoration: buildInputDecoration(
      "Date",
      icon: Icons.calendar_today,
    ),
    onTap: widget.isViewOnly
        ? null // Disable tap if view only
        : () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() => _selectedDate = picked);
            }
          },
  ),
),
KHeight16,

              // Vehicle Dropdown
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedVehicleId,
                decoration: buildInputDecoration("Select vehicle"),
                items: vehicleState.vehicles.map((vehicle) {
                  return DropdownMenuItem<String>(
                    value: vehicle.id.toString(),
                    child: Text('${vehicle.make} ${vehicle.model} ~ ${vehicle.registrationId}'),
                  );
                }).toList(),
                onChanged: widget.isViewOnly
                    ? null
                    : (val) => setState(() => _selectedVehicleId = val),
                validator: (val) =>
                    val == null ? 'Please select a vehicle' : null,
              ),
              KHeight16,

              // Amount
              TextFormField(
                                style: TextStyle(color: Colors.black),
                controller: _amountController,
                readOnly: widget.isViewOnly,
                decoration: buildInputDecoration("Amount"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              KHeight16,

              // Buyer Name
              TextFormField(
                style: TextStyle(color: Colors.black),
                controller: _buyerNameController,
                readOnly: widget.isViewOnly,
                decoration: buildInputDecoration("Buyer Name"),
              ),
              KHeight16,

              // Buyer Phone
              TextFormField(
                                style: TextStyle(color: Colors.black),
                controller: _buyerPhoneController,
                readOnly: widget.isViewOnly,
                decoration: buildInputDecoration("Buyer Phone"),
                keyboardType: TextInputType.phone,
                maxLength: 10,
              ),
              KHeight16,

              // Buyer Address
              TextFormField(
                                style: TextStyle(color: Colors.black),
                controller: _buyerAddressController,
                readOnly: widget.isViewOnly,
                decoration: buildInputDecoration("Buyer Address"),
                maxLines: 2,
              ),

              KHeight16,

              // Show Delete & Update buttons if editable
              if (!widget.isViewOnly && widget.advance.id != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: _deleteAdvance,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                    ElevatedButton(
                      onPressed: _updateAdvance,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A0A33),
                      ),
                      child: const Text('Update'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}


