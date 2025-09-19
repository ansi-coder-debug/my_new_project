import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_new_project/application/cashbook/cashbook_provider.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/core/models/cashbook.dart';

class AddCashBookDialog extends ConsumerStatefulWidget {
  const AddCashBookDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<AddCashBookDialog> createState() => _AddCashBookDialogState();
}

class _AddCashBookDialogState extends ConsumerState<AddCashBookDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedAccountId;
  String _transactionType = 'sale'; // default type
  final _debitController = TextEditingController();
  final _creditController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _debitController.dispose();
    _creditController.dispose();
    _descriptionController.dispose();
    super.dispose();
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

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final debit = _debitController.text.trim().isEmpty
        ? null
        : double.tryParse(_debitController.text.trim());
    final credit = _creditController.text.trim().isEmpty
        ? null
        : double.tryParse(_creditController.text.trim());
    final description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();

    final entry = CashBookEntry(
      accountId: _selectedAccountId!,
      transactionType: _transactionType,
      debit: debit,
      credit: credit,
      description: description,
    );

    try {
      await ref.read(cashBookProvider.notifier).addEntry(entry);
      await ref.read(cashBookProvider.notifier).loadCashBookEntries();

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CashBook entry added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add entry: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountProvider);
    final accounts = accountState.accounts;

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
                    "Add CashBook Entry",
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
                    // Account Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedAccountId,
                      decoration: _inputDecoration("Select Account"),
                      items: accounts
                          .map((account) => DropdownMenuItem(
                                value: account.id,
                                child: Text(account.name),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() => _selectedAccountId = val);
                      },
                      validator: (val) =>
                          val == null ? 'Please select an account' : null,
                    ),
                    const SizedBox(height: 16),

                    // Transaction Type Dropdown
                    DropdownButtonFormField<String>(
                      value: _transactionType,
                      decoration: _inputDecoration("Transaction Type"),
                      items: const [
                        DropdownMenuItem(
                            value: 'sale', child: Text('Sale')),
                        DropdownMenuItem(
                            value: 'purchase', child: Text('Purchase')),
                        DropdownMenuItem(
                            value: 'receipt', child: Text('Receipt')),
                        DropdownMenuItem(
                            value: 'payment', child: Text('Payment')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _transactionType = val);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Debit Field
                    TextFormField(
                      controller: _debitController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("Debit (Optional)"),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 16),

                    // Credit Field
                    TextFormField(
                      controller: _creditController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("Credit (Optional)"),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 16),

                    // Description Field
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 2,
                      decoration: _inputDecoration("Description (Optional)"),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1B1B3A)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                                color: Color(0xFF1B1B3A),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A0A33),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
