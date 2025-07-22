import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/partnership.dart';
import 'package:my_new_project/core/models/vehicle.dart';
import 'package:uuid/uuid.dart';

class AddVehicleForm extends StatefulWidget {
  final VoidCallback? onCancel;
  final VoidCallback onAddComplete;
  final Vehicle? vehicleToEdit;

  const AddVehicleForm({
    super.key,
    this.onCancel,
    required this.onAddComplete,
    this.vehicleToEdit,
  });

  @override
  State<AddVehicleForm> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<AddVehicleForm> {
  File? _pickedImage;
  bool _showPartnershipFields = false;
  DateTime? _startDate;

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final PickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (PickedFile != null) {
      setState(() {
        _pickedImage = File(PickedFile.path);
      });
    }
  }

  String? selectedStatus;

  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _vinController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  // Partnership controllers
  final TextEditingController _partnerNameController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _sharePercentageController =
      TextEditingController();

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _mileageController.dispose();
    _colorController.dispose();
    _vinController.dispose();
    _imageUrlController.dispose();
    _idController.dispose();
    _yearController.dispose();
    //partnership dispose
    _partnerNameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _sharePercentageController.dispose();
  }

  @override
  void initState() {
    super.initState();

    final vehicle = widget.vehicleToEdit;
    final uuid = Uuid(); // ✅ Add this

    if (vehicle != null) {
      _makeController.text = vehicle.title;
      _imageUrlController.text = vehicle.imageUrl;
      _yearController.text = vehicle.year;
      _priceController.text = vehicle.price;
      _mileageController.text = vehicle.mileage;
      _colorController.text = vehicle.color;
      _vinController.text = vehicle.vin;
      selectedStatus = vehicle.status;
    } else {
      _idController.text = uuid.v4(); // ✅ Auto-generate a new unique ID
    }
  }

  //partnership field _buildtextfield
  Widget _buildTextField(TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.black)),
        SizedBox(height: 4),
        TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            border: OutlineInputBorder(),
          ),
        ),

        SizedBox(height: 16),
      ],
    );
  }

  // condition to check partnership field is empty or not if empty vehicle details save
  bool isPartnershipFilled() {
    return _partnerNameController.text.trim().isNotEmpty ||
        _contactPersonController.text.trim().isNotEmpty ||
        _emailController.text.trim().isNotEmpty ||
        _phoneController.text.trim().isNotEmpty ||
        _sharePercentageController.text.trim().isNotEmpty ||
        _startDate != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Vehicle ID', style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _idController,
              readOnly: true, // Optional: prevent users from modifying it
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight16,

            Text('Make', style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _makeController,
              style: TextStyle(color: Colors.black),

              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight16,
            Text('Model', style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _modelController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight16,
            Text('Year', style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _yearController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight16,
            TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16),

            // Price
            Text('Price', style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _priceController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight16,

            // Mileage
            Text('Mileage', style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _mileageController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight16,

            // VIN
            Text('VIN', style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _vinController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight16,
            // Color
            Text('Color', style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _colorController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            KHeight16,

            // Status
            Text('Status', style: TextStyle(color: Colors.black)),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: InputDecoration(border: OutlineInputBorder()),

              items: ['Available', 'Pending Sale', 'Sold', 'In Maintenance']
                  .map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  })
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
            ),

            // TextFormField(
            //   decoration: InputDecoration(
            //     contentPadding: EdgeInsets.symmetric(
            //       vertical: 8,
            //       horizontal: 12,
            //     ),
            //     border: OutlineInputBorder(),
            //   ),
            //   style: TextStyle(color: Colors.black),
            // ),
            KHeight16,

            // Purchase Date
            Text('Purchase Date', style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _purchaseDateController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
            ),
            KHeight16,

            // Description
            Text('Description', style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3, // multi-line for description
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
            ),
            KHeight16,

            // Photos (could be a custom widget or placeholder for now)
            Text('Photos', style: TextStyle(color: Colors.black)),

            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                hintText: 'Add photo URL or use file picker',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 4),

                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    label: Text('Add', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            if (_pickedImage != null)
              Container(
                height: 150,
                width: double.infinity,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Image.file(_pickedImage!, fit: BoxFit.cover),
              ),

            KHeight,
            //partnership listtile can also use
            GestureDetector(
              onTap: () {
                setState(() {
                  _showPartnershipFields = !_showPartnershipFields;
                });
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.group_add, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(
                      'Add Partnership (Optional)',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        // fontWeight: FontWeight.bold
                      ),
                    ),
                    Spacer(),
                    Icon(
                      _showPartnershipFields
                          ? Icons.expand_less
                          : Icons.expand_more,
                    ),
                  ],
                ),
              ),
            ),
            //dropdown of partnership fields
            if (_showPartnershipFields)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  _buildTextField(_partnerNameController, 'Partner Name'),
                  _buildTextField(_contactPersonController, 'Contact Person'),
                  _buildTextField(_emailController, 'Email'),
                  _buildTextField(_phoneController, 'Phone'),
                  _buildTextField(_sharePercentageController, 'Share %'),
                  Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 16),
                    child: InkWell(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _startDate = picked;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Start Date',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          _startDate != null
                              ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                              : 'Select Start Date',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            KHeight,

            Row(
              children: [
                SizedBox(width: 90),
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
                    final box = Hive.box<Vehicle>('vehicles');

                    final newVehicle = Vehicle(
                      id: _idController.text,
                      title: '${_makeController.text}${_modelController.text}',
                      // where gallery adding saving logic
                      imageUrl: _pickedImage != null
                          ? _pickedImage!.path
                          : _imageUrlController.text,

                      year: _yearController.text,
                      price: _priceController.text,
                      mileage: _mileageController.text,
                      color: _colorController.text,
                      vin: _vinController.text,
                      description: _descriptionController.text,
                      purchaseDate: _purchaseDateController.text,
                      // description: _descriptionController.text,
                      task: '0',
                      status: selectedStatus ?? 'Available',

                      //partnership

                      //                 partnership: isPartnershipFilled()
                      // ? Partnership(
                      //     partnerName: _partnerNameController.text,
                      //     contactPerson: _contactPersonController.text,
                      //     email: _emailController.text,
                      //     phone: _phoneController.text,
                      //     sharePercentage:
                      //         double.tryParse(_sharePercentageController.text) ?? 0.0,
                      //     startDate: _startDate ?? DateTime.now(),
                      //   )
                      // : null,
                      partnership: isPartnershipFilled()
                          ? Partnership(
                              id: _idController.text,
                              partnerName: _partnerNameController.text,
                              contactPerson: _contactPersonController.text,
                              email: _emailController.text,
                              phone: _phoneController.text,
                              sharePercentage: _sharePercentageController.text,
                              vehicleId: _idController.text,
                              startDate: (_startDate ?? DateTime.now())
                                  .toIso8601String(),
                            )
                          : null,
                    );

                    //edit and add data to Hive
                    if (widget.vehicleToEdit != null) {
                      //edit mode
                      final Key = widget.vehicleToEdit!.key;
                      await box.put(Key, newVehicle);
                      print('Vehicle updated!');
                    } else {



                      //add mode using String id as key
                      await box.put(newVehicle.id,newVehicle);
                      print('Vehicle added');

                      if (newVehicle.partnership != null) {
                        await Hive.box<Partnership>(
                          'partnerships',
                        ).put(newVehicle.partnership!.id,newVehicle.partnership!);
                      }
                    }







                    //close the form
                    widget.onAddComplete();
                  },
                  child: Text(
                    'Add Vehicle',
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
