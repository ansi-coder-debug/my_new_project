import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/models/brokerage.dart';
import 'package:my_new_project/core/models/vehicle.dart';

enum DialogMode { view, edit }

class BrokerageDialog extends ConsumerStatefulWidget {
  final Brokerage brokerage;
  final Vehicle vehicle;
  final DialogMode mode;

  const BrokerageDialog({
    Key? key,
    required this.brokerage,
    required this.vehicle,
    this.mode = DialogMode.view,
  }) : super(key: key);

  @override
  ConsumerState<BrokerageDialog> createState() => _BrokerageDialogState();
}

class _BrokerageDialogState extends ConsumerState<BrokerageDialog> {
  late TextEditingController _brokerNameController;
  late TextEditingController _amountController;
  late TextEditingController _paidController;
  late TextEditingController _remarksController;

  bool get isViewMode => widget.mode == DialogMode.view;

  @override
  void initState() {
    super.initState();

    _brokerNameController = TextEditingController(text: widget.brokerage.brokerName);
    _amountController = TextEditingController(text: widget.brokerage.amount);
    _paidController = TextEditingController(text: widget.brokerage.brokeragePaid ?? '0');
    _remarksController = TextEditingController(text: widget.brokerage.remarks ?? '');
  }

  @override
  void dispose() {
    _brokerNameController.dispose();
    _amountController.dispose();
    _paidController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (isViewMode) {
      Navigator.of(context).pop();
      return;
    }

    // Validate fields here if needed

    // Create updated Brokerage object
    final updatedBrokerage = Brokerage(
      id: widget.brokerage.id,
      brokerId: widget.brokerage.brokerId,
      brokerName: _brokerNameController.text,
      amount: _amountController.text,
      brokeragePaid: _paidController.text,
      remarks: _remarksController.text,
      paymentStatus: widget.brokerage.paymentStatus,
    );

    // TODO: Update Vehicle with new Brokerage info using Riverpod notifier
    // ref.read(vehicleProvider.notifier).updateBrokerage(widget.vehicle, updatedBrokerage);

    // Close dialog after submit
    Navigator.of(context).pop(updatedBrokerage);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isViewMode ? 'View Brokerage' : 'Edit Brokerage'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _brokerNameController,
              enabled: false, // brokerName should not be editable
              decoration: const InputDecoration(labelText: 'Broker Name'),
            ),
            TextFormField(
              controller: _amountController,
              enabled: !isViewMode,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            TextFormField(
              controller: _paidController,
              enabled: !isViewMode,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Paid Amount'),
            ),
            TextFormField(
              controller: _remarksController,
              enabled: !isViewMode,
              decoration: const InputDecoration(labelText: 'Remarks'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        if (!isViewMode)
          ElevatedButton(
            onPressed: _onSubmit,
            child: const Text('Save'),
          ),
        if (isViewMode)
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
      ],
    );
  }
}
