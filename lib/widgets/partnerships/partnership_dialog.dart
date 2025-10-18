import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/accounts/account_provider.dart';
import 'package:my_new_project/application/partnership/partnership_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/account.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class AddPartnershipDialog extends ConsumerStatefulWidget {
  final Partnership? partnership;
  final bool isViewOnly;

  const AddPartnershipDialog({
    super.key,
    this.partnership,
    this.isViewOnly = false,
  });

  @override
  ConsumerState<AddPartnershipDialog> createState() =>
      _AddPartnershipDialogState();
}

class _AddPartnershipDialogState extends ConsumerState<AddPartnershipDialog> {
  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;
  bool get isViewOnly => widget.isViewOnly;

  final _contributionController = TextEditingController();
  final _paidController = TextEditingController();
  final _profitShareController = TextEditingController();

  Account? selectedAccount;
  Vehicle? selectedVehicle; // NEW
final _vehicleController = TextEditingController();
  @override
  void initState() {
    super.initState();

    if (widget.partnership != null) {
      final p = widget.partnership!;
      _contributionController.text = p.contribution ?? '';
      _paidController.text = p.contributionPaid ?? '';
      _profitShareController.text = p.sharePercentage ?? '';
      isEdit = !isViewOnly;

      Future.delayed(Duration.zero, () {
        final accounts = ref.read(accountProvider).accounts;
              final vehicles = ref.read(vehicleProvider).vehicles;
                print('🛠 Vehicles Loaded: ${vehicles.map((v) => '${v.id} ${v.make} ${v.model}').toList()}');



        setState(() {
          // Find the account object matching fromAccount
          selectedAccount = accounts.firstWhere(
            (a) => int.tryParse(a.id ?? '') == p.fromAccount,
            orElse: () => accounts.first,
          );


       selectedVehicle = vehicles.firstWhere(
  (v) => v.id.toString() == (widget.partnership?.vehicleId ?? ''),
  orElse: () => vehicles.first,
);
 _vehicleController.text = selectedVehicle != null
            ? '${selectedVehicle!.make} ${selectedVehicle!.model}'
            : 'N/A';

            print('🛠 Selected Vehicle: ${selectedVehicle?.make} ${selectedVehicle?.model}');

        });
      });
    }
  }

  @override
  void dispose() {
    _contributionController.dispose();
    _paidController.dispose();
    _profitShareController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final accounts = ref.read(accountProvider).accounts;

    final partnership = Partnership(
      id: widget.partnership?.id,
      vehicleId: widget.partnership?.vehicleId,
      partnerName: widget.partnership?.partnerName,
      contribution: _contributionController.text,
      sharePercentage: _profitShareController.text,
      fromAccount: selectedAccount != null ? int.tryParse(selectedAccount!.id!) : null,
      accountName: selectedAccount?.name ?? '',
      contributionStatus: widget.partnership?.contributionStatus,
      paymentMode: widget.partnership?.paymentMode,
      partner: widget.partnership?.partner,
      contributionPaid: _paidController.text,
      
    );

    final notifier = ref.read(partnershipProvider.notifier);
    if (widget.partnership != null) {
      await notifier.updatePartnership(partnership);
    } else {
      await notifier.addPartnership(partnership);
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.partnership != null
              ? 'Partnership updated'
              : 'Partnership added'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountProvider);

    return CustomDialog(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.6,
      title: isViewOnly
          ? "View Partnership"
          : (widget.partnership != null ? "Edit Partnership" : "Add Partnership"),
      onSubmit: isViewOnly ? null : _submitForm,
      onCancel: () => Navigator.of(context).pop(),
      bodyContent: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Vehicle Info (Display only)
     TextFormField(
  controller: _vehicleController,
  style: const TextStyle(color: Colors.black),
  decoration: buildInputDecoration("Vehicle"),
  enabled: false, // keeps it read-only
),


              KHeight16,

              // Contribution
              TextFormField(
                controller: _contributionController,
                style: const TextStyle(color: Colors.black),
                decoration: buildInputDecoration("Contribution"),
                enabled: !isViewOnly,
              ),
              KHeight16,

              // Contribution Paid
              TextFormField(
                controller: _paidController,
                style: const TextStyle(color: Colors.black),
                decoration: buildInputDecoration("Contribution Paid"),
                enabled: !isViewOnly,
              ),
              KHeight16,

              // Profit Share
              TextFormField(
                controller: _profitShareController,
                style: const TextStyle(color: Colors.black),
                decoration: buildInputDecoration("Profit Share %"),
                enabled: !isViewOnly,
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter profit share' : null,
              ),
              KHeight16,

              // From Account Dropdown
              DropdownButtonFormField<Account>(
                value: selectedAccount,
                decoration: buildInputDecoration("From Account"),
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

              // Contribution Status
              TextFormField(
                 style: const TextStyle(color: Colors.black),
                initialValue: widget.partnership?.contributionStatus ?? '',
                decoration: buildInputDecoration("Contribution Status"),
                enabled: false,
              ),
              KHeight16,

              // Profit Share Payment Status
              TextFormField(
                 style: const TextStyle(color: Colors.black),
                initialValue: widget.partnership?.paymentMode ?? '',
                decoration: buildInputDecoration("Profit Share Payment Status"),
                enabled: false,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
