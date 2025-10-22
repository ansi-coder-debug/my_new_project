import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/navigation/navigation_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
// Assuming your CustomHeader is in widgets/reusable/custom_header.dart
import 'package:my_new_project/widgets/reusable/custom_header.dart';

class ProfileSettingsPage extends ConsumerStatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  ConsumerState<ProfileSettingsPage> createState() =>
      _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends ConsumerState<ProfileSettingsPage> {
  // Use a TextEditingController to manage the company name text field
  final TextEditingController _companyNameController = TextEditingController();
  bool _isEditing = false; // To toggle between display and edit mode

  @override
void initState() {
  super.initState();
  _companyNameController.text = ref.read(companyNameProvider); // initial value
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light off-white background
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header for "Profile Settings"
            CustomHeader(title: "Profile Settings"),
            KHeight20, // Spacer below the header

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  elevation: 0, // Flat card as per the design
                  color: Colors.white, // White background for the card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.2), // Subtle border
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                      20.0,
                    ), // Padding inside the card
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align content to the left
                      children: [
                        Text(
                          'CompanyName',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),

                        // Text field
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F2F5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            controller: _companyNameController,
                            readOnly: !_isEditing,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onChanged: (value) {
                              // Update provider as user types
                              ref.read(companyNameProvider.notifier).state =
                                  value;
                            },
                          ),
                        ),

                        KHeight20, // Spacer
                        // Edit Name Button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = !_isEditing; // Toggle editing mode
                                // If _isEditing is false now (just finished editing),
                                // you might want to save the changes to your backend here.
                                if (!_isEditing) {
                                  print(
                                    'Company Name updated to: ${_companyNameController.text}',
                                  );
                                  // Call a method to save _companyNameController.text
                                }
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(
                                0xFFE6E8EA,
                              ), // Light grey background for button
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0, // No shadow
                            ),
                            child: Text(
                              _isEditing
                                  ? 'Save Name'
                                  : 'Edit Name', // Change button text based on mode
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87, // Dark text color
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
