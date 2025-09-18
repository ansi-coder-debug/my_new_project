import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/core/models/account.dart';

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
    final description = _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim();

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add account: $e')),
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
            // Title + Close Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Add Account",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B1B3A),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF1B1B3A)),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
            const SizedBox(height: 16),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Account Name
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration("Account Name (e.g. Main Cash, HDFC Bank)"),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Please enter account name';
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 16),

                  // Type Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: _inputDecoration("Account Type"),
                    items: const [
                      DropdownMenuItem(value: 'cash', child: Text('Cash')),
                      DropdownMenuItem(value: 'bank', child: Text('Bank')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedType = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: _inputDecoration("Description (Optional)"),
                    maxLines: 2,
                       style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 24),

                  // Buttons: Cancel + Submit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Cancel Button
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF1B1B3A)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Color(0xFF1B1B3A), fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Submit Button
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A0A33),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
