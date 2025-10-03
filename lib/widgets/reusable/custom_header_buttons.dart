import 'package:flutter/material.dart';

class SummaryHeaderButtons extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabSelected;
  final VoidCallback? onFilter;
  final VoidCallback? onRefresh;

  const SummaryHeaderButtons({
    Key? key,
    required this.selectedTab,
    required this.onTabSelected,
    this.onFilter,
    this.onRefresh,
  }) : super(key: key);

  Widget _buildTabButton(String tabName) {
    final bool isSelected = selectedTab == tabName.toLowerCase();
    return GestureDetector(
      onTap: () => onTabSelected(tabName.toLowerCase()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          tabName.toUpperCase(),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

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
    return Row(
      children: [
        _buildTabButton('Sales'),
        const SizedBox(width: 6),
        _buildTabButton('Purchases'),
        const SizedBox(width: 6),
        _buildTabButton('Expenses'),
        const Spacer(),
        if (onFilter != null)
          _buildIconButton(Icons.filter_alt_outlined, onFilter),
        if (onRefresh != null)
          _buildIconButton(Icons.refresh, onRefresh),
      ],
    );
  }
}
