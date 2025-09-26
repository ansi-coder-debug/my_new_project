// lib/presentation/financiers/widgets/add_financier_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/financier/financier_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/financier.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class AddFinancierDialog extends ConsumerStatefulWidget {
  const AddFinancierDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<AddFinancierDialog> createState() => _AddFinancierDialogState();
}

class _AddFinancierDialogState extends ConsumerState<AddFinancierDialog> {
  final _formKey = GlobalKey<FormState>();

  final _companyNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactPersonController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final financier = Financier(
      companyName: _companyNameController.text.trim(),
      contactPerson: _contactPersonController.text.trim(),
      contactNumber: _contactNumberController.text.trim(),
      address: _addressController.text.trim(),
    );

    try {
      await ref.read(financierProvider.notifier).addFinancier(financier);
      await ref.read(financierProvider.notifier).loadFinanciers();

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Financier added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add financier: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      height: MediaQuery.of(context).size.height *0.50,
      title: "Add Financier",
      onSubmit: _submitForm,
      onCancel: () => Navigator.of(context).pop(),
      bodyContent:Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _companyNameController,
                decoration: buildInputDecoration("Company Name"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
                style: const TextStyle(color: Colors.black),
              ),
             KHeight16,
          
              TextFormField(
                controller: _contactPersonController,
                decoration: buildInputDecoration("Contact Person"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
                style: const TextStyle(color: Colors.black),
              ),
             KHeight16,
          
              TextFormField(
                controller: _contactNumberController,
                decoration: buildInputDecoration("Contact Number"),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Required";
                  }
                  if (val.length != 10) {
                    return "Contact number must be exactly 10 digits";
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow digits only
                  LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                ],
                style: const TextStyle(color: Colors.black),
              ),
          
              KHeight16,
          
              TextFormField(
                controller: _addressController,
                decoration: buildInputDecoration("Address"),
                maxLines: 2,
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
                style: const TextStyle(color: Colors.black),
              ),
              // const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/*// lib/presentation/financiers/widgets/add_financier_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/financier/financier_provider.dart';
import 'package:my_new_project/core/models/financier.dart';

class AddFinancierDialog extends ConsumerStatefulWidget {
  const AddFinancierDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<AddFinancierDialog> createState() => _AddFinancierDialogState();
}

class _AddFinancierDialogState extends ConsumerState<AddFinancierDialog> {
  final _formKey = GlobalKey<FormState>();

  final _companyNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactPersonController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final financier = Financier(
      companyName: _companyNameController.text.trim(),
      contactPerson: _contactPersonController.text.trim(),
      contactNumber: _contactNumberController.text.trim(),
      address: _addressController.text.trim(),
    );

    try {
      await ref.read(financierProvider.notifier).addFinancier(financier);
      await ref.read(financierProvider.notifier).loadFinanciers();

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Financier added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add financier: $e')));
    }
  }

  InputDecoration buildInputDecoration(String hintText) {
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Add Financier",
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
                  TextFormField(
                    controller: _companyNameController,
                    decoration: buildInputDecoration("Company Name"),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Required" : null,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _contactPersonController,
                    decoration: buildInputDecoration("Contact Person"),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Required" : null,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _contactNumberController,
                    decoration: buildInputDecoration("Contact Number"),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Required";
                      }
                      if (val.length != 10) {
                        return "Contact number must be exactly 10 digits";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Allow digits only
                      LengthLimitingTextInputFormatter(
                        10,
                      ), // Limit to 10 digits
                    ],
                    style: const TextStyle(color: Colors.black),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _addressController,
                    decoration: buildInputDecoration("Address"),
                    maxLines: 2,
                    validator: (val) =>
                        val == null || val.isEmpty ? "Required" : null,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 24),

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
                          style: TextStyle(color: Color(0xFF1B1B3A)),
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
    );
  }
}
*/
