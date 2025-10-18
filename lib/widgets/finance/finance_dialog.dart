import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/application/finance/finance_provider.dart';
import 'package:my_new_project/application/financier/financier_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/core/models/finance.dart';
import 'package:my_new_project/core/models/financier.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class AddFinanceDialog extends ConsumerStatefulWidget {
  final Finance? finance;
  final bool isViewOnly;

  const AddFinanceDialog({
    super.key,
    this.finance,
    this.isViewOnly = false,
  });

  @override
  ConsumerState<AddFinanceDialog> createState() => _AddFinanceDialogState();
}

class _AddFinanceDialogState extends ConsumerState<AddFinanceDialog> {
  bool isEdit = false;
  bool get isViewOnly => widget.isViewOnly;

  final _formKey = GlobalKey<FormState>();

  Financier? selectedFinancier;
  Account? selectedAccount;

  final _amountController = TextEditingController();
  final _paidAmountController = TextEditingController();

@override
void initState() {
  super.initState();

  if (widget.finance != null) {
    final f = widget.finance!;
    _amountController.text = f.amount.toString();
    _paidAmountController.text = f.receivedPrice.toString();
    isEdit = !widget.isViewOnly;

    Future.delayed(Duration.zero, () {
      final financiers = ref.read(financierProvider).financiers;
      final accounts = ref.read(accountProvider).accounts;

      setState(() {
        selectedFinancier = financiers.firstWhere(
          (fin) => fin.id.toString() == f.financier?.id.toString(),
          orElse: () => financiers.first,
        );

        selectedAccount = accounts.firstWhere(
          (a) => int.tryParse(a.id ?? '') == f.accountId,
          orElse: () {
            print('⚠️ No match found for account_id: ${f.accountId}');
            return accounts.first;
          },
        );

      });
    });
  }
}


  @override
  void dispose() {
    _amountController.dispose();
    _paidAmountController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final double amount = double.parse(_amountController.text.trim());
      final double paid = double.parse(_paidAmountController.text.trim());

    final finance = Finance(
  id: widget.finance?.id ?? '',
  vehicleId: widget.finance?.vehicleId ?? '',
  toAccount: selectedAccount?.id?.toString() ?? '',  // ✅ Fix: convert int to String
  paymentStatus: paid == amount
      ? 'paid'
      : (paid == 0 ? 'pending' : 'partial'),
  amount: amount,
  receivedPrice: paid,
  financier: selectedFinancier,
  accountId: selectedAccount?.id != null
    ? int.tryParse(selectedAccount!.id!)
    : null,
                   // ✅ already int
  accountName: selectedAccount?.name,
);



      final notifier = ref.read(financeProvider.notifier);

      if (widget.finance != null) {
        await notifier.updateFinance(finance);
      } else {
        await notifier.addFinance(finance);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.finance != null ? 'Finance updated' : 'Finance added',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final financierState = ref.watch(financierProvider);
    final accountState = ref.watch(accountProvider);

    return CustomDialog(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.5,
      title: isViewOnly
          ? "View Finance"
          : (widget.finance != null ? "Edit Finance" : "Add Finance"),
      onSubmit: isViewOnly ? null : () => _submitForm(),
      onCancel: () => Navigator.of(context).pop(),
      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Financier Dropdown
              DropdownButtonFormField<Financier>(
                value: selectedFinancier,
                decoration: buildInputDecoration("Select Financier"),
                items: financierState.financiers.map((fin) {
                  return DropdownMenuItem(
                    value: fin,
                    child: Text(fin.companyName),
                  );
                }).toList(),
                onChanged: isViewOnly
                    ? null
                    : (val) => setState(() => selectedFinancier = val),
                validator: (val) =>
                    val == null ? 'Please select financier' : null,
              ),
              KHeight16,

              // Account Dropdown
              DropdownButtonFormField<Account>(
                value: selectedAccount,
                decoration: buildInputDecoration("Select Account"),
                items: accountState.accounts.map((account) {
                  return DropdownMenuItem(
                    value: account,
                    child: Text(account.name),
                  );
                }).toList(),
                onChanged: isViewOnly
                    ? null
                    : (val) => setState(() => selectedAccount = val),
                validator: (val) =>
                    val == null ? 'Please select account' : null,
              ),
              KHeight16,

              // Amount
              TextFormField(
                controller: _amountController,
                style: const TextStyle(color: Colors.black),
                enabled: !isViewOnly,
                keyboardType: TextInputType.number,
                decoration: buildInputDecoration(
                  "Amount",
                  icon: Icons.calculate,
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter amount' : null,
              ),
              KHeight16,

              // Paid Amount
              TextFormField(
                controller: _paidAmountController,
                style: const TextStyle(color: Colors.black),
                enabled: !isViewOnly,
                keyboardType: TextInputType.number,
                decoration: buildInputDecoration(
                  "Paid Amount",
                  icon: Icons.calculate,
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter paid amount' : null,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
