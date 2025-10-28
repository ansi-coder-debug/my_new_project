import 'package:flutter/material.dart';
import 'package:my_new_project/core/constants/constant.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget bodyContent;
  final VoidCallback? onSubmit;
  final VoidCallback onCancel;
  final VoidCallback? onDelete; // ✅ New delete callback

  final double? width;
  final double? height; // ✅ Manually adjustable height

  const CustomDialog({
    Key? key,
    required this.title,
    required this.bodyContent,
    // required this.onSubmit,
    this.onSubmit,
    required this.onCancel,
    this.onDelete,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.width, // ✅ Full width
          minWidth: size.width,
          // maxHeight: size.height * 0.9, // ✅ Optional safety limit
        ),

        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title & Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          
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
                Expanded(child: SingleChildScrollView(child: bodyContent)),

                // const SizedBox(height: 24),
                KHeight,

                // Buttons
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     OutlinedButton(
                //       onPressed: onCancel,
                //       style: OutlinedButton.styleFrom(
                //         side: const BorderSide(color: Color(0xFF1B1B3A)),
                //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //       ),
                //       child: const Text(
                //         "Cancel",
                //         style: TextStyle(
                //           color: Color(0xFF1B1B3A),
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 12),
                //     ElevatedButton(
                //       onPressed: onSubmit,
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: const Color(0xFF0A0A33),
                //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //       ),
                //       child: const Text(
                //         "Submit",
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onDelete != null)
                      // ✅ DELETE BUTTON (if delete callback is provided)
                      OutlinedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Confirm Delete"),
                              content: const Text(
                                "Are you sure you want to delete this?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                    ); // close small confirm dialog
                                    onDelete!(); // perform delete action
                                    onCancel(); // close main dialog
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      // ✅ ORIGINAL CANCEL BUTTON (default)
                      OutlinedButton(
                        onPressed: onCancel,
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
                      onPressed: onSubmit,
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
                      child: Text(
                        onDelete != null
                            ? "Update"
                            : "Submit", // ✅ Change label automatically
                        style: const TextStyle(
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
      ),
    );
  }
}
