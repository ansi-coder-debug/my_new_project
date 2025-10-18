/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/application/partner/partner_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/account.dart';

import 'package:my_new_project/core/models/partner.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class AddPartnerForm extends ConsumerStatefulWidget {
  @override
  _AddPartnerFormState createState() => _AddPartnerFormState();
}

class _AddPartnerFormState extends ConsumerState<AddPartnerForm> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedPartner;
  String? _contactPhone;
  String? _address; // optional, no need to save in model
  bool _isEnabled = false; // default ON
//   final TextEditingController _accountNameController = TextEditingController();
// String _selectedAccountType = 'cash';

List<Map<String, dynamic>> _accountFields = [
  {
    'nameController': TextEditingController(),
    'type': 'cash',
  }
];




  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      _formKey.currentState!.save();

      final newPartner = Partner(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _selectedPartner!,
        address: _address!,
        phone: _contactPhone,
      );

      await ref.read(partnerProvider.notifier).addPartner(newPartner);


       // 2. If account creation is enabled
    if (_isEnabled) {
      final accountNotifier = ref.read(accountProvider.notifier);

      for (var field in _accountFields) {
        final name = field['nameController'].text.trim();
        final type = field['type'];

        if (name.isNotEmpty) {
          final newAccount = Account(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: name,
            type: type,
            description: 'Created with partner: ${_selectedPartner!}',
          );

          await accountNotifier.addAccount(newAccount); // 👈 Connects to your accountProvider
        }
      }
    }


      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Partner added successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add partner: $e')));
    }
  }

  @override
void dispose() {
  for (var field in _accountFields) {
    field['nameController'].dispose();
  }
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "Add Partner",
      onSubmit: _submitForm,
      onCancel: () => Navigator.of(context).pop(),
      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.black),
                decoration: buildInputDecoration("Enter Partner Name "),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter partner name';
                  }
                  return null;
                },
                onSaved: (value) => _selectedPartner = value,
              ),
              KHeight16,

              TextFormField(
                style: const TextStyle(color: Colors.black),
                decoration: buildInputDecoration("Enter Contact Phone"),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _contactPhone = value,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only numbers
                  LengthLimitingTextInputFormatter(10), // Max 10 digits
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a contact number';
                  }
                  if (value.trim().length != 10) {
                    return 'Phone number must be exactly 10 digits';
                  }
                  return null;
                },
              ),

              KHeight16,
              TextFormField(
                style: const TextStyle(color: Colors.black),
                decoration: buildInputDecoration("Enter Address"),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
                onSaved: (value) => _address = value,
              ),
              KHeight16,
             
