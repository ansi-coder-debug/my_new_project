import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/broker/broker_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/broker.dart';


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
    return AlertDialog(
      title: const Text("Add Broker"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                 style: Kblack,
                decoration: const InputDecoration(labelText: "Broker Name"),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _phoneCtrl,
                 style: Kblack,
                decoration: const InputDecoration(labelText: "Contact Phone"),
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
              TextFormField(
                controller: _addressCtrl,
                decoration: const InputDecoration(labelText: "Address"),
                style: Kblack,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? "Required" : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submit,
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
