/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_new_project/application/cashbook/cashbook_provider.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/cashbook.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class AddCashBookDialog extends ConsumerStatefulWidget {
  const AddCashBookDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<AddCashBookDialog> createState() => _AddCashBookDialogState();
}

class _AddCashBookDialogState extends ConsumerState<AddCashBookDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedAccountId;
  String _transactionType = 'deposit'; // default type
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

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final debit = _debitController.text.trim().isEmpty
        ? null
        : double.tryParse(_debitController.text.trim());
    final credit = _creditController.text.trim().isEmpty
        ? null
        : double.tryParse(_creditController.text.trim());

    // Match React validation
    if (debit == null && credit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter either a debit or credit amount'),
        ),
      );
      return;
    }

    if (debit != null && credit != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Only one of debit or credit should be filled'),
        ),
      );
      return;
    }

    final entry = CashBookEntry(
      accountId: _selectedAccountId!,
      transactionType: _transactionType,
      debit: debit,
      credit: credit,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    try {
      await ref.read(cashBookProvider.notifier).addEntry(entry);
      await ref.read(cashBookProvider.notifier).loadCashBookEntries();

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CashBook entry added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add entry: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountProvider);
    final accounts = accountState.accounts;

    return CustomDialog(
      height: MediaQuery.of(context).size.height * 0.55,
      title: "Add Cash-Book",
      onSubmit: _submitForm,
      onCancel: () => Navigator.of(context).pop(),
      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ✅ Account Dropdown
              DropdownButtonFormField<String>(
                value: _selectedAccountId,
                decoration: buildInputDecoration("Select Account"),
                items: accounts
                    .map(
                      (account) => DropdownMenuItem(
                        value: account.id,
                        child: Text(account.name),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() => _selectedAccountId = val);
                },
                validator: (val) =>
                    val == null ? 'Please select an account' : null,
              ),
              KHeight,

              // ✅ Transaction Type Dropdown (FIXED)
              DropdownButtonFormField<String>(
                value: _transactionType,
                decoration: buildInputDecoration("Transaction Type"),
                items: const [
                  DropdownMenuItem(value: 'deposit', child: Text('Deposit')),
                  DropdownMenuItem(
                    value: 'withdrawal',
                    child: Text('Withdrawal'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _transactionType = val);
                  }
                },
                validator: (val) =>
                    val == null ? 'Please select a transaction type' : null,
              ),
              KHeight,

              // ✅ Conditional Debit or Credit Field
              if (_transactionType == 'withdrawal') ...[
                TextFormField(
                  controller: _debitController,
                  keyboardType: TextInputType.number,
                  decoration: buildInputDecoration("Debit Amount"),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter debit amount' : null,
                ),
                KHeight,
              ],
              if (_transactionType == 'deposit') ...[
                TextFormField(
                  controller: _creditController,
                  keyboardType: TextInputType.number,
                  decoration: buildInputDecoration("Credit Amount"),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter credit amount' : null,
                ),
                KHeight,
              ],

              // ✅ Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: buildInputDecoration("Description (Optional)"),
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
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_new_project/application/cashbook/cashbook_provider.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/account.dart'; // Import Account model
import 'package:my_new_project/core/models/cashbook.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart'; // Assuming this is your CustomDialog

class AddCashBookDialog extends ConsumerStatefulWidget {
  // Optional: You can pass an initial transaction type if opened from Deposit/Withdrawal buttons
  final String? initialTransactionType;

  const AddCashBookDialog({Key? key, this.initialTransactionType}) : super(key: key);

  @override
  ConsumerState<AddCashBookDialog> createState() => _AddCashBookDialogState();
}

class _AddCashBookDialogState extends ConsumerState<AddCashBookDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedTransactionType = 'deposit'; // Default to deposit
  String? _selectedAccountId; // For deposit/withdrawal
  String? _selectedFromAccountId; // For transfer
  String? _selectedToAccountId; // For transfer

  final _amountController = TextEditingController(); // Single controller for all amounts
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial transaction type if provided (e.g., from EditAccountDialog buttons)
    if (widget.initialTransactionType != null &&
        ['deposit', 'withdrawal', 'transfer'].contains(widget.initialTransactionType)) {
      _selectedTransactionType = widget.initialTransactionType!;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    CashBookEntry? entry;

    if (_selectedTransactionType == 'deposit') {
      entry = CashBookEntry(
        // accountId: _selectedAccountId!,
        accountId: int.parse(_selectedAccountId!),

        transactionType: 'deposit',
        credit: amount, // For deposit, it's credit
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );
    } else if (_selectedTransactionType == 'withdrawal') {
      entry = CashBookEntry(
        // accountId: _selectedAccountId!, 
        accountId: int.parse(_selectedAccountId!),

        transactionType: 'withdrawal',
        debit: amount, // For withdrawal, it's debit
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );
      } else if (_selectedTransactionType == 'transfer') {

  if (_selectedFromAccountId == null || _selectedToAccountId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select both accounts')),
    );
    return;
  }

  if (_selectedFromAccountId == _selectedToAccountId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cannot transfer between same account')),
    );
    return;
  }

  try {
    await ref.read(cashBookProvider.notifier).transferMoney(
      fromAccountId: _selectedFromAccountId!,
      toAccountId: _selectedToAccountId!,
      amount: amount,
    );

    await ref.read(accountProvider.notifier).loadAccounts(); // ✅ Refresh balances

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transfer successful ✅')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed: $e')),
    );
  }
  return;
}

    // } else if (_selectedTransactionType == 'transfer') {
      

    //   if (_selectedFromAccountId == _selectedToAccountId) {
    //      ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Source and destination accounts cannot be the same for a transfer.')),
    //     );
    //     return;
    //   }
      

      
    //   try {
        
    //     await ref.read(cashBookProvider.notifier).loadCashBookEntries();
    //       await ref.read(accountProvider.notifier).loadAccounts();


    //     Navigator.of(context).pop();

    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Transfer recorded successfully')),
    //     );
    //   } catch (e) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Failed to record transfer: $e')),
    //     );
    //   }
    //   return; // Exit as transfer handled
    // }

    if (entry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid transaction type selected')),
      );
      return;
    }

    try {
      await ref.read(cashBookProvider.notifier).addEntry(entry);
      await ref.read(cashBookProvider.notifier).loadCashBookEntries();
       // ✅ Refresh Accounts UI too
  await ref.read(accountProvider.notifier).loadAccounts();


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

    return CustomDialog(
      title: "Add Cashbook",
      onSubmit: _submitForm,
      onCancel: () => Navigator.of(context).pop(),
      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. Select Transaction Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedTransactionType,
                decoration: buildInputDecoration("Select Transaction Type"),
                items: const [
                  DropdownMenuItem(value: 'deposit', child: Text('Deposit')),
                  DropdownMenuItem(value: 'withdrawal', child: Text('Withdrawal')),
                  DropdownMenuItem(value: 'transfer', child: Text('Transfer')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedTransactionType = val;
                      // Reset account selections when transaction type changes
                      _selectedAccountId = null;
                      _selectedFromAccountId = null;
                      _selectedToAccountId = null;
                      _amountController.clear(); // Clear amount as well
                    });
                  }
                },
                validator: (val) =>
                    val == null ? 'Please select a transaction type' : null,
              ),
              KHeight16,

              // 2. Conditional Amount Field
              if (_selectedTransactionType != 'transfer') ...[
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: buildInputDecoration(
                      _selectedTransactionType == 'deposit' ? "Credit Amount" : "Debit Amount",
                      suffixIcon: Icons.calculate, // Calculator icon
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(val) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black),
                ),
                KHeight16,
                // 3. Select an Account for Deposit/Withdrawal
                DropdownButtonFormField<String>(
                  value: _selectedAccountId,
                  decoration: buildInputDecoration("Select an Account"),
                  items: accounts
                      .map(
                        (account) => DropdownMenuItem(
                          value: account.id,
                          child: Text(account.name),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() => _selectedAccountId = val);
                  },
                  validator: (val) =>
                      val == null ? 'Please select an account' : null,
                ),
                KHeight16,
              ] else ...[ // If transaction type is 'transfer'
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: buildInputDecoration(
                      "Amount to Transfer",
                      suffixIcon: Icons.calculate,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(val) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                    style: TextStyle(color: Colors.black),
                ),
               KHeight16,
                // Select From Account
                DropdownButtonFormField<String>(
                  value: _selectedFromAccountId,
                  decoration: buildInputDecoration("Select From Account"),
                  items: accounts
                      .map(
                        (account) => DropdownMenuItem(
                          value: account.id,
                          child: Text(account.name),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() => _selectedFromAccountId = val);
                  },
                  validator: (val) =>
                      val == null ? 'Please select a source account' : null,
                ),
               KHeight16,
                // Select To Account
                DropdownButtonFormField<String>(
                  value: _selectedToAccountId,
                  decoration: buildInputDecoration("Select To Account"),
                  items: accounts
                      .where((account) => account.id != _selectedFromAccountId) // Cannot transfer to same account
                      .map(
                        (account) => DropdownMenuItem(
                          value: account.id,
                          child: Text(account.name),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() => _selectedToAccountId = val);
                  },
                  validator: (val) =>
                      val == null ? 'Please select a destination account' : null,
                ),
                KHeight16,
              ],

              // 4. Description Field (always present)
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: buildInputDecoration("Description (Optional)"),
                  style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Assuming buildInputDecoration and KHeight are defined elsewhere or copied below
InputDecoration buildInputDecoration(String hintText, {IconData? suffixIcon}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.grey),
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.blue.shade700),
    ),
    fillColor: Colors.white,
    filled: true,
    suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey) : null,
  );
}
