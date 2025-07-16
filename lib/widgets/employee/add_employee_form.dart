import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/employee.dart';

class AddEmployeeForm extends StatefulWidget {
  final VoidCallback? onCancel;
  final VoidCallback onAddComplete;
  final Employee? employeeToEdit;

  const AddEmployeeForm({
    super.key,
    this.onCancel,
    required this.onAddComplete,
    this.employeeToEdit,
  });
  @override
  State<AddEmployeeForm> createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends State<AddEmployeeForm> {
  File? _pickedImage;

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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _joiningYearController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _designationController.dispose();
    _joiningYearController.dispose();
    _phoneController.dispose();
    _salaryController.dispose();
    _imageUrlController.dispose();
    _idController.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.employeeToEdit != null) {
      final emp = widget.employeeToEdit!;
      _nameController.text = emp.name;
      _designationController.text = emp.designation;
      _joiningYearController.text = emp.joiningYear;  //for existing details pre editing 
      _phoneController.text = emp.phoneNumber;
      _salaryController.text = emp.salary;
      _imageUrlController.text = emp.imageUrl;
      _idController.text = emp.id;
      selectedStatus = emp.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Name", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _nameController,
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
            Text("Designation", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _designationController,
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
            Text("Id", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _idController,
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
            Text("Joining Year", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _joiningYearController,
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
            Text("Phone", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _phoneController,
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
            Text("Salary", style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _salaryController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(),
              ),
            ),

            Text('Address', style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _addressController,
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

            Text('Emergency Contact', style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _emergencyContactController,
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

            Text('Blood Group', style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _bloodGroupController,
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

            Text('Status', style: TextStyle(color: Colors.black)),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: InputDecoration(border: OutlineInputBorder()),

              items: ['Active','Inactive','Onleave'].map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
            ),
            KHeight16,

            Text('Description', style: TextStyle(color: Colors.black)),
            TextFormField(
              controller: _descriptionController,
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

            KHeight,
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
                    final box = Hive.box<Employee>('employees');

                    final newEmployee = Employee(
                      name: _nameController.text,
                      designation: _designationController.text,
                      joiningYear: _joiningYearController.text,
                      phoneNumber: _phoneController.text,
                      salary: _salaryController.text,
                      status: selectedStatus ?? 'Active',
                      id: _idController.text,
                      address: _addressController.text,
                      description: _descriptionController.text,
                      emergencyContact: _emergencyContactController.text,
                      bloodGroup: _bloodGroupController.text,
                      // where gallery adding saving logic
                      imageUrl: _pickedImage != null
                          ? _pickedImage!.path
                          : _imageUrlController.text,
                    );

                    if (widget.employeeToEdit != null) {
                      final Key = widget.employeeToEdit!.key;
                      await box.put(Key, newEmployee);
                      print('Employee Updated');
                    } else {
                      await box.add(newEmployee);
                      print('Employee Added');
                    }
                    widget.onAddComplete();
                  },

                  child: Text(
                    'Add Employee',
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

            //write code here on tommorow
          ],
        ),
      ),
    );
  }
}
