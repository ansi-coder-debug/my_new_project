import 'package:dropdown_search/dropdown_search.dart';
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
  final String vehicleId;

  const AddPartnershipDetails({Key? key, required this.vehicleId})
    : super(key: key);

  @override
  ConsumerState<AddPartnershipDetails> createState() =>
      _AddPartnershipDetailsState();
}

class _AddPartnershipDetailsState extends ConsumerState<AddPartnershipDetails> {
  final _formKey = GlobalKey<FormState>();

  Partner? selectedPartner;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(partnerProvider.notifier).loadPartners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final partners = ref.watch(partnerProvider).partners;
    final selectedPartner = ref.watch(selectedPartnerProvider);
    final formState = ref.watch(partnershipFormProvider);

//     final vehicle = ref.read(vehicleProvider).vehicles.firstWhere(
//   (v) => v.id == widget.vehicleId,
// );
// final purchaseAmount = double.tryParse(vehicle.purchaseAmount ?? '0') ?? 0;




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
        final selectedAccount = ref.read(accountProvider).selectedAccount;
        final partner = ref.read(selectedPartnerProvider);

        if (partner == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a partner')),
          );
          return;
        }

        final newPartnership = Partnership(
          id: const Uuid().v4(),
          partnerName: partner.name,
          partner: partner,
          contribution: form.contributionAmount?.toString() ?? '',
          contributionPaid: form.contributionPaid?.toString() ?? '',
          fromAccount: selectedAccount != null
              ? int.parse(selectedAccount.id!)
              : 0,
          accountName: selectedAccount?.name,
          vehicleId: widget.vehicleId,
          paymentMode: selectedAccount?.type,
          contributionStatus: '', // handle in next step
        );

        ref
            .read(vehicleProvider.notifier)
            .addPartnershipToVehicle(widget.vehicleId, newPartnership);

        // ✅ Clear form after save
        ref.read(partnershipFormProvider.notifier).resetForm();

        Navigator.pop(context);
      },

      bodyContent: Form(
        key: _formKey,
        child: Column(
          children: [
            // Select a Partner Dropdown
            Autocomplete<Partner>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                final query = textEditingValue.text.trim();

                // 👇 Show all partners when user just taps (no text yet)
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
                              style: const TextStyle(
                                color: Colors.black, // ✅ text stays black
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.edit, // or any icon you want
                                color: Colors.black, // ✅ icon also black
                              ),
                              onPressed: () {
                                // Optional: handle icon tap (like showing details)
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

                  // 👇 Directly open your AddPartnerForm dialog here
                  await showDialog(
                    context: context,
                    builder: (_) => AddPartnerForm(
                      partner: Partner(name: newName, id: '', address: ''),
                    ),
                  );

                  // Reload partners after adding
                  await ref.read(partnerProvider.notifier).loadPartners();
                } else {
                  ref.read(selectedPartnerProvider.notifier).state = partner;
                }
              },

              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                    return TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: controller,
                      focusNode: focusNode,
                      decoration: kInputDecoration.copyWith(
                        hintText: 'Select a Partner',
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Please select a partner"
                          : null,
                    );
                  },
            ),
            KHeight,

            // Partner Contribution (INR)
            TextFormField(
             
              decoration: kInputDecoration.copyWith(
                hintText: 'Partner Contribution (INR)',
                suffixIcon: const Icon(Icons.calculate, color: Colors.black),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
              initialValue: formState.contributionAmount?.toString() ?? '',
              onChanged: (value) {
                final amount = double.tryParse(value);
                ref
                    .read(partnershipFormProvider.notifier)
                    .updateContributionAmount(amount);
              },
              validator: (val) {
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
               enabled: formState.isContributionAmountValid,
              decoration: kInputDecoration.copyWith(
                hintText: 'Contribution Paid Amount',
                suffixIcon: const Icon(Icons.calculate, color: Colors.black),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
              initialValue: formState.contributionPaid?.toString() ?? '',
              onChanged: (value) {
                final paid = double.tryParse(value);
                ref
                    .read(partnershipFormProvider.notifier)
                    .updateContributionPaid(paid);
              },
              validator: (val) {
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
                final accounts = ref.watch(accountProvider).accounts;
                final query = textEditingValue.text.trim();

                // 👇 Show all accounts when user just taps
                if (query.isEmpty) return accounts;

                // 👇 Filter existing accounts by name
                final filtered = accounts.where((a) {
                  return a.name.toLowerCase().contains(query.toLowerCase());
                }).toList();

                // 👇 If no match, show "+ Add" option
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
                  // 👇 Extract the typed name
                  final newName = selected.name
                      .replaceAll('+ Add "', '')
                      .replaceAll('"', '');

                  // 👇 Open Add Account Dialog
                  await showDialog(
                    context: context,
                    builder: (_) => AddAccountDialog(initialName: newName),
                  );

                  // 👇 Reload accounts after adding
                  await ref.read(accountProvider.notifier).loadAccounts();
                } else {
                  // 👇 Update selected account provider
                  ref
                      .read(accountProvider.notifier)
                      .setSelectedAccount(selected);

                  // 👇 Store account name in Riverpod form state
                  ref
                      .read(partnershipFormProvider.notifier)
                      .updateFromAccountName(selected.name);
                }
              },

              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                    // 👇 Sync controller text with provider state
                    final formState = ref.watch(partnershipFormProvider);
                    controller.text = formState.fromAccountName ?? '';

                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      style: const TextStyle(color: Colors.black),
                      enabled: formState.isContributionPaidValid,
                      decoration: kInputDecoration.copyWith(
                        hintText: 'From Account',
                       
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
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
                                                        overflow: TextOverflow.ellipsis, // ✅ prevent overflow

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










































/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/partner/partner_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';

import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/partner.dart';
import 'package:uuid/uuid.dart';

class AddPartnershipDetails extends ConsumerStatefulWidget {
  final String vehicleId;
  const AddPartnershipDetails({Key? key, required this.vehicleId})
    : super(key: key);

  @override
  ConsumerState<AddPartnershipDetails> createState() =>
      _AddPartnershipDetailsState();
}

class _AddPartnershipDetailsState extends ConsumerState<AddPartnershipDetails> {
  final _formKey = GlobalKey<FormState>();

  Partner? selectedPartner;
  final TextEditingController contributionController = TextEditingController();
  final TextEditingController profitShareController = TextEditingController();
  String? paymentMode;
  String? contributionStatus;
  String? profitShareStatus;

  final List<String> paymentModes = ['Cash', 'Bank Transfer'];
  final List<String> contributionStatuses = ['Paid', 'Pending', 'Partial'];
  final List<String> profitShareStatuses = ['Paid', 'Pending', 'Partial'];

  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(partnerProvider.notifier).loadPartners();
  });
}


  @override
  Widget build(BuildContext context) {
    final partners = ref.watch(partnerProvider).partners;
    print('Partners List: $partners');

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Partnership Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // Partner Dropdown
                DropdownButtonFormField<Partner>(
                  value: selectedPartner,
                  decoration: InputDecoration(
                    labelText: 'Select a Partner',
                    border: OutlineInputBorder(),
                  ),
                  items: partners.map((partner) {
                    return DropdownMenuItem<Partner>(
                      value: partner,
                      child: Text(partner.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPartner = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a partner';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Contribution
                TextFormField(
                  controller: contributionController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Partner Contribution (INR)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter contribution amount';
                    }
                    if (double.tryParse(val.trim()) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Payment Mode
                DropdownButtonFormField<String>(
                  value: paymentMode,
                  decoration: InputDecoration(
                    labelText: 'Partner Payment Mode',
                    border: OutlineInputBorder(),
                  ),
                  items: paymentModes
                      .map(
                        (mode) => DropdownMenuItem<String>(
                          value: mode,
                          child: Text(mode),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      paymentMode = val;
                    });
                  },
                  validator: (val) => val == null || val.isEmpty
                      ? 'Please select payment mode'
                      : null,
                ),
                const SizedBox(height: 12),

                // Contribution Status
                DropdownButtonFormField<String>(
                  value: contributionStatus,
                  decoration: InputDecoration(
                    labelText: 'Contribution Status',
                    border: OutlineInputBorder(),
                  ),
                  items: contributionStatuses
                      .map(
                        (status) => DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      contributionStatus = val;
                    });
                  },
                  validator: (val) => val == null || val.isEmpty
                      ? 'Please select contribution status'
                      : null,
                ),
                const SizedBox(height: 12),

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    KHeight16,
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final newPartnership = Partnership(
                            id: const Uuid().v4(),
                            partnerName: selectedPartner?.name??'',
                            partner: selectedPartner,
                            contribution: contributionController.text.trim(),
                             vehicleId: widget.vehicleId,
                            paymentMode: paymentMode!,
                            contributionStatus: contributionStatus!,
                          );

                          // Add to provider
                          // ref
                          //     .read(vehicleProvider.notifier)
                          //     .addPartnership(widget.vehicleId, newPartnership);

                          // Return the new partnership to the parent screen
                          Navigator.of(context).pop(newPartnership);
                        }
                      },
                      child: Text('Save Partner'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/