Container(
  width: double.infinity,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  decoration: BoxDecoration(
    color: const Color(0xFFF5F6FA),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: const Color(0xFFE0E0E0)),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Toggle Row
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Add Accounts",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 2),
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: _isEnabled,
              onChanged: (val) {
                setState(() {
                  _isEnabled = val;

                  if (!val) {
                    // Clear dynamic rows when switch is turned off
                    for (var f in _accountFields) {
                      f['nameController'].dispose();
                    }
                    _accountFields = [
                      {
                        'nameController': TextEditingController(),
                        'type': 'cash',
                      }
                    ];
                  }
                });
              },
              activeColor: Colors.blue,
            ),
          ),
        ],
      ),

      // Dynamic form fields if toggle is ON
      if (_isEnabled) ...[
        const SizedBox(height: 12),

        // Account Fields
        ..._accountFields.asMap().entries.map((entry) {
          int index = entry.key;
          var field = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                // Account Name
                Expanded(
                  flex: 1,
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: field['nameController'],
                    decoration: const InputDecoration(
                      hintText: "Account name",
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Account Type
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: field['type'],
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        items: const [
                          DropdownMenuItem(
                              value: 'cash', child: Text('Cash')),
                          DropdownMenuItem(
                              value: 'bank', child: Text('Bank')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              field['type'] = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Remove Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      field['nameController'].dispose();
                      _accountFields.removeAt(index);
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          );
        }).toList(),

        // Add button
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _accountFields.add({
                  'nameController': TextEditingController(),
                  'type': 'cash',
                });
              });
            },
            child: Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text(
                  '+',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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

*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/application/partner/partner_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/core/models/partner.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class AddPartnerForm extends ConsumerStatefulWidget {
  final Partner? partner;
  final bool isViewOnly;

  const AddPartnerForm({
    super.key,
    this.partner,
    this.isViewOnly = false,
  });

  @override
  _AddPartnerFormState createState() => _AddPartnerFormState();
}

class _AddPartnerFormState extends ConsumerState<AddPartnerForm> {
  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;
  bool get isViewOnly => widget.isViewOnly;

  String? _partnerName;
  String? _contactPhone;
  String? _address;
  bool _addAccounts = false;

  List<Map<String, dynamic>> _accountFields = [
    {'nameController': TextEditingController(), 'type': 'cash'}
  ];

  @override
  void initState() {
    super.initState();
    if (widget.partner != null) {
      final p = widget.partner!;
      _partnerName = p.name;
      _contactPhone = p.phone;
      _address = p.address;
      isEdit = !isViewOnly;

      // If you want to prefill account info in edit mode, do it here
      // _accountFields = [...]; 
    }
  }

  @override
  void dispose() {
    for (var field in _accountFields) {
      field['nameController'].dispose();
    }
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final newPartner = Partner(
      id: widget.partner?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _partnerName!,
      address: _address!,
      phone: _contactPhone,
    );

    final partnerNotifier = ref.read(partnerProvider.notifier);

    try {
      if (widget.partner != null) {
        await partnerNotifier.updatePartner(newPartner);
      } else {
        await partnerNotifier.addPartner(newPartner);
      }

      // Handle accounts if toggle enabled
      if (_addAccounts) {
        final accountNotifier = ref.read(accountProvider.notifier);
        for (var field in _accountFields) {
          final name = field['nameController'].text.trim();
          final type = field['type'];
          if (name.isNotEmpty) {
            final newAccount = Account(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: name,
              type: type,
              description: 'Created with partner: $_partnerName',
            );
            await accountNotifier.addAccount(newAccount);
          }
        }
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.partner != null ? 'Partner updated' : 'Partner added')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    }
  }

  Future<void> _deletePartner() async {
    if (widget.partner?.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this partner?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(partnerProvider.notifier).deletePartner(widget.partner!.id!);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Partner deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      height: MediaQuery.of(context).size.height * 0.45,
      title: isViewOnly
          ? "View Partner"
          : (widget.partner != null ? "Edit Partner" : "Add Partner"),
      onSubmit: isViewOnly ? null : _submitForm,
      onCancel: () => Navigator.of(context).pop(),
      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(color: Colors.black),
                enabled: !isViewOnly,
                initialValue: _partnerName,
                decoration: buildInputDecoration("Partner Name"),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _partnerName = val,
              ),
              KHeight16,
              TextFormField(
                style: TextStyle(color: Colors.black),
                enabled: !isViewOnly,
                initialValue: _contactPhone,
                decoration: buildInputDecoration("Contact Phone"),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  if (val.length != 10) return 'Must be 10 digits';
                  return null;
                },
                onSaved: (val) => _contactPhone = val,
              ),
              KHeight16,
              TextFormField(
                style: TextStyle(color: Colors.black),
                enabled: !isViewOnly,
                initialValue: _address,
                decoration: buildInputDecoration("Address"),
                maxLines: 2,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _address = val,
              ),
              KHeight16,
              // Add accounts toggle + dynamic fields
              if (!isViewOnly)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text("Add Accounts", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                          const SizedBox(width: 4),
                          Switch(
                            value: _addAccounts,
                            onChanged: (val) {
                              setState(() {
                                _addAccounts = val;
                                if (!val) {
                                  for (var f in _accountFields) {
                                    f['nameController'].dispose();
                                  }
                                  _accountFields = [
                                    {'nameController': TextEditingController(), 'type': 'cash'}
                                  ];
                                }
                              });
                            },
                          )
                        ],
                      ),
                      if (_addAccounts) ...[
                        const SizedBox(height: 12),
                        ..._accountFields.asMap().entries.map((entry) {
                          int index = entry.key;
                          var field = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    controller: field['nameController'],
                                    decoration: const InputDecoration(
                                      hintText: "Account Name",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 1,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: field['type'],
                                      isExpanded: true,
                                      items: const [
                                        DropdownMenuItem(value: 'cash', child: Text('Cash')),
                                        DropdownMenuItem(value: 'bank', child: Text('Bank')),
                                      ],
                                      onChanged: (val) {
                                        if (val != null) setState(() => field['type'] = val);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      field['nameController'].dispose();
                                      _accountFields.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    color: Colors.red,
                                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _accountFields.add({
                                  'nameController': TextEditingController(),
                                  'type': 'cash'
                                });
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 30,
                              color: Colors.black,
                              child: const Center(
                                child: Text('+', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24, height: 1)),
                              ),
                            ),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              if (isEdit)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: _deletePartner,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
