import 'dart:ui';

import 'package:flutter/material.dart';

class CustomHeaderSummary extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onFilter;
  final VoidCallback? onRefresh;
  final Widget? headerContent; // Custom row of buttons or controls

  const CustomHeaderSummary({
    super.key,
    required this.title,
    this.onBack,
    this.onFilter,
    this.onRefresh,
    this.headerContent,
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
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First row: Back + Title
          Row(
            children: [
              _buildIconButton(
                Icons.arrow_back,
                onBack ?? () => Navigator.pop(context),
              ),
              const SizedBox(width: 12),
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

          // Second row: Either custom content or default filter+refresh buttons
          headerContent ??
              Row(
                children: [
                  if (onFilter != null)
                    _buildIconButton(Icons.filter_alt_outlined, onFilter),
                  if (onRefresh != null)
                    _buildIconButton(Icons.refresh, onRefresh),
                ],
              ),
        ],
      ),
    );
  }
}
