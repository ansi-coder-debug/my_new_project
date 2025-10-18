/*

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/brokerage/brokerage_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/models/brokerage.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';
import 'package:my_new_project/core/constants/constant.dart';

class BrokerageDialog extends ConsumerStatefulWidget {
  final Brokerage brokerage;
  final bool isViewOnly;

  const BrokerageDialog({
    super.key,
    required this.brokerage,
    this.isViewOnly = false,
  });

  @override
  ConsumerState<BrokerageDialog> createState() => _BrokerageDialogState();
}

class _BrokerageDialogState extends ConsumerState<BrokerageDialog> {
  bool isEdit = false;

  final _amountController = TextEditingController();
  final _paidAmountController = TextEditingController();
  final _remarksController = TextEditingController();

  Vehicle? selectedVehicle;

  @override
  void initState() {
    super.initState();
    isEdit = !widget.isViewOnly;

    _amountController.text = widget.brokerage.amount;
    _paidAmountController.text = widget.brokerage.brokeragePaid ?? '';
    _remarksController.text = widget.brokerage.remarks ?? '';

    // Load vehicle info from vehicleProvider
    final vehicles = ref.read(vehicleProvider).vehicles;
    selectedVehicle = vehicles.firstWhere(
  (v) => v.id.toString() == widget.brokerage.saleId?.toString(),
  orElse: () => vehicles.first, // fallback to any vehicle, or handle as needed
);

  }

  @override
  void dispose() {
    _amountController.dispose();
    _paidAmountController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _updateBrokerage() async {
    final repository = ref.read(brokerageProvider.notifier);

    final updated = Brokerage(
      id: widget.brokerage.id,
      brokerId: widget.brokerage.brokerId,
      brokerName: widget.brokerage.brokerName,
      amount: _amountController.text.trim(),
      brokeragePaid: _paidAmountController.text.trim(),
      remarks: _remarksController.text.trim(),
      paymentStatus: widget.brokerage.paymentStatus,
    );

    await repository.updateBrokerage(updated);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Brokerage updated')),
      );
    }
  }

  Future<void> _deleteBrokerage() async {
    final repository = ref.read(brokerageProvider.notifier);
    await repository.deleteBrokerage(widget.brokerage.id!);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Brokerage deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      width: MediaQuery.of(context).size.width,
      title: widget.isViewOnly ? 'View Brokerage' : 'Edit Brokerage',
      onCancel: () => Navigator.of(context).pop(),
      onSubmit: isEdit ? _updateBrokerage : null,
      bodyContent: Column(
        children: [
          // Vehicle Name & Registration
          TextFormField(
            readOnly: true,
            controller: TextEditingController(
              text: selectedVehicle != null
                  ? '${selectedVehicle!.make} ${selectedVehicle!.model} - ${selectedVehicle!.registrationId}'
                  : 'N/A',
            ),
            decoration: const InputDecoration(
              labelText: 'Vehicle',
            ),
          ),
          KHeight16,

          // Amount
          TextFormField(
            readOnly: !isEdit,
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
            ),
          ),
          KHeight16,

          // Paid Amount
          TextFormField(
            readOnly: !isEdit,
            controller: _paidAmountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Paid Amount',
            ),
          ),
          KHeight16,

          // Remarks
          TextFormField(
            readOnly: !isEdit,
            controller: _remarksController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Remarks',
            ),
          ),
          KHeight16,

          if (isEdit)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: _deleteBrokerage,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: _updateBrokerage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A0A33),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/brokerage/brokerage_provider.dart';
import 'package:my_new_project/application/vehicle/vehicle_provider.dart';
import 'package:my_new_project/core/models/brokerage.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';
import 'package:my_new_project/core/constants/constant.dart';

class BrokerageDialog extends ConsumerStatefulWidget {
  final Brokerage brokerage;
  final bool isViewOnly;

  const BrokerageDialog({
    super.key,
    required this.brokerage,
    this.isViewOnly = false,
  });

  @override
  ConsumerState<BrokerageDialog> createState() => _BrokerageDialogState();
}

class _BrokerageDialogState extends ConsumerState<BrokerageDialog> {
  bool isEdit = false;

  final _amountController = TextEditingController();
  final _paidAmountController = TextEditingController();
  final _remarksController = TextEditingController();

  Vehicle? selectedVehicle;

  @override
  void initState() {
    super.initState();
    isEdit = !widget.isViewOnly;

    _amountController.text = widget.brokerage.amount;
    _paidAmountController.text = widget.brokerage.brokeragePaid ?? '';
    _remarksController.text = widget.brokerage.remarks ?? '';

    // Load vehicle info from provider
    final vehicles = ref.read(vehicleProvider).vehicles;
    selectedVehicle = vehicles.firstWhere(
      (v) => v.id.toString() == widget.brokerage.saleId?.toString(),
      orElse: () => vehicles.first, // fallback to any vehicle, or handle as needed

    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _paidAmountController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _updateBrokerage() async {
    final repository = ref.read(brokerageProvider.notifier);

    final updated = Brokerage(
      id: widget.brokerage.id,
      brokerId: widget.brokerage.brokerId,
      brokerName: widget.brokerage.brokerName,
      amount: _amountController.text.trim(),
      brokeragePaid: _paidAmountController.text.trim(),
      remarks: _remarksController.text.trim(),
      paymentStatus: widget.brokerage.paymentStatus,
      saleId: widget.brokerage.saleId,
    );

    await repository.updateBrokerage(updated);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Brokerage updated')),
      );
    }
  }

  Future<void> _deleteBrokerage() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this brokerage record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      final repository = ref.read(brokerageProvider.notifier);
      await repository.deleteBrokerage(widget.brokerage.id!);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Brokerage deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      width: MediaQuery.of(context).size.width,

      height:MediaQuery.of(context).size.height*0.5,
      title: widget.isViewOnly ? 'View Brokerage' : 'Edit Brokerage',
      onCancel: () => Navigator.of(context).pop(),
      onSubmit: isEdit ? _updateBrokerage : null,
      bodyContent: Column(
        children: [
          // Vehicle Name & Registration
          TextFormField(
            readOnly: true,
             style: TextStyle(color: Colors.black),
            controller: TextEditingController(
              text: selectedVehicle != null
                  ? '${selectedVehicle!.make} ${selectedVehicle!.model} - ${selectedVehicle!.registrationId}'
                  : 'N/A',
            ),
            decoration: buildInputDecoration(
               'Vehicle',
            ),
          ),
          KHeight16,

          // Amount
          TextFormField(
             style: TextStyle(color: Colors.black),
            readOnly: !isEdit,
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: buildInputDecoration(
                  "Amount",
                  icon: Icons.calculate,
                ),
          ),
          KHeight16,

          // Paid Amount
          TextFormField(
             style: TextStyle(color: Colors.black),
            readOnly: !isEdit,
            controller: _paidAmountController,
            keyboardType: TextInputType.number,
           decoration: buildInputDecoration(
                  "Amount",
                  icon: Icons.calculate,
                ),
          ),
          KHeight16,

          // Remarks
          TextFormField(
             style: TextStyle(color: Colors.black),
            readOnly: !isEdit,
            controller: _remarksController,
            maxLines: 2,
            decoration: buildInputDecoration(
              'Remarks',
            ),
          ),
          KHeight16,

          // Show Delete & Update buttons if editable
          if (isEdit)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: _deleteBrokerage,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: _updateBrokerage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A0A33),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
