import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';

class ScreenSettings extends ConsumerStatefulWidget {
  const ScreenSettings({super.key});

  @override
  ConsumerState<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends ConsumerState<ScreenSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "App Settings",
              onBack: () {
                //back to previous one
              },
            ),

            KHeight30, // Spacer between title and options

            GestureDetector(
              onTap: () {
                // Navigate to profile settings
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'Profile Settings',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
            Divider(),

            GestureDetector(
              onTap: () {
                // Navigate to other settings
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'Other Settings',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
