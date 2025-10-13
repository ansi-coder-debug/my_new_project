import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/expensetype/expensetype_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/core/models/expensetype.dart';
import 'package:my_new_project/widgets/reusable/custom_dialog.dart';

class AddExpenseTypeDialog extends ConsumerStatefulWidget {
  final ExpenseType? expenseType; // ✅ added
final bool isViewOnly; // ✅ added

  const AddExpenseTypeDialog({
    super.key,
     this.expenseType, // ✅ added
  this.isViewOnly = false, // ✅ added
    });

  @override
  ConsumerState<AddExpenseTypeDialog> createState() =>
      _AddExpenseTypeDialogState();
}

class _AddExpenseTypeDialogState extends ConsumerState<AddExpenseTypeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();


  @override
void initState() {
  super.initState();
  if (widget.expenseType != null) { // ✅ added
    _nameController.text = widget.expenseType!.name; // ✅ added
  }
}


  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF5F6FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.grey),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.blue, width: 2),
  ),
    );
  }

 Future<void> _submitForm() async {
  if (!_formKey.currentState!.validate()) return;

  try {
    final updatedExpenseType = ExpenseType(
      id: widget.expenseType?.id, // ✅ added to support editing
      userId: 0, // Optionally omit if backend uses token
      name: _nameController.text.trim(),
    );

    if (widget.expenseType != null) {
      // ✅ Editing existing expense type
      await ref
          .read(expenseTypeProvider.notifier)
          .updateExpenseType(updatedExpenseType); // ✅ updated method
      await ref.read(expenseTypeProvider.notifier).loadExpenseTypes();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense type updated')), // ✅ message
        );
      }
    } else {
      // ✅ Adding new expense type
      await ref
          .read(expenseTypeProvider.notifier)
          .addExpenseType(updatedExpenseType); // ✅ existing add logic
      await ref.read(expenseTypeProvider.notifier).loadExpenseTypes();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense type added successfully')),
        );
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save expense type: $e')), // ✅ generic error
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      // width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.25,

      title: widget.isViewOnly
    ? "View Expense Type"
    : (widget.expenseType != null ? "Edit Expense Type" : "Add Expense Type"), // ✅ modified

     onSubmit: widget.isViewOnly ? null : _submitForm, // ✅ modified

      onCancel: () => Navigator.of(context).pop(),
      bodyContent:SingleChildScrollView(
        child: 
       Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Colors.black),
              decoration: _inputDecoration("Expense Type Name"),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter expense type name';
                }
                return null;
              },
              enabled: !widget.isViewOnly, // ✅ added
            ),
            // KHeight30,
          ],
        ),
      ),
      ),
    );
  }
}



/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/expensetype/expensetype_provider.dart';
import 'package:my_new_project/core/models/expensetype.dart';

class AddExpenseTypeDialog extends ConsumerStatefulWidget {
  const AddExpenseTypeDialog({super.key});

  @override
  ConsumerState<AddExpenseTypeDialog> createState() => _AddExpenseTypeDialogState();
}

class _AddExpenseTypeDialogState extends ConsumerState<AddExpenseTypeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF5F6FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final newExpenseType = ExpenseType(
        userId: 0, // Optionally omit if backend uses token to infer this
        name: _nameController.text.trim(),
      );

      print('📤 Adding expense type: ${newExpenseType.toJson()}');

      await ref.read(expenseTypeProvider.notifier).addExpenseType(newExpenseType);
      await ref.read(expenseTypeProvider.notifier).loadExpenseTypes();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense type added successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add expense type: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Expense Type",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B1B3A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF1B1B3A)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.black),
                      decoration: _inputDecoration("Expense Type Name"),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter expense type name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1B1B3A)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Color(0xFF1B1B3A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A0A33),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/