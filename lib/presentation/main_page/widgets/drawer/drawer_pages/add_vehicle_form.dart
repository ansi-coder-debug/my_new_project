import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/vehicle.dart';

class AddVehicleForm extends StatefulWidget {
  final VoidCallback? onCancel;

  const AddVehicleForm({super.key, this.onCancel});

  @override
  State<AddVehicleForm> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<AddVehicleForm> {
  String? selectedStatus;

  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _vinController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  //
  final TextEditingController _yearController = TextEditingController();

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _mileageController.dispose();
    _colorController.dispose();
    _vinController.dispose();
    _imageUrlController.dispose();
    //
    _yearController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
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
              //
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
            KHeight16,

            // Purchase Date
            Text('Purchase Date', style: TextStyle(color: Colors.black)),
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
            KHeight16,

            // Description
            Text('Description', style: TextStyle(color: Colors.black)),
            TextFormField(
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
                    onPressed: () {},
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

            KHeight,

            Row(
              children: [
                SizedBox(width: 90),
                ElevatedButton(
                  onPressed: () {},
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
                  onPressed: () {
                    final newVehicle = Vehicle(
                      title: '${_makeController.text}${_modelController.text}',
                      imageUrl: _imageUrlController.text,
                      //
                      year: _yearController.text,
                      price: _priceController.text,
                      mileage: _mileageController.text,
                      color: _colorController.text,
                      vin: _vinController.text,
                      task: '0',
                      status: selectedStatus ?? 'Available',
                    );

                    //save to Hive
                    Hive.box<Vehicle>('vehicles').add(newVehicle);

                    //close the form
                    Navigator.pop(context);
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
