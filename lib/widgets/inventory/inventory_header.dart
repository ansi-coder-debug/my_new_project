import 'package:flutter/material.dart';

class InventoryHeader extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onAdd;
  final String title;
  final String? selectedStatus;
  final ValueChanged<String?> onStatusSelected;
  final VoidCallback? onFilter;
  final VoidCallback? onRefresh;
  final VoidCallback? onSearch;
  

  const InventoryHeader({
    super.key,
    this.onBack,
    this.onAdd,
    required this.title,
    required this.selectedStatus,
    required this.onStatusSelected,
    this.onFilter,
    this.onRefresh,
    this.onSearch,
  });

  Widget _buildStatusChip(
    String label,
    bool selected,
    VoidCallback onTap,
    Color defaultBgColor
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? Colors.black: defaultBgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback? onPressed) {
    return SizedBox(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: Back, Title, Add button
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildIconButton(
                Icons.arrow_back,
                onBack ?? () => Navigator.pop(context),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B1B3A),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(36, 36),
                ),
                child: const Icon(Icons.add, size: 20, color: Colors.white),
              ),
            ],
          ),
        ),

        // Row 2: Filter chips
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              _buildStatusChip(
                "Available",
                selectedStatus == "Available",
                () => onStatusSelected(selectedStatus == "Available" ? null : "Available"),
                Colors.green.shade200
              ),
              const SizedBox(width: 8),
              _buildStatusChip(
                "Maintenance",
                selectedStatus == "Maintenance",
                () => onStatusSelected(selectedStatus == "Maintenance" ? null : "Maintenance"),
                 Colors.yellow.shade200
              ),
              const SizedBox(width: 8),
              _buildStatusChip(
                "Sold",
                selectedStatus == "Sold",
                () => onStatusSelected(selectedStatus == "Sold" ? null : "Sold"),
                 Colors.red.shade200
              ),
            ],
          ),
        ),

        // Row 3: Action buttons (Filter, Refresh, Search)
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              _buildIconButton(Icons.filter_alt_outlined, onFilter),
              _buildIconButton(Icons.refresh, onRefresh),
              _buildIconButton(Icons.search, onSearch),
            
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
