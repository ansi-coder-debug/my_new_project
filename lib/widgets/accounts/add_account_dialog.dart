import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class AddAccountDialog extends ConsumerStatefulWidget {
  const AddAccountDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends ConsumerState<AddAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedType = 'cash'; // default value
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();

    final newAccount = Account(
      id: '',
      name: name,
      type: _selectedType,
      description: description,
    );

    try {
      await ref.read(accountProvider.notifier).addAccount(newAccount);

      // 🔥 Force reload the account list from backend
      await ref.read(accountProvider.notifier).loadAccounts();

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add account: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      height: MediaQuery.of(context).size.height * 0.48, 
      title: "Add Account",
      onSubmit: _submitForm,
      onCancel: () => Navigator.of(context).pop(),
      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Account Name
             Column(
  crossAxisAlignment: CrossAxisAlignment.start, // Align everything to left
  children: [
    const Text(
      "Account Name",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    ),
    const SizedBox(height: 6), // small gap between label and field
    TextFormField(
      controller: _nameController,
      decoration: buildInputDecoration(
        "e.g. Main Cash, HDFC Bank",
      ),
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'Please enter account name';
        }
        return null;
      },
      style: const TextStyle(color: Colors.black, fontSize: 14),
    ),
  ],
),

              KHeight16,
          
              // Type Dropdown
             Column(
  crossAxisAlignment: CrossAxisAlignment.start, // left align label + dropdown
  children: [
    const Text(
      "Account Type",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    ),
    const SizedBox(height: 6), // space between label and dropdown
    DropdownButtonFormField<String>(
      value: _selectedType,
      decoration: buildInputDecoration("Select Account Type"),
      items: const [
        DropdownMenuItem(value: 'cash', child: Text('Cash')),
        DropdownMenuItem(value: 'bank', child: Text('Bank')),
      ],
      onChanged: (val) {
        if (val != null) setState(() => _selectedType = val);
      },
    ),
  ],
),
              KHeight16,
          
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: buildInputDecoration("Description (Optional)"),
                maxLines: 2,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
