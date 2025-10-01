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
