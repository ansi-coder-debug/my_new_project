import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget bodyContent;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final double? width;
  final double? height; // ✅ Manually adjustable height

  const CustomDialog({
    Key? key,
    required this.title,
    required this.bodyContent,
    required this.onSubmit,
    required this.onCancel,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: width ?? size.width,
        height: height ?? size.height * 0.6, // ✅ Default height is 60% screen
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              // Title & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF1B1B3A)),
                    onPressed: onCancel,
                  ),
                ],
              ),
              // const SizedBox(height: 12),
              KHeight,

              // Scrollable Content Area (fills space)
              Expanded(
                child: SingleChildScrollView(
                  child: bodyContent,
                ),
              ),

              // const SizedBox(height: 24),
              KHeight,

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF1B1B3A)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                    onPressed: onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A0A33),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
