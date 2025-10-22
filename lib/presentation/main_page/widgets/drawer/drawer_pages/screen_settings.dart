import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/navigation/navigation_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';
import 'package:my_new_project/widgets/reusable/custom_header.dart';
import 'package:my_new_project/widgets/settings/profile_settings.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeader(title: "App Settings"),

              KHeight30, // Spacer between title and options

              GestureDetector(
                onTap: () {
                  // Update navigation provider to go to profile settings page
                  ref
                      .read(navigationProvider.notifier)
                      .selectPage(23); // 23 = ProfileSettingsPage index
                },
                child: Text(
                  'Profile Settings',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Divider(),

              GestureDetector(
                onTap: () {
                  // Navigate to other settings
                },
                child: Text(
                  'Other Settings',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
