/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/broker/broker_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/broker.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';


class AddBrokerDialogForm extends ConsumerStatefulWidget {
  const AddBrokerDialogForm({super.key});

  @override
  ConsumerState<AddBrokerDialogForm> createState() => _AddBrokerDialogFormState();
}

class _AddBrokerDialogFormState extends ConsumerState<AddBrokerDialogForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();

    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final broker = Broker(
        //  id: ,
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
      );

      await ref.read(brokerProvider.notifier).addBroker(broker);

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Broker created successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return CustomDialog(
      height:MediaQuery.of(context).size.height * 0.42,
      title:"Add Broker",
      onSubmit: _submit,
       onCancel: () => Navigator.of(context).pop(),
       bodyContent:Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                 style: Kblack,
                decoration: buildInputDecoration("Broker Name"),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? "Required" : null,
              ),
              KHeight20,
              TextFormField(
                controller: _phoneCtrl,
                 style: Kblack,
                decoration:  buildInputDecoration( "Contact Phone"),
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return "Required";
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return "Enter exactly 10 digits";
                  }
                  return null;
                },
              ),
               KHeight,
              TextFormField(
                controller: _addressCtrl,
                decoration: buildInputDecoration("Address"),
                style: Kblack,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? "Required" : null,
                    maxLines: 2,
              ),
               KHeight20,
            ],
          ),
        ),
      ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/broker/broker_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/broker.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class BrokerDialog extends ConsumerStatefulWidget {
  final Broker broker;
  final bool isViewOnly;

  const BrokerDialog({
    super.key,
    required this.broker,
    this.isViewOnly = false,
  });

  @override
  ConsumerState<BrokerDialog> createState() => _BrokerDialogState();
}

class _BrokerDialogState extends ConsumerState<BrokerDialog> {
  bool isEdit = false;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    isEdit = !widget.isViewOnly;

    _nameCtrl.text = widget.broker.name;
    _phoneCtrl.text = widget.broker.phone ?? '';
    _addressCtrl.text = widget.broker.address ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _updateBroker() async {
    final updated = widget.broker.copyWith(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
    );

// Pass id and toJson
await ref.read(brokerProvider.notifier).updateBroker(
  updated.id!,
  updated.toJson(),
);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Broker updated')),
    );
  }

  Future<void> _deleteBroker() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this broker?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(brokerProvider.notifier).deleteBroker(widget.broker.id!);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Broker deleted')),
      );
    }
  }

  void _submit() async {
    if (_nameCtrl.text.trim().isEmpty) return;

    final newBroker = Broker(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
    );

    await ref.read(brokerProvider.notifier).addBroker(newBroker);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Broker created successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      height: MediaQuery.of(context).size.height * 0.42,
      title: widget.isViewOnly
          ? 'View Broker'
          : (isEdit ? 'Edit Broker' : 'Add Broker'),
      onCancel: () => Navigator.of(context).pop(),
      onSubmit: isEdit ? _updateBroker : (widget.isViewOnly ? null : _submit),
      bodyContent: Form(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                style: Kblack,
                readOnly: widget.isViewOnly ? true : false,
                decoration: buildInputDecoration("Broker Name"),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? "Required" : null,
              ),
              KHeight20,
              TextFormField(
                controller: _phoneCtrl,
                style: Kblack,
                readOnly: widget.isViewOnly ? true : false,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: buildInputDecoration("Contact Phone"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return "Required";
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return "Enter exactly 10 digits";
                  }
                  return null;
                },
              ),
              KHeight,
              TextFormField(
                controller: _addressCtrl,
                style: Kblack,
                readOnly: widget.isViewOnly ? true : false,
                decoration: buildInputDecoration("Address"),
                maxLines: 2,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? "Required" : null,
              ),
              KHeight20,

              if (isEdit)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: _deleteBroker,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _updateBroker,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A0A33),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
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

