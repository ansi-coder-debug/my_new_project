import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/application/partner/partner_provider.dart';
import 'package:my_new_project/application/partnership/partnership_form_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart'; // Assuming KHeight and kInputDecoration are defined here
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/partner.dart';
import 'package:my_new_project/widgets/accounts/add_account_dialog.dart';
import 'package:my_new_project/widgets/accounts/edit_account_dialog.dart';
import 'package:my_new_project/widgets/partnerships/add_partner_form.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';
import 'package:uuid/uuid.dart';

class AddPartnershipDetails extends ConsumerStatefulWidget {
  final double purchasePrice; // ← ADD THIS
  final double ownerPaidAmount; // ← ADD THIS
  final List<Partnership> existingPartnerships; // ← ADD THIS
  

  const AddPartnershipDetails({
    Key? key,
    required this.purchasePrice, // ← ADD
    required this.ownerPaidAmount, // ← ADD
    required this.existingPartnerships, 
  }) : super(key: key);

  @override
  ConsumerState<AddPartnershipDetails> createState() =>
      _AddPartnershipDetailsState();
}

class _AddPartnershipDetailsState extends ConsumerState<AddPartnershipDetails> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(partnerProvider.notifier).loadPartners();
      ref.read(accountProvider.notifier).loadAccounts(); // Load accounts
      ref
          .read(partnershipFormProvider.notifier)
          .updatePurchasePrice(widget.purchasePrice);
    });
  }

  @override
  Widget build(BuildContext context) {
    final partners = ref.watch(partnerProvider).partners;
    final formState = ref.watch(partnershipFormProvider);
    final selectedPartner = ref.watch(selectedPartnerProvider);
    final accounts = ref.watch(accountProvider).accounts;

   // Calculate remaining balance for partnership contribution
final totalPurchaseAmount = widget.purchasePrice;

// Calculate total purchase amount and total paid by owner
final totalOwnerPaid = widget.ownerPaidAmount;

// Calculate sum of existing partner contributions
final existingPartnerContributions = widget.existingPartnerships
    .fold<double>(0.0, (sum, p) => sum + (double.tryParse(p.contribution ?? '0') ?? 0.0));

// ✅ FIXED: Remaining balance should be (Total Purchase - Owner Paid) - Existing Partner Contributions
final remainingBalanceForContribution = 
    (totalPurchaseAmount - totalOwnerPaid) - existingPartnerContributions;

    return CustomDialog(
      submitButtonText: 'Save Partner',
      title: "Add Partnership Details",
      onCancel: () => Navigator.pop(context),
      onSubmit: () {
        final error = ref.read(partnershipFormProvider).errorMessage;
        if (error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
          return;
        }

        if (!_formKey.currentState!.validate()) return;

        final form = ref.read(partnershipFormProvider);
        final currentSelectedAccount = ref
            .read(accountProvider)
            .selectedAccount;
        final partner = ref.read(selectedPartnerProvider);

        if (partner == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a partner')),
          );
          return;
        }

        if (currentSelectedAccount == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select an account')),
          );
          return;
        }

        final newPartnership = Partnership(
          id: const Uuid().v4(),
          partnerName: partner.name,
          partner: partner,
contribution: form.contributionAmount?.toString() ?? '0',
contributionPaid: form.contributionPaid?.toString() ?? '',
fromAccount: int.tryParse(currentSelectedAccount.id?.toString() ?? '0') ?? 0,
          accountName: currentSelectedAccount.name,
          vehicleId: '',
          paymentMode: currentSelectedAccount.type,
contributionStatus: (form.contributionPaid ?? 0) == 0
    ? 'unpaid'
    : (form.contributionPaid ?? 0) < (form.contributionAmount ?? 0)
        ? 'partial'
        : 'paid',
        );

        // ref
        //     .read(vehicleProvider.notifier)
        //     .addPartnershipToVehicle(widget.vehicleId, newPartnership);

        // Deduct paid amount from selected account
        final updatedAccount = currentSelectedAccount.copyWith(
          amount:
              currentSelectedAccount.amount - (form.contributionPaid ?? 0.0),
        );
        ref.read(accountProvider.notifier).updateAccount(updatedAccount);

      // Clear form after save
ref.read(partnershipFormProvider.notifier).resetForm();

// ✅ Return new partnership to parent
Navigator.pop(context, newPartnership);

      },
      bodyContent: Form(
        key: _formKey,
        child: Column(
          children: [
            // Select a Partner Dropdown
            Autocomplete<Partner>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                final query = textEditingValue.text.trim();
                if (query.isEmpty) return partners;
                final filtered = partners.where((Partner partner) {
                  return partner.name.toLowerCase().contains(
                    query.toLowerCase(),
                  );
                }).toList();
                if (filtered.isEmpty) {
                  return [Partner(name: '+ Add "$query"', id: '', address: '')];
                }
                return filtered;
              },
              displayStringForOption: (Partner p) => p.name,
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final partner = options.elementAt(index);
                          return ListTile(
                            title: Text(
                              partner.name,
                              style: const TextStyle(color: Colors.black),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.black),
                              onPressed: () {
                                debugPrint('Tapped info for ${partner.name}');
                              },
                            ),
                            onTap: () => onSelected(partner),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              onSelected: (Partner partner) async {
                if (partner.name.startsWith('+ Add')) {
                  final newName = partner.name
                      .replaceAll('+ Add "', '')
                      .replaceAll('"', '');
                  await showDialog(
                    context: context,
                    builder: (_) => AddPartnerForm(
                      partner: Partner(name: newName, id: '', address: ''),
                    ),
                  );
                  await ref.read(partnerProvider.notifier).loadPartners();
                } else {
                  ref.read(selectedPartnerProvider.notifier).state = partner;
                }
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                    return TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller: controller,
                      focusNode: focusNode,
                      decoration: kInputDecoration.copyWith(
                        hintText: 'Select a Partner',
                      ),
                      validator: (value) => selectedPartner == null
                          ? "Please select a partner"
                          : null,
                    );
                  },
            ),
            KHeight,

            // Partner Contribution (INR)
            TextFormField(
              enabled: selectedPartner != null, // Enable if partner is selected
              decoration: kInputDecoration.copyWith(
                hintText: 'Partner Contribution (INR)',
                suffixIcon: const Icon(Icons.calculate, color: Colors.black),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
              initialValue: formState.contributionAmount?.toString() ?? '',
              onChanged: (value) {
                final amount = double.tryParse(value);
                if (amount != null &&
                    amount > remainingBalanceForContribution) {
                  ref
                      .read(partnershipFormProvider.notifier)
                      .updateContributionAmount(
                        remainingBalanceForContribution,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Contribution capped. The remaining amount for contribution is ₹${remainingBalanceForContribution.toStringAsFixed(2)}',
                      ),
                    ),
                  );
                } else {
                  ref
                      .read(partnershipFormProvider.notifier)
                      .updateContributionAmount(amount);
                }
              },
              validator: (val) {
                if (selectedPartner == null)
                  return null; // No validation if disabled
                if (val == null || val.trim().isEmpty) {
                  return 'Contribution amount required';
                }
                if (double.tryParse(val.trim()) == null) {
                  return 'Enter a valid number';
                }
                return null;
              },
            ),

            KHeight,

            // Contribution Paid Amount
            TextFormField(
              enabled: formState
                  .isContributionAmountValid, // Enable if contribution is valid
              decoration: kInputDecoration.copyWith(
                hintText: 'Contribution Paid Amount',
                suffixIcon: const Icon(Icons.calculate, color: Colors.black),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
              initialValue: formState.contributionPaid?.toString() ?? '',
              onChanged: (value) {
                final paid = double.tryParse(value);
                final contribution = formState.contributionAmount ?? 0;

                  // If user enters something invalid or empty, just update normally
    if (paid == null) {
      ref.read(partnershipFormProvider.notifier).updateContributionPaid(null);
      return;
    }

     // ✅ Prevent typing more than contribution
    if (paid > contribution) {
      // Immediately reset text to max allowed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = TextEditingController(
          text: contribution.toStringAsFixed(2),
        );
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
        FocusScope.of(context).unfocus(); // remove focus
      });
       // Show message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Paid amount cannot exceed contribution (₹${contribution.toStringAsFixed(2)})',
          ),
        ),
      );

      // Update provider to cap it
      ref
          .read(partnershipFormProvider.notifier)
          .updateContributionPaid(contribution);
    } else {
      ref
          .read(partnershipFormProvider.notifier)
          .updateContributionPaid(paid);
    }
  

                // if (paid != null && paid > contribution) {
                //   ref
                //       .read(partnershipFormProvider.notifier)
                //       .updateContributionPaid(contribution);
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text(
                //         'Paid amount cannot be greater than contribution',
                //       ),
                //     ),
                //   );
                // } else {
                //   ref
                //       .read(partnershipFormProvider.notifier)
                //       .updateContributionPaid(paid);
                // }
              },
              validator: (val) {
                if (!formState.isContributionAmountValid)
                  return null; // No validation if disabled
                if (val == null || val.trim().isEmpty) {
                  return 'Paid amount required';
                }
                if (double.tryParse(val.trim()) == null) {
                  return 'Enter a valid number';
                }
                final contribution = formState.contributionAmount ?? 0;
                final paid = double.tryParse(val.trim()) ?? 0;
                if (paid > contribution) {
                  return 'Paid cannot be greater than contribution';
                }
                return null;
              },
            ),

            KHeight,

            // From Account
            Autocomplete<Account>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (!formState.isContributionPaidValid)
                  return Iterable<
                    Account
                  >.empty(); // Disable options if not enabled

                final query = textEditingValue.text.trim();
                if (query.isEmpty) return accounts;
                final filtered = accounts.where((a) {
                  return a.name.toLowerCase().contains(query.toLowerCase());
                }).toList();
                if (filtered.isEmpty) {
                  return [
                    Account(name: '+ Add "$query"', type: 'cash', amount: 0.0),
                  ];
                }
                return filtered;
              },
              displayStringForOption: (Account a) => a.name,
              onSelected: (Account selected) async {
                if (selected.name.startsWith('+ Add')) {
                  final newName = selected.name
                      .replaceAll('+ Add "', '')
                      .replaceAll('"', '');
                  await showDialog(
                    context: context,
                    builder: (_) => AddAccountDialog(initialName: newName),
                  );
                  await ref.read(accountProvider.notifier).loadAccounts();
                } else {
                  ref
                      .read(accountProvider.notifier)
                      .setSelectedAccount(selected);
                  ref
                      .read(partnershipFormProvider.notifier)
                      .updateFromAccountName(selected.name);
                }
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                    final formState = ref.watch(partnershipFormProvider);
                    final selectedAccount = ref
                        .watch(accountProvider)
                        .selectedAccount;
                    // Update controller text from selected account directly if available
                    controller.text = selectedAccount?.name ?? '';

                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      style: const TextStyle(color: Colors.black),
                      enabled: formState
                          .isContributionPaidValid, // Enable if paid is valid
                      decoration: kInputDecoration.copyWith(
                        hintText: 'From Account',
                      ),
                      validator: (val) {
                        if (!formState.isContributionPaidValid)
                          return null; // No validation if disabled
                        if (ref.read(accountProvider).selectedAccount == null) {
                          return 'From Account is required';
                        }
                        return null;
                      },
                    );
                  },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final account = options.elementAt(index);
                          final isAddOption = account.name.startsWith('+ Add');

                          return ListTile(
                            title: Text(
                              account.name,
                              style: const TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: isAddOption
                                ? null
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '₹${account.amount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (_) => EditAccountDialog(
                                              account: account,
                                            ),
                                          );
                                          await ref
                                              .read(accountProvider.notifier)
                                              .loadAccounts();
                                        },
                                      ),
                                    ],
                                  ),
                            onTap: () {
                              if (!isAddOption) onSelected(account);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),

            if (formState.errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                formState.errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
