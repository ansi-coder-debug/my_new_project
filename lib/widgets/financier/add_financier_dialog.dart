// lib/presentation/financiers/widgets/add_financier_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/financier/financier_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/financier.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class AddFinancierDialog extends ConsumerStatefulWidget {
  final Financier? financier;
  final bool isViewOnly;

  const AddFinancierDialog({
    Key? key,
    this.financier,
    this.isViewOnly = false,
  }) : super(key: key);

  @override
  ConsumerState<AddFinancierDialog> createState() =>
      _AddFinancierDialogState();
}

class _AddFinancierDialogState extends ConsumerState<AddFinancierDialog> {
  final _formKey = GlobalKey<FormState>();

  final _companyNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _addressController = TextEditingController();

  bool isEdit = false;
  bool get isViewOnly => widget.isViewOnly;

  @override
  void initState() {
    super.initState();

    if (widget.financier != null) {
      final f = widget.financier!;
      _companyNameController.text = f.companyName ?? '';
      _contactPersonController.text = f.contactPerson ?? '';
      _contactNumberController.text = f.contactNumber ?? '';
      _addressController.text = f.address ?? '';
      isEdit = !widget.isViewOnly;
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactPersonController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final financier = Financier(
      id: widget.financier?.id, // Keep ID for edit
      companyName: _companyNameController.text.trim(),
      contactPerson: _contactPersonController.text.trim(),
      contactNumber: _contactNumberController.text.trim(),
      address: _addressController.text.trim(),
    );

    final notifier = ref.read(financierProvider.notifier);

    try {
      if (widget.financier != null) {
        await notifier.updateFinancier(financier);
      } else {
        await notifier.addFinancier(financier);
      }

      await notifier.loadFinanciers();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.financier != null
                ? 'Financier updated successfully'
                : 'Financier added successfully'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: isViewOnly
          ? "View Financier"
          : (widget.financier != null ? "Edit Financier" : "Add Financier"),
      onSubmit: isViewOnly ? null : _submitForm,
      onCancel: () => Navigator.of(context).pop(),
      height: MediaQuery.of(context).size.height * 0.5,
      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Company Name
              TextFormField(
                style: TextStyle(color: Colors.black),
                controller: _companyNameController,
                enabled: !isViewOnly,
                decoration: buildInputDecoration("Company Name"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              KHeight16,

              // Contact Person
              TextFormField(
                   style: TextStyle(color: Colors.black),
                controller: _contactPersonController,
                enabled: !isViewOnly,
                decoration: buildInputDecoration("Contact Person"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              KHeight16,

              // Contact Number
              TextFormField(
                   style: TextStyle(color: Colors.black),
                controller: _contactNumberController,
                enabled: !isViewOnly,
                decoration: buildInputDecoration("Contact Number"),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (val) {
                  if (val == null || val.isEmpty) return "Required";
                  if (val.length != 10)
                    return "Contact number must be exactly 10 digits";
                  return null;
                },
              ),
              KHeight16,

              // Address
              TextFormField(
                   style: TextStyle(color: Colors.black),
                controller: _addressController,
                enabled: !isViewOnly,
                decoration: buildInputDecoration("Address"),
                maxLines: 2,
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
