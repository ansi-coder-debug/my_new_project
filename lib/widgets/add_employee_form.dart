import 'package:flutter/material.dart';

class AddEmployeeForm extends StatefulWidget {
  final VoidCallback? onCancel;
  final VoidCallback onAddComplete;

  const AddEmployeeForm({
    super.key,
    this.onCancel,
    required this.onAddComplete,
  });
  @override
  State<AddEmployeeForm> createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends State<AddEmployeeForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _joiningYearController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              "Name",
              style: TextStyle(color: Colors.black)

            ),
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

            )

            //write code here on tommorow
          ],
        ),
        ),
    );
  }
}
