import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_new_project/application/navigation/navigation_provider.dart';
import 'package:my_new_project/core/constants/constant.dart';

class CustomHeader extends ConsumerWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onFilter;
  final VoidCallback? onRefresh;
  final VoidCallback? onSearch;
  final VoidCallback? onAdd;
  final bool showAdd;
  final Widget? customActions;

  const CustomHeader({
    super.key,
    required this.title,
    this.onBack,
    this.onFilter,
    this.onRefresh,
    this.onSearch,
    this.onAdd,
    this.showAdd = false,
    this.customActions,
  });

  Widget _buildIconButton(IconData icon, VoidCallback? onPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: SizedBox(
        width: 36,
        height: 36,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            padding: EdgeInsets.zero,
            iconSize: 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultOnBack = () {
      final success = ref.read(navigationProvider.notifier).goBack();
      if (!success) {
        ref
            .read(navigationProvider.notifier)
            .selectPage(0); // fallback Dashboard
      }
    };

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 First Row: Back + Title
          Row(
            children: [
              // _buildIconButton(
              //   Icons.arrow_back,
              //   onBack ?? () => Navigator.pop(context),
              // ),
              _buildIconButton(
                Icons.arrow_back,
                onBack ?? defaultOnBack,
                ),

              KWidth12,
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B1B3A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 🔹 Second Row: Custom or Default Actions
          ...(customActions != null
              ? [customActions!]
              : [
                  Row(
                    children: [
                      // _buildIconButton(Icons.filter_alt_outlined, onFilter),
                      // _buildIconButton(Icons.refresh, onRefresh),
                      // _buildIconButton(Icons.search, onSearch),
                      if (onFilter != null)
                        _buildIconButton(Icons.filter_alt_outlined, onFilter),
                      if (onRefresh != null)
                        _buildIconButton(Icons.refresh, onRefresh),
                      if (onSearch != null)
                        _buildIconButton(Icons.search, onSearch),
                      const Spacer(),
                      if (showAdd)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: SizedBox(
                            width: 36,
                            height: 36,
                            child: ElevatedButton(
                              onPressed: onAdd,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ]),
        ],
      ),
    );
  }
}
