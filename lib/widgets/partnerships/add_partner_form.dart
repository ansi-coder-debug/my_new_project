

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/partner/partner_provider.dart';

import 'package:my_new_project/core/models/partner.dart';
import 'package:my_new_project/core/models/partnership.dart';

class AddPartnerForm extends ConsumerStatefulWidget {
  @override
  _AddPartnerFormState createState() => _AddPartnerFormState();
}

class _AddPartnerFormState extends ConsumerState<AddPartnerForm> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedPartner;
  String? _contactPhone;
  String? _address; // optional, no need to save in model

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Partner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Partner Detail',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Partner Name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter partner name';
                  }
                  return null;
                },
                onSaved: (value) => _selectedPartner = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contact Phone',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                ),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _contactPhone = value,
              ),
              SizedBox(height: 16),
              TextFormField(
  decoration: InputDecoration(
    labelText: 'Address',
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 12,
    ),
  ),
  maxLines: 3,
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    return null;
  },
  onSaved: (value) => _address = value,
),

              SizedBox(height: 24),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // Create Partnership object without address (optional)
                      final newPartner = Partner(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _selectedPartner!,
                        address: _address !, // or collect from a field
                        phone: _contactPhone ,
                      );

                      // Add partner to provider
                      ref.read(partnerProvider.notifier).addPartner(newPartner);

                      // Close form or show success message
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
