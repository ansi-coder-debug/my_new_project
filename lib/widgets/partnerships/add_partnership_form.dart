

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/partnership.dart';

class AddPartnershipForm extends StatefulWidget {
  final VoidCallback? onCancel;
  final VoidCallback onAddComplete;
  final Partnership? partnershipToEdit;

  const AddPartnershipForm({
    super.key,
    this.onCancel,
    this.partnershipToEdit,
    required this.onAddComplete,
  });

  @override
  State<AddPartnershipForm> createState() => _AddPartnershipFormState();
}

class _AddPartnershipFormState extends State<AddPartnershipForm> {
  final TextEditingController _partnerNameController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _sharePercentageController =
      TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  @override
  void dispose() {
    _partnerNameController.dispose();
    _contactPersonController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    _sharePercentageController.dispose();
    _startDateController.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.partnershipToEdit != null) {
      final ptp = widget.partnershipToEdit!;
      _partnerNameController.text = ptp.partnerName;
      _contactPersonController.text = ptp.contactPerson;
      _contactEmailController.text = ptp.email;
      _contactPhoneController.text = ptp.phone;
      _sharePercentageController.text = ptp.sharePercentage;
      _startDateController.text = ptp.startDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Partner Name", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _partnerNameController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight,
            Text("Contact Person", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _contactPersonController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight,
            Text("Contact Email", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _contactEmailController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight,
            Text("Contact Phone", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _contactPhoneController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight,
            Text("Share Percentage", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _sharePercentageController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight,
            Text("StartDate", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _startDateController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onCancel?.call();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    final box = Hive.box<Partnership>('partnerships');

                    final newPartnership = Partnership(
                      id: _idController.text,
                      partnerName: _partnerNameController.text,
                      contactPerson: _contactPersonController.text,
                      email: _contactEmailController.text,
                      phone: _contactPhoneController.text,
                      sharePercentage: _sharePercentageController.text,
                      vehicleId: 'unLinked',
                      startDate: _startDateController.text,
                    );

                    if (widget.partnershipToEdit != null) {
                      final Key = widget.partnershipToEdit!.key;
                      await box.put(Key, newPartnership);
                      print('Partnership Updated');
                    } else {
                      await box.add(newPartnership);
                      print('Partnership Added');
                    }
                    widget.onAddComplete();
                  },

                  child: Text(
                    'Add Partnership',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
