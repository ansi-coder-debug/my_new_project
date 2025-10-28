/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class EditAccountDialog extends ConsumerStatefulWidget {
  final Account account;
  final bool isViewMode;

  const EditAccountDialog({
    Key? key,
    required this.account,
    this.isViewMode = false,
  }) : super(key: key);

  @override
  ConsumerState<EditAccountDialog> createState() => _EditAccountDialogState();
}

class _EditAccountDialogState extends ConsumerState<EditAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _selectedType;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account.name);
    _selectedType = widget.account.type;
    _descriptionController = TextEditingController(text: widget.account.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedAccount = widget.account.copyWith(
      name: _nameController.text.trim(),
      type: _selectedType,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    try {
      await ref.read(accountProvider.notifier).updateAccount(updatedAccount);
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update account: $e')),
      );
    }
  }

  void _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete this account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(accountProvider.notifier).deleteAccount(widget.account.id!);
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      height: MediaQuery.of(context).size.height * 0.48,
      title: widget.isViewMode ? "View Account" : "Edit Account",
      onSubmit: widget.isViewMode ? null : _submitForm,
      onCancel: () => Navigator.of(context).pop(),
      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Account Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   "Account Name",
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.w400,
                  //     color: Colors.black,
                  //   ),
                  // ),
                 Kheight6,
                  TextFormField(
                    controller: _nameController,
                    decoration: buildInputDecoration("e.g. Main Cash, HDFC Bank"),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter account name';
                      }
                      return null;
                    },
                    readOnly: widget.isViewMode,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
              KHeight,
          
              // Type Dropdown
              // const Text(
              //   "Account Type",
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.w400,
              //     color: Colors.black,
              //   ),
              // ),
              // const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: buildInputDecoration("Select Account Type"),
                items: const [
                  DropdownMenuItem(value: 'cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'bank', child: Text('Bank')),
                ],
                onChanged: widget.isViewMode ? null : (val) {
                  if (val != null) setState(() => _selectedType = val);
                },
              ),
              KHeight16,

              
// ✅ NEW Current Balance Field (Always shown & readonly)
TextFormField(
  initialValue: widget.account.amount.toStringAsFixed(2),
  readOnly: true,
  enabled: false,
  decoration: buildInputDecoration("Current Balance"),
  style: const TextStyle(color: Colors.black, fontSize: 14),
),
KHeight16,
          
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: buildInputDecoration("Description (Optional)"),
                maxLines: 2,
                readOnly: widget.isViewMode,
                style: const TextStyle(color: Colors.black),
              ),

              // // Current Balance (View Only)
              // if (widget.isViewMode) ...[
              //   KHeight16,
              //   const SizedBox(height: 6),
              //   Container(
              //     width: double.infinity,
              //     padding: const EdgeInsets.all(12),
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Colors.grey.shade300),
              //       borderRadius: BorderRadius.circular(4),
              //     ),
              //     child: Text(
              //       '₹${widget.account.amount.toStringAsFixed(2)}',
              //       style: const TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ],

              // // Delete Button (Only in edit mode, not view mode)
              // if (!widget.isViewMode) ...[
              //   KHeight16,
              //   SizedBox(
              //     width: double.infinity,
              //     child: OutlinedButton.icon(
              //       onPressed: _deleteAccount,
              //       style: OutlinedButton.styleFrom(
              //         side: const BorderSide(color: Colors.red),
              //         padding: const EdgeInsets.symmetric(vertical: 12),
              //       ),
              //       icon: const Icon(Icons.delete, color: Colors.red, size: 18),
              //       label: const Text(
              //         'Delete Account',
              //         style: TextStyle(color: Colors.red),
              //       ),
              //     ),
              //   ),
              // ],
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
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/application/navigation/navigation_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/widgets/cashbook/add_cashbook_dialog.dart';
import 'package:my_new_project/widgets/expense/add_expense_dialog.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class EditAccountDialog extends ConsumerStatefulWidget {
  final Account account;
  final bool isViewMode;

  const EditAccountDialog({
    Key? key,
    required this.account,
    this.isViewMode = false,
  }) : super(key: key);

  @override
  ConsumerState<EditAccountDialog> createState() => _EditAccountDialogState();
}

class _EditAccountDialogState extends ConsumerState<EditAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _selectedType;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account.name);
    _selectedType = widget.account.type;
    _descriptionController = TextEditingController(
      text: widget.account.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedAccount = widget.account.copyWith(
      name: _nameController.text.trim(),
      type: _selectedType,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    try {
      await ref.read(accountProvider.notifier).updateAccount(updatedAccount);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update account: $e')));
    }
  }

  void _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete this account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(accountProvider.notifier)
            .deleteAccount(widget.account.id!);
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete account: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      height:
          MediaQuery.of(context).size.height *
          0.6, // Increased height to accommodate new buttons
      title: widget.isViewMode ? "View Account" : "Edit Account",
      onSubmit: widget.isViewMode ? null : _submitForm,
      onCancel: () => Navigator.of(context).pop(),
        onDelete: widget.isViewMode ? null : _deleteAccount, // ✅ IMPORTANT

      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Deposit, Withdrawal, Show Transactions Buttons
              // if (!widget.isViewMode) ...[
                // Only show in edit mode
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed:widget.isViewMode
            ? null // Disable in view mode
            :
                         () {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (context) => AddCashBookDialog(
                              // isDeposit = true
                              //  account: widget.account, // pass selected account
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade500,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Deposit',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.isViewMode
            ? null
            : () {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (context) => AddCashBookDialog(
                              // account: widget.account, // pass selected account
                              // isDeposit: true,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade500,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Withdrawal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                KHeight16,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:widget.isViewMode
            ? null
            :  () {
                      Navigator.of(context).pop();
                      ref.read(navigationProvider.notifier).selectPage(7);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Dark blue
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Show Transactions',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                KHeight16,
              // ],

              // Account Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Kheight6,
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
                    readOnly: widget.isViewMode,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
              KHeight,

              // Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: buildInputDecoration("Select Account Type"),
                items: const [
                  DropdownMenuItem(value: 'cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'bank', child: Text('Bank')),
                ],
                onChanged: widget.isViewMode
                    ? null
                    : (val) {
                        if (val != null) setState(() => _selectedType = val);
                      },
              ),
              KHeight16,

              // Current Balance Field (Always shown & readonly)
              TextFormField(
                initialValue: widget.account.amount.toStringAsFixed(2),
                readOnly: true,
                enabled: false,
                decoration: buildInputDecoration("Current Balance"),
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
              KHeight16,

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: buildInputDecoration("Description (Optional)"),
                maxLines: 2,
                readOnly: widget.isViewMode,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),

    );
  }
}

// Assuming buildInputDecoration and KHeight/KHeight16/Kheight6 are defined elsewhere
InputDecoration buildInputDecoration(String hintText) {
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
  );
}
